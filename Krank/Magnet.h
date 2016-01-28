//
//  Magnet.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Sprite.h"
#import "Particle.h"

@interface Magnet : Sprite

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)colorName num:(NSInteger)numValue;
- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)colorName num:(NSInteger)numValue;
- (void)onFrame:(NSTimeInterval)delta;
- (BOOL)collidesWithParticle:(Particle *)part;
- (void)applyAttractionForce:(Particle *)part;
- (void)startActions;
- (void)drawLines;

@property (nonatomic, readonly) NSInteger orbits;

@end
