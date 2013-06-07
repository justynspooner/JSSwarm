//
//  CreatureFactory.m
//  Swarm
//
//  Created by Justyn Spooner on 07/06/2013.
//
//

#import "CreatureFactory.h"

#define kTotalCreatures 50
#define kKnowledgeTimeInterval 1

@interface CreatureFactory ()

@property (nonatomic, assign) NSTimeInterval passedTime;
@property (nonatomic, assign) NSTimeInterval lastKnowledgeUpdate;

@end

@implementation CreatureFactory

+ (id)sharedCreatureFactory {
    static CreatureFactory *sharedCreatureFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCreatureFactory = [self new];
    });
    return sharedCreatureFactory;
}


- (void)createLife {
    NSMutableArray * creatures = [NSMutableArray array];
    
    for (int i = 0; i < kTotalCreatures; i++) {
        Creature * creature = [Creature imageWithContentsOfFile:@"bird.png"];
        [creatures addObject:creature];
    }
    
    self.creatures = [creatures copy];
}

- (void)update:(NSTimeInterval)passedTime {
    _passedTime = passedTime;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    if (_lastKnowledgeUpdate + kKnowledgeTimeInterval < currentTime) {
        // Knowledge updates are expensive so put them on a background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self updateKnowledge];
        });
        _lastKnowledgeUpdate = currentTime;
    }
    [self updateLocations];
}

- (void)updateLocations {
    float fallingSpeed = 100;
    float fallingDistance = fallingSpeed*_passedTime;
    
    for (Creature *creature in self.creatures)
    {
        // Get the creatures in the FOV
        
        
        //move the creature
        creature.y += fallingDistance;
        creature.rotation += _passedTime;
    }
}

- (void)updateKnowledge {
    // This can be done asynchronously
    NSLog(@"Updating knowledge");
}

@end
