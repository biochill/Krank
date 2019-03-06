//
//  Cockpit.h

@class PauseMenuView;

@interface Cockpit : SKNode

@property (nonatomic, strong) PauseMenuView *menuView;

- (void)setup;
- (void)onFrame:(NSTimeInterval)delta;
- (void)showPauseMenu;
- (void)hidePauseMenuAnimated:(BOOL)animated;

@end
