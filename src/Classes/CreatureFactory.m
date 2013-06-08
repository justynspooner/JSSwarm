//
//  CreatureFactory.m
//  Swarm
//
//  Created by Justyn Spooner on 07/06/2013.
//
//

#import "CreatureFactory.h"

#define kTotalCreatures 50
#define kKnowledgeTimeInterval 0.2

// Blocks
typedef void (^ CreatureBlock)(id, int);

@interface CreatureFactory ()

@property (nonatomic, assign) NSTimeInterval passedTime;
@property (nonatomic, assign) NSTimeInterval lastKnowledgeUpdate;

@end

@implementation CreatureFactory

+ (id)sharedCreatureFactory {
    static CreatureFactory *sharedCreatureFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCreatureFactory)
            sharedCreatureFactory = [self new];
    });
    return sharedCreatureFactory;
}


- (void)createLife {
    NSMutableArray * creatures = [NSMutableArray array];
    
    for (int i = 0; i < kTotalCreatures; i++) {
        Creature * creature = [Creature new];
        creature.maxSpeed = 50.0;
        creature.name = [NSString stringWithFormat:@"Creature %i", i];
        creature.currentSpeed = creature.maxSpeed * [SPUtils randomFloat];
        [creatures addObject:creature];
    }
    
    self.creatures = [creatures copy];
}

- (void)update:(NSTimeInterval)passedTime {
    _passedTime = passedTime;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    if (_lastKnowledgeUpdate + kKnowledgeTimeInterval < currentTime) {
        
        // TODO: This should be done asynchronously
        [self updateKnowledge];
        
        _lastKnowledgeUpdate = currentTime;
    }
    [self updateLocations];
}

- (void)updateLocations {
    
    for (Creature *creature in self.creatures)
    {
        CGFloat randomX = [SPUtils randomFloat] - [SPUtils randomFloat];
        CGFloat randomY = [SPUtils randomFloat] - [SPUtils randomFloat];
        if ([creature.neighbours count]) {
            
            SPPoint * alignmentVector = [self alignmentForCreature:creature];
            SPPoint * cohesionVector = [self cohesionForCreature:creature];
            SPPoint * seperationVector = [self seperationForCreature:creature];
            
            
            creature.velocity.x = alignmentVector.x + cohesionVector.x + seperationVector.x + randomX;
            creature.velocity.y = alignmentVector.y + cohesionVector.y + seperationVector.y + randomY;
            
        }
        else {
            creature.velocity.x += randomX;
            creature.velocity.y += randomY;
        }
        if (![creature.velocity isEquivalent:[SPPoint pointWithX:0.0 y:0.0]]) {
            [creature.velocity normalize];
        }
        creature.x += creature.velocity.x * _passedTime;
        creature.y += creature.velocity.y * _passedTime;
        
//        creature.rotation += _passedTime;
    }
}

-(SPPoint *)alignmentForCreature:(Creature *)creature {
    SPPoint * alignmentVector = [SPPoint point];
    NSUInteger totalNeighbours = [creature.neighbours count];
    
    for (Creature * neighbour in creature.neighbours) {
        alignmentVector.x += neighbour.velocity.x;
        alignmentVector.y += neighbour.velocity.y;
    }
    alignmentVector.x /= totalNeighbours;
    alignmentVector.y /= totalNeighbours;
    if (![alignmentVector isEquivalent:[SPPoint pointWithX:0.0 y:0.0]]) {
        [alignmentVector normalize];
    }
    return alignmentVector;
}

-(SPPoint *)cohesionForCreature:(Creature *)creature {
    SPPoint * cohesionVector = [SPPoint point];
    NSUInteger totalNeighbours = [creature.neighbours count];
    
    for (Creature * neighbour in creature.neighbours) {
        cohesionVector.x += neighbour.x;
        cohesionVector.y += neighbour.y;
    }
    cohesionVector.x /= totalNeighbours;
    cohesionVector.y /= totalNeighbours;
    
    SPPoint * creatureCohesion = [SPPoint pointWithX:cohesionVector.x - creature.x y:cohesionVector.y - creature.y];
    if (![creatureCohesion isEquivalent:[SPPoint pointWithX:0.0 y:0.0]]) {
        [creatureCohesion normalize];
    }
    
    return creatureCohesion;
}

-(SPPoint *)seperationForCreature:(Creature *)creature {
    SPPoint * seperationVector = [SPPoint point];
    NSUInteger totalNeighbours = [creature.neighbours count];
    
    for (Creature * neighbour in creature.neighbours) {
        seperationVector.x += (neighbour.x - creature.x);
        seperationVector.y += (neighbour.y - creature.y);
    }
    
    seperationVector.x /= totalNeighbours;
    seperationVector.y /= totalNeighbours;
    
    seperationVector.x *= -1;
    seperationVector.y *= -1;
    
    if (![seperationVector isEquivalent:[SPPoint pointWithX:0.0 y:0.0]]) {
        [seperationVector normalize];
    }
    return seperationVector;
}

- (void)updateKnowledge {
    for (Creature *creature in self.creatures)
    {
        NSMutableArray * neightbours = [NSMutableArray array];
        for (Creature *neighbour in self.creatures)
        {
            // Skip ourself
            if ([creature isEqual:neighbour]) continue;
            
            // Get the creatures in the FOV
            SPPoint * creaturePoint = [SPPoint pointWithX:creature.x y:creature.y];
            SPPoint * neighbourPoint = [SPPoint pointWithX:neighbour.x y:neighbour.y];
            float distanceToNeighbour = [SPPoint distanceFromPoint:creaturePoint toPoint:neighbourPoint];
            if (distanceToNeighbour < 50) {
                [neightbours addObject:neighbour];
            }
        }
        
        creature.neighbours = [neightbours copy];
        
//        NSLog(@"%@ has %i neighbours", creature.name, [creature.neighbours count]);
    }
}

@end
