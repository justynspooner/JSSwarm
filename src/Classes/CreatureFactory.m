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
        Creature * creature = [Creature imageWithContentsOfFile:@"bird.png"];
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
        NSNumber * averageSpeed;
        if ([creature.neighbours count]) {
            averageSpeed = [creature valueForKeyPath:@"neighbours.@avg.currentSpeed"];
            //move the creature
            creature.y += averageSpeed.floatValue * _passedTime;
        }
        else {
            creature.y += creature.currentSpeed;
        }
        
//        creature.rotation += _passedTime;
    }
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
            if (distanceToNeighbour < 30) {
                [neightbours addObject:neighbour];
            }
        }
        
        creature.neighbours = [neightbours copy];
        
        NSLog(@"%@ has %i neighbours", creature.name, [creature.neighbours count]);
    }
}

@end
