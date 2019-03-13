@import UIKit;
@import GameController;
@import SpriteKit;

//#import "Globals.h"
#import "DLog.h"

@class KrankScene;
@class AppView;

//#if TARGET_OS_TV
@interface KrankViewController : GCEventViewController
//#else
//@interface KrankViewController : UIViewController
//#endif

@property (weak, nonatomic, nullable) SKView *gameView;
@property (weak, nonatomic, nullable) UIImageView *fadeView;
@property (weak, nonatomic, nullable) UIView *menuButtonsView;

@property (strong, nonatomic, nonnull) KrankScene *scene;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *menuRecognizer;
@property (strong, nonatomic) IBOutlet UIGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *twoTapRecognizer;
#if TARGET_OS_IOS
@property (nonatomic) UIDeviceOrientation stickToDeviceOrientation;
#endif

- (void)fadeOut:(NSTimeInterval)duration completion:(ActionHandler)completion;
- (void)fadeIn:(NSTimeInterval)duration completion:(ActionHandler)completion;

- (void)removeChildViewControllers;

@end
