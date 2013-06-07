//
//  CreatureFactory.h
//  Swarm
//
//  Created by Justyn Spooner on 07/06/2013.
//
//

#import <Foundation/Foundation.h>
#import "Creature.h"

@interface CreatureFactory : NSObject

+ (id)sharedCreatureFactory;

- (void)createLife;

- (void)update:(NSTimeInterval)passedTime;

@property (nonatomic, strong) NSArray * creatures;

@end
