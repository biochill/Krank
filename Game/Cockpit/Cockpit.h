//
//  Cockpit.h

@import SpriteKit;

@class PauseMenuView;

@interface Cockpit : SKNode

- (void)setup;
- (void)onFrame:(NSTimeInterval)delta;
- (void)showPauseMenu;
- (void)hidePauseMenuAnimated:(BOOL)animated;

@end
