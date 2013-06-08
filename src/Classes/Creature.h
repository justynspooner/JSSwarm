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

@property (nonatomic, strong) NSArray * neighbours;
@property (nonatomic, strong) Species * species;

// Real-time properties
@property (nonatomic, assign) CGFloat currentSpeed;
@property (nonatomic, strong) SPPoint * velocity;

// Characteristics
@property (nonatomic, assign) CGFloat maxSpeed;

@end
