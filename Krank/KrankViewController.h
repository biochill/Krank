@import UIKit;
@import SpriteKit;

@class KrankScene;
@class AppView;

#if TARGET_OS_TV
@interface KrankViewController : GCEventViewController
#else
@interface KrankViewController : UIViewController
#endif

@property (weak, nonatomic) SKView *gameView;
@property (weak, nonatomic) UIImageView *fadeView;
@property (weak, nonatomic) UIView *menuButtonsView;

@property (strong, nonatomic) KrankScene *scene;

#if TARGET_OS_TV
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *menuRecognizer;
#else
@property (strong, nonatomic) IBOutlet UIGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutlet UIGestureRecognizer *tapRecognizer;
@property (nonatomic) UIDeviceOrientation stickToDeviceOrientation;
#endif

- (void)fadeOut:(NSTimeInterval)duration completion:(ActionHandler)completion;
- (void)fadeIn:(NSTimeInterval)duration completion:(ActionHandler)completion;

@end
