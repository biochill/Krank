//
//  KrankScene.h
//  Krank
//
//  Created by Sven Thoennissen on 19.01.16.
//
//
@import SpriteKit;

@class Switch;

@interface KrankScene : SKScene

@property (nonatomic, strong, nullable) SKNode *background;
@property (nonatomic, strong, readonly, nonnull) SKNode *switches;
@property (nonatomic, strong, readonly, nonnull) SKNode *level;
@property (nonatomic, strong, readonly, nonnull) SKNode *player;
@property (nonatomic, strong, nullable) SKNode *preferredInitialFocusNode;
@property (nonatomic, strong, nullable) Switch *focusedSwitch;

- (void)setBackgroundImage:(UIImage * _Nonnull)image alpha:(CGFloat)alpha;
- (void)reset;

- (void)animateFocusToPosition:(CGPoint)toPosition radius:(CGFloat)radius selected:(BOOL)selected duration:(NSTimeInterval)duration animateOut:(BOOL)animateOut;
- (void)updateCursorStatus:(BOOL)selected;

@end
