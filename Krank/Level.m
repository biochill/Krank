#import "Level.h"
#import "Level+Levels.h"
#import "Globals.h"
#import "PauseMenuView.h"


@interface Level ()
{
	BOOL _exit;
}
@property (strong, nonatomic) NSString *nextLevelName;
@end


@implementation Level

- (id)init
{
	if ((self = [super init])) 
    {
		_inTransition = NO;
	}
	return self;
}

//--------------------------------------------------------------------

- (void)togglePause
{
	if (self.inTransition) return;

	// Pause button has no function in a menu level
	if (![k.level.currentLevelName hasPrefix:@"level"]) {
		return;
	}

	if (self.paused)
	{
		[k.sound play:@"wall"];
		[k.cockpit hidePauseMenuAnimated:YES];
	}
	else
	{
		[k.sound play:@"link"];
		[k.cockpit showPauseMenu];
	}
}

- (BOOL)paused
{
	if (!k.cockpit.parent) {
		// In a menu; no pause available here
		return NO;
	}

	// In a game level: when menuView is in view hierarchy, it means the pause menu is up
	return k.cockpit.menuView.superview != nil;
}

//------------------------------------------------------------------------------------------------------------------------

+ (NSString *)timeString:(NSTimeInterval)interval compact:(BOOL)compact
{
	int s = interval;
	int m = s/60%60;
	int h = m/60;
	s %= 60;
	if (compact) {
		if (h)
			return [NSString stringWithFormat:@"%d:%02d:%02d", h, m, s];
		return [NSString stringWithFormat:@"%d:%02d", m, s];
	}
	return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}

- (NSString *)timeString
{
	return [Level timeString:_time compact:NO];
}

//------------------------------------------------------------------------------------------------------------------------

- (void)menu
{
	[self startLevelWithName:@"menu"];
}

- (void)menuExit:(NSString *)menu_level
{
// Exit from current level to a menu
	if (!_exit) {
		_exit = YES;
		[k.sound play:@"exit" volume:0.7];
		[self startLevelWithName:menu_level];
	}
}

- (void)startExit:(NSInteger)level
{
// Start level
    DLog(@"startExit %ld", (long)level);
	[k.sound play:@"exit" volume:0.7];
	[self startLevelWithNumber:level];
}

- (void)reset
{
	[k.sound play:@"unlink"];
	[self startLevelWithNumber:self.currentLevelNumber];
}

- (void)back
{
//    if      ([self.currentLevelName hasPrefix:@"menu_levels"])       [self menuExit:@"menu_play"];
    if ([self.currentLevelName hasPrefix:@"menu_help_"])        [self menuExit:@"menu_help"];
//    else if ([self.currentLevelName hasPrefix:@"menu_scores"] &&
//            ![self.currentLevelName isEqualToString:@"menu_scores"]) [self menuExit:@"menu_scores"];
    else if ([self.currentLevelName hasPrefix:@"menu_"])             [self menuExit:@"menu"];
    else if ([self.currentLevelName hasPrefix:@"level"])             [self menuExit:@"menu_levels"];
}

- (void)next
{
	NSInteger nextLevel = self.currentLevelNumber ? self.currentLevelNumber + 1 : 1;

	if (nextLevel <= k.maxLevel) {
		[self startLevelWithNumber:nextLevel];
	} else {
		DLog(@"%s no next level available, back to menu", __PRETTY_FUNCTION__);
		[self startLevelWithName:@"menu_levels"];
	}
}

//------------------------------------------------------------------------------------------------------------------------

- (void)onFrame:(NSTimeInterval)delta
{
	if (!_exit && !_inTransition && !self.paused)
    {
		_time += delta;

        [k.cockpit onFrame:delta];
		[k.particles onFrame:delta];
    }
    else if (!self.paused)
    {
        [k.particles onFrame:delta];
    }
//    [k.effects onFrame:delta];
}

//------------------------------------------------------------------------------------------------------------------------

- (BOOL)checkExit
{
//	DLog(@"checkExit: %d magnets and %d anchors left (cheat %d)", k.particles.numberOfMagnets, k.particles.numberOfAnchors, cheatExit);
	if (k.particles.numberOfMagnets == 0 && k.particles.numberOfAnchors == 0) {
		if (!_exit) {
			_exit = YES;
			[k.config score:self.currentLevelNumber];
			[k.sound play:@"exit"];// event:SoundEventIDNextLevel];
			delay(3, ^{
				[self next];
			});
			return YES;
		}
	}
	return NO;
}

//------------------------------------------------------------------------------------------------------------------------
#pragma mark - Functions which are not from the original Level.py

- (void)startLevelWithNumber:(NSInteger)level
{
	self.currentLevelNumber = level;
	[[NSUserDefaults standardUserDefaults] setInteger:level forKey:kConfigCurrentLevelNumber];
	[self startLevel:[NSString stringWithFormat:@"level%03d", (int)level]];
}

- (void)startLevelWithName:(NSString *)levelName
{
	self.currentLevelNumber = 0;
	[self startLevel:levelName];
}

- (void)startLevel:(NSString *)levelName
{
    DLog(@"%s %@", __PRETTY_FUNCTION__, levelName);

	_inTransition = YES;
	if (!self.currentLevelName) {
		// This is the first level ever started, skip fade-out animation
		[self changeLevel:levelName];
		[self didFinishLevelFadeIn];

	} else {
		// Transition from current level to next level

		NSTimeInterval duration = 0.7;

		if (![self nextLevel:levelName continuesMusicFromPreviousLevel:self.currentLevelName]) {
			[k.sound fadeMusic:duration];
		}

		self.nextLevelName = levelName;
		[k.viewController fadeOut:duration completion:^() {
			[self didFinishLevelFadeOut];
		}];
	}
}

- (void)didFinishLevelFadeOut
{
	[self changeLevel:self.nextLevelName];// completion:^{
		[k.viewController fadeIn:0.7 completion:^{
			[self didFinishLevelFadeIn];
		}];
//	}];
	self.nextLevelName = nil;
}

- (void)didFinishLevelFadeIn
{
	// finished fading in the new level
	_inTransition = NO;

#if HAVE_LEVEL_SCREENSHOTS

#if TARGET_OS_SIMULATOR
#warning For screenshot path names see console when running game levels!
#else
#error Screenshots only on simulator!
#endif

	if ([self.currentLevelName hasPrefix:@"level"]) {
		// Wait a bit to make sure that the fade-in has really finished
		delay(0.5, ^{
			[self snapshot];
		});
	} else if ([self.currentLevelName isEqualToString:@"menu"]) {
		delay(1.5, ^{
			[self snapshot];
		});
	}
#endif
}

#if HAVE_LEVEL_SCREENSHOTS
- (void)snapshot
{
	SKTexture *texture;
	NSString *fileName;

	k.cockpit.hidden = YES;

#if TARGET_OS_TV
	// tv

	// Back: Background
	k.viewController.scene.level.hidden = YES;
	k.viewController.scene.player.hidden = YES;
	k.viewController.scene.background.hidden = NO;
	k.viewController.scene.backgroundColor = [UIColor blackColor];
	texture = [k.viewController.gameView textureFromNode:k.viewController.scene];
	UIImage *image = [UIImage imageWithCGImage:texture.CGImage];
	if ([self.currentLevelName hasPrefix:@"level"]) {
		fileName = [NSString stringWithFormat:@"%@-%d-back", self.currentLevelName, (int)k.config.stage];
		[self saveScreenshot:image opaque:YES fileName:fileName];
	} else {
		fileName = [NSString stringWithFormat:@"%@-back", self.currentLevelName];
		[self saveScreenshot:image opaque:YES fileName:fileName]; // jpg (for launch image copy)
		[self saveScreenshot:image opaque:NO fileName:fileName]; // png (for real launch image)
	}

	if ([self.currentLevelName hasPrefix:@"level"]) {

		k.viewController.scene.background.hidden = YES;

		// Front: Player snake
		k.viewController.scene.level.hidden = YES;
		k.viewController.scene.player.hidden = NO;
		k.viewController.scene.background.hidden = YES;
		k.viewController.scene.backgroundColor = [UIColor clearColor];
		texture = [k.viewController.gameView textureFromNode:k.viewController.scene];
		fileName = [NSString stringWithFormat:@"%@-%d-front", self.currentLevelName, (int)k.config.stage];
		[self saveScreenshot:[UIImage imageWithCGImage:texture.CGImage] opaque:NO fileName:fileName];

		// Middle: Game elements
		k.viewController.scene.level.hidden = NO;
		k.viewController.scene.player.hidden = YES;
		k.viewController.scene.background.hidden = YES;
		texture = [k.viewController.gameView textureFromNode:k.viewController.scene];
		fileName = [NSString stringWithFormat:@"%@-%d-middle", self.currentLevelName, (int)k.config.stage];
		[self saveScreenshot:[UIImage imageWithCGImage:texture.CGImage] opaque:NO fileName:fileName];
	}

	k.viewController.scene.backgroundColor = [UIColor blackColor];
	k.viewController.scene.background.hidden = NO;
	k.viewController.scene.level.hidden = NO;
	k.viewController.scene.player.hidden = NO;

#else
	// iPad

	// Full screenshot with all subviews

	if ([self.currentLevelName isEqualToString:@"menu"]) {
		// Screenshot for launch image

		k.viewController.scene.level.hidden = YES;
		k.viewController.scene.player.hidden = YES;

		// @2x
		texture = [k.viewController.gameView textureFromNode:k.viewController.scene];
		fileName = [NSString stringWithFormat:@"%@@2x", self.currentLevelName];
		UIImage *image = [UIImage imageWithCGImage:texture.CGImage];
		[self saveScreenshot:image opaque:YES fileName:fileName]; // jpg (for launch image copy)
		[self saveScreenshot:image opaque:NO fileName:fileName]; // png (for real launch image)

		// 1x
		CGRect rect = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
		UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1);
		[image drawInRect:rect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		fileName = [NSString stringWithFormat:@"%@", self.currentLevelName];
		[self saveScreenshot:image opaque:YES fileName:fileName]; // jpg (for launch image copy)
		[self saveScreenshot:image opaque:NO fileName:fileName]; // png (for real launch image)

		k.viewController.scene.level.hidden = NO;
		k.viewController.scene.player.hidden = NO;

	} else {

		// @2x
		texture = [k.viewController.gameView textureFromNode:k.viewController.scene];
		fileName = [NSString stringWithFormat:@"%@-%d@2x", self.currentLevelName, (int)k.config.stage];
		UIImage *image = [UIImage imageWithCGImage:texture.CGImage];
		[self saveScreenshot:image opaque:YES fileName:fileName];

		// 1x
		CGRect rect = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
		UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1);
		[image drawInRect:rect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		fileName = [NSString stringWithFormat:@"%@-%d", self.currentLevelName, (int)k.config.stage];
		[self saveScreenshot:image opaque:YES fileName:fileName];
	}


#endif

	k.viewController.scene.backgroundColor = [UIColor blackColor];
	k.cockpit.hidden = NO;
}

//- (void)takeScreenshot:(NSString *)fileName
//{
//	BOOL opaque = k.viewController.gameView.opaque;
//	CGRect rect = k.viewController.gameView.bounds;
//	if ([fileName hasSuffix:@"@2x"])
//		UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 2);
//	else
//		UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 1);
//
//	[k.viewController.gameView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
//
//	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//
//	UIGraphicsEndImageContext();
//
//	[self saveScreenshot:image opaque:opaque fileName:fileName];
//}

- (void)saveScreenshot:(UIImage *)image opaque:(BOOL)opaque fileName:(NSString *)fileName
{
	NSData *data = opaque ? UIImageJPEGRepresentation(image, 0.8) : UIImagePNGRepresentation(image);
	NSString *ext = opaque ? @"jpg" : @"png";
	NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	url = [url URLByAppendingPathComponent:[fileName stringByAppendingPathExtension:ext]];
	if ([data writeToURL:url atomically:NO]) {
		DLog(@"Saved screenshot at %@", url);
	} else {
		DLog(@"Could not save screenshot at %@", url);
	}
}
#endif

- (void)resetLevel
{
	//
	// Clean up game
	//
	[k.particles reset];
	[k.effects reset];
	[k.player reset];
	[k.input reset];
	[k.sound reset];
	k.lines.lineType = LineTypeWhite;
	[k.lines clear];
	[k.cockpit hidePauseMenuAnimated:NO];

	// Reset scene
	[k.viewController.scene reset];

	// Remove child viewcontrollers, e.g. the viewcontroller added in menu_levels.m
	NSArray *children = [k.viewController.childViewControllers copy];
	for (UIViewController *viewController in children) {
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
		[viewController.view removeFromSuperview];
	}

#if TARGET_OS_TV
	// Clean up subviews
	for (UIView *view in k.viewController.menuButtonsView.subviews) {
		[view removeFromSuperview];
	}
	k.viewController.menuButtonsView.hidden = YES;

	k.viewController.menuRecognizer.enabled = NO;
#endif
}

// this method contains what was in the original Level() Python class constructor
- (void)changeLevel:(NSString *)levelName //completion:(ActionHandler)completion
{
	//DLog(@"changeLevel %@", levelName);
	[self resetLevel];

	// Reset some variables
	k.score = 0;
	_time = 0;
	//	k.reset = YES;
	_exit = NO;
	self.nextMusicName = nil;

	//
	// Execute level or menu setup
	//
	SEL sel = NSSelectorFromString([@"setup_" stringByAppendingString:levelName]);
	if (![self respondsToSelector:sel]) {
		DLog(@"Cannot start level '%@', going to main menu", levelName);
		sel = @selector(setup_menu);
		self.currentLevelNumber = 0;
	}
	
	// Use NSInvocation because we cannot use -performSelector: under ARC (which would result in an error)
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:sel]];
	invocation.target = self;
	invocation.selector = sel;

	// Allocate new player
	// Note that the new level may or may not invoke k.player.tailnum (such as menu_levels.m).
	k.player = [[Player alloc] init]; // show no cursor by default

	// If the new level is built by a child viewcontroller, k.player is set to nil in this invocation.
	[invocation invoke];

	//
	// Play music
	//
	if (!self.currentLevelName || ![self nextLevel:levelName continuesMusicFromPreviousLevel:self.currentLevelName]) {
		[k.sound music:self.nextMusicName ? self.nextMusicName : @"atmo"];
		self.nextMusicName = nil;
	}

	//
	// tvOS: When in a menu, disable player snake.
	// Apple TV HIG says that game menus should be navigated using the focus engine, not by a cursor.
	//
#if TARGET_OS_TV
	if (self.currentLevelNumber == 0) {
		k.player = nil; // no player snake in menu levels
	}
#endif

	//
	// Check if we have a snake or not.
	// Currently there is only one level which does not use a snake: menu_levels
	//
	if (k.player) {
		//
		// Player is available: this is a menu or level with the snake and particles.
		//

		// Add player snake
		[k.player setup];

		// Add lines and cockpit nodes
		if ([levelName hasPrefix:@"level"]) {
			[k.viewController.scene.level addChild:k.lines];
			[k.viewController.scene addChild:k.cockpit];
			[k.cockpit setup];
		}

		// Finish
#if TARGET_OS_TV
		k.viewController.controllerUserInteractionEnabled = NO; // disable focus engine
#endif
		[k.particles startActions];

	} else {
		//
		// No player available: this must be a menu with its own child viewcontroller (such as menu_levels).
		//

#if TARGET_OS_TV
		k.viewController.controllerUserInteractionEnabled = YES; // enable focus engine

		// Enable menu button for menu levels that do not have their own child viewcontroller.
		// The main menu must not recognize the menu button so the app goes back to the home screen (but the main menu has its own child viewcontroller anyway so this code does not enable the recognizer).
		if (k.viewController.childViewControllers.count == 0) {
			k.viewController.menuButtonsView.hidden = NO;
			k.viewController.menuRecognizer.enabled = YES;
			[k.viewController setNeedsFocusUpdate];
		}

#endif
//		k.viewController.gameView.paused = YES;
	}

	self.currentLevelName = levelName;
}

- (BOOL)nextLevel:(NSString *)nextLevel continuesMusicFromPreviousLevel:(NSString *)prevLevel
{
	return ([nextLevel hasPrefix:@"menu_levels"] && [prevLevel hasPrefix:@"menu"]) || [nextLevel hasPrefix:@"menu_help_"];
}

- (void)command:(NSString *)cmd
{
	//DLog(@"command: %s", [cmd UTF8String]);
	
	if (_inTransition || self.paused) return; // levelchange in progress
	
	if ([cmd isEqualToString:@"play"])
	{
//#if HAVE_ALL_LEVELS
		[self menuExit:@"menu_levels"];
//#else
//		if ([k.config numSolvedLevels] != 0) {
//			[self menuExit:@"menu_play"];
//		} else {
//			[self startExit:1];
//		}
//#endif
	}
	else if ([cmd hasPrefix:@"%"])              { [self menuExit:[cmd substringFromIndex:1]]; }
	else if ([cmd hasPrefix:@"#"])              { [k.config command:[cmd substringFromIndex:1]]; }
	else if ([cmd isEqualToString:@"back"])     { [self back]; }
	else if ([cmd isEqualToString:@"main"])     { [self menuExit:@"menu"]; }
//	else if ([cmd isEqualToString:@"continue"]) { [k.level startExit:[k.config continueLevelNumber]]; }
	else if ([cmd hasPrefix:@"stage."])         { [k.config setStage:[[cmd pathExtension] intValue]]; }
	else if ([cmd hasPrefix:@"startExit."])     { [self startExit:[[cmd pathExtension] intValue]]; }
}

@end


