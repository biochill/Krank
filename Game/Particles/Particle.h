//
//  Particle.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

extern const NSInteger IsNotAPlayer; // 0 = particle is not player cursor
// Other player values: 1 = cursor main particle, 2 = first tail particle, 3 = second tail particle, etc.

@interface Particle : Sprite

//@property (nonatomic) CGPoint force;
@property (nonatomic, readonly) CGPoint vel; // velocity in SKScene coordinates
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic) CGFloat imass;
@property (nonatomic) CGFloat radius;
@property (nonatomic, readonly) NSInteger playerValue; // see above
@property (nonatomic, readonly) BOOL isPlayer;
//@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL captured;
@property (nonatomic) int identifier;

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)colorName;
- (instancetype)initWithPos:(CGPoint)aPos imageName:(NSString *)imageName;
- (instancetype)initWithPos:(CGPoint)aPos imageName:(NSString *)imageName player:(NSInteger)playerValue;
- (instancetype)initWithPos:(CGPoint)aPos imageName:(NSString *)imageName player:(NSInteger)playerValue drag:(CGFloat)dragValue;
- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)colorName imageName:(NSString *)imageName player:(NSInteger)playerValue;
- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)colorName imageName:(NSString *)imageName player:(NSInteger)playerValue drag:(CGFloat)dragValue;
- (void)collisionAction;
- (void)applyAccel:(CGPoint)accel;
- (void)calcForces:(NSTimeInterval)delta;
- (void)applyImpulse:(CGPoint)impulse;

@end
