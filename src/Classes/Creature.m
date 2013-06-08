//
//  Creature.m
//  Swarm
//
//  Created by Justyn Spooner on 07/06/2013.
//
//

#import "Creature.h"

@implementation Creature

-(id)init {
    self = [Creature imageWithContentsOfFile:@"bird.png"];
    if (self) {
        _velocity = [SPPoint point];
    }
    return self;
}

@end