#import "KrankViewController.h"
#import "Tools.h"
#import "Globals.h"
#import "PauseMenuView.h"
#import "KrankScene.h"

@interface KrankViewController ()
{
	BOOL _needsSetup;
}
@end

@implementation KrankViewController

- (void)viewDidLoad // additional setup after loading the view, typically from a nib
{
	[super viewDidLoad];

	// Somehow IB gets confused with iOS + tvOS storyboards and this class,
	// so we set the outlets manually.
	self.gameView = [self.view viewWithTag:1];
	self.fadeView = [self.view viewWithTag:2];
	self.menuButtonsView = [self.view viewWithTag:3];

	_needsSetup = YES;

#if HAVE_FPS && !HAVE_LEVEL_SCREENSHOTS
	self.gameView.showsFPS = YES;
	self.gameView.showsNodeCount = YES;
	self.gameView.showsDrawCount = YES;
#endif


#if !TARGET_OS_TV
	// Add 2-finger-swipe gesture
	UISwipeGestureRecognizer *recog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recog.numberOfTouchesRequired = 2;
	recog.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
	[self.gameView addGestureRecognizer:recog];

#if HAVE_CHEAT
	// Add 3-finger-swipe gesture
	recog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recog.numberOfTouchesRequired = 3;
	recog.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
	[self.gameView addGestureRecognizer:recog];
#endif

	// Update supported orientations
	if (k.input.accelerometerEnabled) {
		_stickToDeviceOrientation = [UIDevice currentDevice].orientation;
		[KrankViewController attemptRotationToDeviceOrientation];
	}

#endif
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
#if !TARGET_OS_TV
	if (k.input.accelerometerEnabled) {
		return _stickToDeviceOrientation == UIDeviceOrientationLandscapeLeft ? UIInterfaceOrientationMaskLandscapeLeft : UIInterfaceOrientationMaskLandscapeRight;
	}
#endif
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.view becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	// Game is launched here because now we know the actual screen width and height
	if (_needsSetup) {
		_needsSetup = NO;
		[self startGame];
	}
}

- (void)startGame
{
	// Create scene
	self.scene = [[KrankScene alloc] initWithSize:self.view.frame.size];
	[self.gameView presentScene:self.scene];

//	DLog(@"Scene frame %@", NSStringFromCGRect(self.scene.frame));

	// Create globals
	[KrankGlobals setupWithViewController:self];

	// Preload atlas and launch main menu
	[k.atlas preloadWithCompletionHandler:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[k.level menu];

			// Show initial image in fadeView (as specified in storyboard) until scene is built.
			// Somehow this takes 1-2 scene frames so we just wait.
			delay(0.04, ^{
				[UIView animateWithDuration:0.2 animations:^{
					self.fadeView.alpha = 0;
				} completion:^(BOOL finished) {
					self.fadeView.image = nil;
					self.fadeView.hidden = YES;
				}];
			});
		});
	}];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake) {
		if (k.level.currentLevelNumber != 0) {
#if HAVE_LEVEL_SCREENSHOTS || HAVE_CHEAT
#if HAVE_CHEAT
			[k.sound play:@"unlink"];
#endif
			[k.level next];
#else
			[k.level togglePause];
#endif
		}
	}
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)fadeOut:(NSTimeInterval)duration completion:(ActionHandler)completion
{
	self.fadeView.hidden = NO;
	self.fadeView.alpha = 0;
	[UIView animateWithDuration:duration animations:^{
		self.fadeView.alpha = 1; // fade it over the scene view
	} completion:^(BOOL finished) {
		if (completion) {
			completion();
		}
	}];
}

- (void)fadeIn:(NSTimeInterval)duration completion:(ActionHandler)completion
{
	self.fadeView.alpha = 1;
	[UIView animateWithDuration:duration animations:^{
		self.fadeView.alpha = 0;
	} completion:^(BOOL finished) {
		self.fadeView.hidden = YES;
		if (completion) {
			completion();
		}
	}];
}

#if TARGET_OS_TV

- (UIView *)preferredFocusedView
{
	PauseMenuView *menuView = k.cockpit.menuView;
	if (menuView.superview) {
		return menuView;
	}

	// Child viewcontrollers seem not to be asked for their preferredFocusedView so we do it manually here.
	// (In this case the child will be a LevelsViewController, there is only one in the array).
	UIViewController *viewController = self.childViewControllers.count != 0 ? self.childViewControllers[0] : nil;
	if (viewController) {
		return [viewController preferredFocusedView];
	}

	// If there are some menu buttons (in a menu level), return the first one.
	for (UIView *sub in self.menuButtonsView.subviews) {
		if ([sub isKindOfClass:[UIButton class]]) {
			return sub;
		}
	}

	return nil;
}

- (IBAction)menuPressed:(id)sender
{
	[k.level back];
}

#else

- (void)handleSwipe:(UIGestureRecognizer *)gestureRecognizer
{
	NSUInteger numTouches = [gestureRecognizer numberOfTouches];
	if (numTouches == 2)
	{
		if ([k.level.currentLevelName hasPrefix:@"level"]) {
			[k.level togglePause];
		} else {
			[k.level back];
		}
	}
#if HAVE_CHEAT
	else if (numTouches == 3) {
		[k.sound play:@"unlink"];
		[k.level next];
	}
#endif
}

#endif

@end
