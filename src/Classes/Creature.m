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
        _velocity = [SPPoint pointWithX:[SPUtils randomIntBetweenMin:0 andMax:10] y:[SPUtils randomIntBetweenMin:0 andMax:10]];
    }
    return self;
}

@end