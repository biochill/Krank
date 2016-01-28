#import "Globals.h"
#import "Particle.h"
#import "PauseMenuView.h"


KrankGlobals *k;


void delay(NSTimeInterval delay, dispatch_block_t handler) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), handler);
}


@interface KrankGlobals ()
@property (nonatomic) NSTimeInterval lastTimestamp;
@end


@implementation KrankGlobals

+ (KrankGlobals *)setupWithViewController:(KrankViewController *)viewController
{
	if (!k) {
		k = [[KrankGlobals alloc] initWithViewController:viewController];
	}
	return k;
}

- (id)initWithViewController:(KrankViewController *)viewController
{
	if ((self = [super init]))
	{
		k = self;
		_viewController = viewController;

#if TARGET_OS_TV
		// Particle images are 1.5 times larger than on iPad.
		// But screen height is only 1080/768 ~= 1.4 so we go with that. Otherwise anchors might be too far apart.
		_displayScaleFactor = 1.4;
#else
		_displayScaleFactor = 1;
#endif

		CGRect rect = viewController.view.bounds;

		CGFloat smallersize = fmin(rect.size.height, rect.size.width);
		CGFloat largeFontSize  = ceil(smallersize/12);
		CGFloat normalFontSize = ceil(smallersize/22);
		CGFloat smallFontSize  = ceil(smallersize/24);
		CGFloat tinyFontSize   = ceil(smallersize/28);
		CGFloat helpFontSize   = ceil(smallersize/34);

		_largeFont  = [UIFont fontWithName:@"QuigleyWiggly" size:largeFontSize];
		_normalFont = [UIFont fontWithName:@"QuigleyWiggly" size:normalFontSize];
		_smallFont  = [UIFont fontWithName:@"QuigleyWiggly" size:smallFontSize];
		_tinyFont   = [UIFont fontWithName:@"QuigleyWiggly" size:tinyFontSize];
#if TARGET_OS_TV
		_helpFont   = [UIFont fontWithName:@"GurmukhiMN-Bold" size:helpFontSize];
#else
		_helpFont   = [UIFont fontWithName:@"Palatino-Bold" size:helpFontSize];
#endif
		CGFloat cockpitHugeFontSize;
		CGFloat cockpitLargeFontSize;
		CGFloat cockpitSmallFontSize;

		cockpitHugeFontSize = 60*_displayScaleFactor;
		cockpitLargeFontSize = 40*_displayScaleFactor;
		cockpitSmallFontSize = 30*_displayScaleFactor;

		_hugeCockpitFont  = [UIFont fontWithName:@"QuigleyWiggly" size:cockpitHugeFontSize];
		_largeCockpitFont = [UIFont fontWithName:@"QuigleyWiggly" size:cockpitLargeFontSize];
		_smallCockpitFont = [UIFont fontWithName:@"QuigleyWiggly" size:cockpitSmallFontSize];

		_maxLevel = 30;
		_numBonusLevels = 1; // currently unused
		_lastTimestamp = 0;

		_config = [[Config alloc] init];
		_world = [[World alloc] initWithRect:rect];
		_input = [[Input alloc] init];
		_lines = [[Lines alloc] init];
		_particles = [[Particles alloc] init];
		_level = [[Level alloc] init];
		_cockpit = [[Cockpit alloc] init];
		_sound = [[Sound alloc] init];
		_effects = [[Effect alloc] init];

		// Game loop
		viewController.scene.delegate = self;
		viewController.scene.physicsWorld.contactDelegate = _particles;

		// Notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate:) name:UIApplicationWillTerminateNotification object:nil];

		[UIApplication sharedApplication].idleTimerDisabled = YES;

		[self makeTextureAtlas];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	_viewController.scene.delegate = nil;
	_viewController.scene.physicsWorld.contactDelegate = nil;
}

#pragma mark - Notifications

- (void)didBecomeActive:(NSNotification *)notification
{
	[_sound togglePause];

	// We have player with snake?
//	if (k.player) {
		// Resume game loop only if pause menu is not shown
//		if (k.cockpit.menuView.superview) {
//			_viewController.gameView.paused = YES;
//		}
//	}
}

- (void)willResignActive:(NSNotification *)notification
{
	[_sound togglePause];

	// Stop game loop no matter whether game is paused or not
//	_viewController.scene.paused = YES;
}

- (void)willTerminate:(NSNotification *)notification
{
	k = nil;
}

#pragma mark - SKSceneDelegate

- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
	// currentTime is the system uptime
//	DLog(@"%s %.3f", __PRETTY_FUNCTION__, currentTime);
	[self onFrame:currentTime];
}

//- (void)didEvaluateActionsForScene:(SKScene *)scene
//{
//}

- (void)didSimulatePhysicsForScene:(SKScene *)scene
{
	[_particles drawLines];
}

//- (void)didFinishUpdateForScene:(SKScene *)scene
//{
//}

- (void)displayLinkUpdate:(CADisplayLink *)sender
{
	[self onFrame:sender.timestamp];
}

- (void)onFrame:(NSTimeInterval)timestamp
{
// timestamp = system time

	[_lines clear];
		
	NSTimeInterval delta = fmin(timestamp - _lastTimestamp, 4.0/60.0);
	delta = fclamp(delta, 1.0/60, 2.0/60);
//	if (delta > 1.5/60) delta = 1.0/30.0;
//	else delta = 1.0/60;

    _lastTimestamp = timestamp;

//	self.reset = NO;

	if (_player) {
		[_input onFrame:delta];
	}
	[_sound onFrame:delta];
    [_level onFrame:delta];
}

- (void)makeTextureAtlas
{
#if TARGET_OS_TV
	_atlas = [SKTextureAtlas atlasNamed:@"Textures-tv"];
#else
	_atlas = [SKTextureAtlas atlasNamed:@"Textures-iOS"];
#endif
}

@end
