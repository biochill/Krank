//
//  Cockpit.m

#import "Cockpit.h"
#import "CockpitLabel.h"
#import "PauseMenuView.h"
#import "Globals.h"

@interface Cockpit ()
@property (nonatomic, strong) CockpitLabel *currentTimeView;
@property (nonatomic, strong) CockpitLabel *bestTimeView;
@property (nonatomic, strong) CockpitLabel *currentScoreView;
@property (nonatomic, strong) CockpitLabel *bestScoreView;
@property (nonatomic, strong) SKSpriteNode *currentLevelView;
@property (nonatomic) NSTimeInterval lastTime;
@property (nonatomic) NSInteger lastScore;
@end


@implementation Cockpit

- (instancetype)init
{
	if ((self = [super init])) 
    {
		self.zPosition = 100;
		self.name = @"hud";

		CGSize currentTimeSize = [@"00:00:00" sizeWithAttributes:@{NSFontAttributeName: k.largeCockpitFont}];
		CGSize bestTimeSize = [@"00:00:00" sizeWithAttributes:@{NSFontAttributeName: k.smallCockpitFont}];

//		_currentLevelView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:240*k.displayScaleFactor alignment:NSTextAlignmentCenter];

		_currentTimeView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:currentTimeSize.width alignment:NSTextAlignmentLeft];

		_bestTimeView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.smallCockpitFont textWidth:bestTimeSize.width alignment:NSTextAlignmentCenter];
//		_bestTimeView.dim = 0.5;

		_currentScoreView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:currentTimeSize.width alignment:NSTextAlignmentRight];

		_bestScoreView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.smallCockpitFont textWidth:bestTimeSize.width alignment:NSTextAlignmentCenter];
//		_bestScoreView.dim = 0.5;

        _menuView = [[PauseMenuView alloc] initWithFrame:k.viewController.view.bounds];

		// Notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statChangedNotification:) name:KrankBestStatChangedNotification object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:KrankBestStatChangedNotification object:nil];
}

#pragma mark - Notifications

- (void)statChangedNotification:(NSNotification *)notification
{
	NSString *stat = notification.object;
	if (stat) {

		NSDictionary *userInfo = notification.userInfo;
		NSInteger stage = [userInfo[@"stage"] integerValue];

		if (k.config.stage == stage) {

			NSInteger level = [userInfo[@"level"] integerValue];

			if (level == k.level.currentLevelNumber) {

				if ([stat isEqualToString:@"score"]) {

					if (self.bestScoreView.parent) {
						[self.bestScoreView setText:[NSString stringWithFormat:@"%d", (int)[k.config bestScore:level]]];
					} else {
						[self showBestScore:0];
					}

				} else if ([stat isEqualToString:@"time"]) {

					if (self.bestTimeView.parent) {
						self.bestTimeView.text = [Level timeString:[k.config bestTime:level] compact:NO];
					} else {
						[self showBestTime:0];
					}
				}
			}
		}

	} else {
		// Everything has changed

		NSInteger score = [k.config bestScore:k.level.currentLevelNumber];
		if (score) {
			if (self.bestScoreView.parent) {
				[self.bestScoreView setText:[NSString stringWithFormat:@"%d", (int)score]];
			} else {
				[self showBestScore:0];
			}
		} else {
			[self hideBestScore];
		}

		NSTimeInterval time = [k.config bestTime:k.level.currentLevelNumber];
		if (time != 0) {
			if (self.bestTimeView.parent) {
				self.bestTimeView.text = [Level timeString:time compact:NO];
			} else {
				[self showBestTime:0];
			}
		} else {
			[self hideBestTime];
		}

	}
}

#pragma mark - Pause

- (void)showPauseMenu
{
	// Fade current level view in
//	SKScene *scene = k.viewController.scene;
//	CGFloat h = CGRectGetHeight(scene.frame);
//	CGFloat cx = CGRectGetMidX(scene.frame);
//	if (self.currentLevelView.parent) {
//		[self.currentLevelView removeAllActions];
//	} else {
//		self.currentLevelView.position = CGPointMake(cx, h + self.currentLevelView.size.height);
//		self.currentLevelView.anchorPoint = CGPointMake(0.5, 1);
//		[self addChild:self.currentLevelView];
//	}
//	[self.currentLevelView runAction:[SKAction moveTo:CGPointMake(cx, h*0.975) duration:0.6]];

	// Pause the scene
	k.viewController.gameView.paused = YES;

    // Fade menu view and buttons in
	[k.viewController.view insertSubview:self.menuView belowSubview:k.viewController.fadeView];
	[self.menuView presentWithCompletion:^{
#if TARGET_OS_TV
		// Switch to UIKit taking game controller data and enable focus engine
		k.viewController.controllerUserInteractionEnabled = YES;
#endif
	}];
}

- (void)hidePauseMenuAnimated:(BOOL)animated
{
//	SKScene *scene = k.viewController.scene;
//	CGFloat h = CGRectGetHeight(scene.frame);
//	CGFloat cx = CGRectGetMidX(scene.frame);
//
//	CGPoint endPos = CGPointMake(cx, h + self.currentLevelView.size.height);
//
//	if (animated) {
//		[self.currentLevelView runAction:[SKAction moveTo:endPos duration:0.6] completion:^{
//			[self.currentLevelView removeFromParent];
//		}];
//	} else {
//		[self.currentLevelView removeFromParent];
//	}

	// Fade menu view and buttons out
	[self.menuView dismissAnimated:animated completion:^{
		[self.menuView removeFromSuperview];

		// Unpause the scene
		k.viewController.gameView.paused = NO;

#if TARGET_OS_TV
		// Switch to capturing game controllers raw data
		k.viewController.controllerUserInteractionEnabled = NO;
#endif
	}];
}

#pragma mark - HUD

- (void)setup
{
	_lastTime = 0;
	_lastScore = 0;

	NSInteger level = k.level.currentLevelNumber;

	if (level)
	{
		SKScene *scene = k.viewController.scene;
		CGFloat h = CGRectGetHeight(scene.frame);
		CGFloat w = CGRectGetWidth(scene.frame);
		CGFloat cx = CGRectGetMidX(scene.frame);

		// Current level (top center)
		[self.currentLevelView removeFromParent];
		[self.menuView setupCurrentLevelView];
		self.currentLevelView = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:_menuView.currentLevelView.image]];
		self.currentLevelView.position = CGPointMake(cx, h + self.currentLevelView.size.height);
		self.currentLevelView.anchorPoint = CGPointMake(0.5, 1);
		[self addChild:self.currentLevelView];

		// Current time (top left)
		self.currentTimeView.text = [k.level timeString];
		self.currentTimeView.position = CGPointMake(-self.currentTimeView.size.width, h*0.99);
		self.currentTimeView.anchorPoint = CGPointMake(0, 1);
		if (!self.currentTimeView.parent)
			[self addChild:self.currentTimeView];

		// Current score (top right)
		self.currentScoreView.text = [NSString stringWithFormat:@"%d", k.score];
		self.currentScoreView.position = CGPointMake(w + self.currentScoreView.size.width, h*0.99);
		self.currentScoreView.anchorPoint = CGPointMake(1, 1);
		if (!self.currentScoreView.parent)
			[self addChild:self.currentScoreView];

		//
		// Animate in
		//
		SKAction *action1 = [SKAction moveTo:CGPointMake(cx, h*0.99) duration:1.5];
		action1.timingMode = SKActionTimingEaseOut;
		SKAction *action2 = [SKAction moveTo:CGPointMake(cx, h + self.currentLevelView.size.height) duration:1.5];
		action2.timingMode = SKActionTimingEaseIn;
		[self.currentLevelView runAction:[SKAction sequence:@[action1, [SKAction waitForDuration:1.5], action2, [SKAction removeFromParent]]]];

		action1 = [SKAction moveTo:CGPointMake(w*0.02, self.currentTimeView.position.y) duration:1.5];
		action1.timingMode = SKActionTimingEaseOut;
		[self.currentTimeView runAction:action1];

		action1 = [SKAction moveTo:CGPointMake(w*0.98, self.currentTimeView.position.y) duration:1.5];
		action1.timingMode = SKActionTimingEaseOut;
		[self.currentScoreView runAction:action1];

		//
		// Best time & score
		//
		if ([k.config bestScore:level] > 0) {
			[self showBestScore:0.7];
		} else {
			[self.bestScoreView removeFromParent];
		}
		if ([k.config bestTime:level] > 0) {
			[self showBestTime:0.7];
		} else {
			[self.bestTimeView removeFromParent];
		}
	}
	else
	{
		// Abort animations in progress if any
		[self.currentLevelView removeFromParent];
		[self.currentTimeView removeFromParent];
		[self.currentScoreView removeFromParent];
		[self.bestScoreView removeFromParent];
		[self.bestTimeView removeFromParent];
	}
}

- (void)showBestScore:(NSTimeInterval)delay
{
	NSInteger level = k.level.currentLevelNumber;
	SKScene *scene = k.viewController.scene;
	CGFloat w = CGRectGetWidth(scene.frame);

	// Best score
	[self.bestScoreView setText:[NSString stringWithFormat:@"%d", (int)[k.config bestScore:level]]];
	self.bestScoreView.position = CGPointMake(w + self.bestScoreView.size.width/2, CGRectGetMinY(self.currentScoreView.frame) - 3);
	self.bestScoreView.anchorPoint = CGPointMake(0.5, 1);
	if (!self.bestScoreView.parent)
		[self addChild:self.bestScoreView];

	// Animate in
	SKAction *action1 = [SKAction moveToX:w*0.98 - self.currentScoreView.size.width/2 duration:1.5];
	action1.timingMode = SKActionTimingEaseOut;
	if (delay != 0)
		[self.bestScoreView runAction:[SKAction sequence:@[[SKAction waitForDuration:0.7], action1]]];
	else
		[self.bestScoreView runAction:action1];
}

- (void)hideBestScore
{
	SKScene *scene = k.viewController.scene;
	CGFloat w = CGRectGetWidth(scene.frame);

	SKAction *action1 = [SKAction moveToX:w + self.bestScoreView.size.width/2 duration:1.5];
	action1.timingMode = SKActionTimingEaseIn;
	[self.bestScoreView runAction:[SKAction sequence:@[action1, [SKAction removeFromParent]]]];
}

- (void)showBestTime:(NSTimeInterval)delay
{
	NSInteger level = k.level.currentLevelNumber;
	SKScene *scene = k.viewController.scene;
	CGFloat w = CGRectGetWidth(scene.frame);

	// Best time
	self.bestTimeView.text = [Level timeString:[k.config bestTime:level] compact:NO];
	self.bestTimeView.position = CGPointMake(-self.bestTimeView.size.width/2, CGRectGetMinY(self.currentTimeView.frame) - 3);
	self.bestTimeView.anchorPoint = CGPointMake(0.5, 1);
	if (!self.bestTimeView.parent)
		[self addChild:self.bestTimeView];

	// Animate in
	SKAction *action1 = [SKAction moveToX:w*0.02 + self.currentTimeView.size.width/2 duration:1.5];
	action1.timingMode = SKActionTimingEaseOut;
	if (delay != 0)
		[self.bestTimeView runAction:[SKAction sequence:@[[SKAction waitForDuration:0.7], action1]]];
	else
		[self.bestTimeView runAction:action1];
}

- (void)hideBestTime
{
	SKAction *action1 = [SKAction moveToX:-self.bestTimeView.size.width/2 duration:1.5];
	action1.timingMode = SKActionTimingEaseIn;
	[self.bestTimeView runAction:[SKAction sequence:@[action1, [SKAction removeFromParent]]]];
}

- (void)onFrame:(NSTimeInterval)delta
{
	if (!self.currentTimeView.hidden) {
		//
		// Update time string only when needed
		//
		NSTimeInterval levelTime = k.level.time;
		if (floor(levelTime) != floor(_lastTime)) {
			_lastTime = levelTime;
			self.currentTimeView.text = [k.level timeString];
		}
	}

	if (!self.currentScoreView.hidden) {
		//
		// Update score string only when needed
		//
		if (_lastScore != k.score) {
			_lastScore = k.score;
			self.currentScoreView.text = [NSString stringWithFormat:@"%d", (int)_lastScore];
		}
	}
}

@end
