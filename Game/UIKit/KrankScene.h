//
//  KrankScene.h
//  Krank
//
//  Created by Sven Thoennissen on 19.01.16.
//
//

@interface KrankScene : SKScene

@property (nonatomic, strong) SKNode *background;
@property (nonatomic, strong, readonly) SKNode *level;
@property (nonatomic, strong, readonly) SKNode *player;

- (void)setBackgroundImage:(UIImage *)image alpha:(CGFloat)alpha;
- (void)reset;

- (void)animateFocusToPosition:(CGPoint)position radius:(CGFloat)radius status:(BOOL)on duration:(NSTimeInterval)duration;
- (void)animateFocusOutWithTargetPosition:(CGPoint)target;
- (void)updateCursorStatus:(BOOL)cursorStatus;

@end
