//
//  Spring.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import <Foundation/Foundation.h>
#import "Particle.h"

@interface Spring : NSObject

@property (nonatomic, strong) Particle *p1, *p2;

//+ (SKPhysicsJointSpring *)jointWithLength:(double)length part1:(Particle *)part1 part2:(Particle *)part2 damp:(CGFloat)damp;

- (id)initWithLength:(CGFloat)length part1:(Particle *)part1 part2:(Particle *)part2 oneWay:(BOOL)oneWayValue spring:(CGFloat)spring damp:(CGFloat)damp;
- (void)calcForces:(NSTimeInterval)delta;
- (void)drawLine;

@end
