//
//  Player.h

#import <Foundation/Foundation.h>
#import "Particle.h"

@interface Player : NSObject

@property (nonatomic) CGPoint pos; // start position, in UIView coordinates
@property (nonatomic) NSInteger tailnum;
@property (nonatomic, strong, readonly) Particle *part;
@property (nonatomic, strong, readonly) SKFieldNode *gravityField;
@property (nonatomic, strong, readonly) SKFieldNode *dragField;

- (void)reset;
//- (void)onFrame:(NSTimeInterval)delta;
//- (void)setTailNum:(NSInteger)numTails direction:(CGFloat)direction;
- (void)setup;

@end
