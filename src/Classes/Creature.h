//
//  Creature.h
//  Swarm
//
//  Created by Justyn Spooner on 07/06/2013.
//
//

#import "SPImage.h"

@class Species;
@interface Creature : SPImage

@property (nonatomic, strong) Species * species;

@end
