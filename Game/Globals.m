#import "Globals.h"
#import "KrankViewController.h"
#import "Particle.h"
#import "HostTimeBase.h"

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
//#if TARGET_OS_TV
		_helpFont   = [UIFont fontWithName:@"GurmukhiMN-Bold" size:helpFontSize];
//#else
//		_helpFont   = [UIFont fontWithName:@"Palatino-Bold" size:helpFontSize];
//#endif

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

		// Notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate:) name:UIApplicationWillTerminateNotification object:nil];

		[UIApplication sharedApplication].idleTimerDisabled = YES;

		// Make texture atlas
#if TARGET_OS_TV
		_atlas = [SKTextureAtlas atlasNamed:@"Textures-tv"];
#else
		_atlas = [SKTextureAtlas atlasNamed:@"Textures-iOS"];
#endif
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
	[self.sound resume];
}

- (void)willResignActive:(NSNotification *)notification
{
	[self.sound pause];
}

- (void)willTerminate:(NSNotification *)notification
{
	k = nil;
}

#pragma mark - SKSceneDelegate

- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
	// This hook is called for each frame
	// currentTime is the system uptime

#if DEBUG
//	UInt64 time1 = GetCurrentTimeInNanos();

	[self onFrame:currentTime];

//	UInt64 time2 = GetCurrentTimeInNanos();
//	NSTimeInterval elapsed = (time2 - time1)*0.000000001;
//	DLog(@"%s frame elapsed=%.6f", __PRETTY_FUNCTION__, elapsed);
#else
	[self onFrame:currentTime];
#endif
}

- (void)didSimulatePhysicsForScene:(SKScene *)scene
{
	[_particles drawLines];
}

- (void)onFrame:(NSTimeInterval)timestamp
{
	// timestamp = system time in seconds

	[_lines clear];

	NSTimeInterval delta = fmin(timestamp - _lastTimestamp, 4.0/60.0);
	delta = fclamp(delta, 1.0/60, 2.0/60);

	_lastTimestamp = timestamp;

	if (_player) {
		[_input onFrame:delta];
	}
	[_sound onFrame:delta];
	[_level onFrame:delta];
}

@end
