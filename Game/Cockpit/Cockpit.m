//
//  Cockpit.m

#import "Cockpit.h"
#import "CockpitLabel.h"
#import "PauseViewController.h"
#import "Globals.h"

@interface Cockpit ()
@property (nonatomic, strong) CockpitLabel *currentTimeView;
@property (nonatomic, strong) CockpitLabel *bestTimeView;
@property (nonatomic, strong) CockpitLabel *currentScoreView;
@property (nonatomic, strong) CockpitLabel *bestScoreView;
@property (nonatomic, strong) CockpitLabel *currentLevelNode;
@property (nonatomic) NSTimeInterval lastTime;
@property (nonatomic) NSInteger lastScore;
@property (nonatomic, strong) PauseViewController *pauseViewController;
@end


@implementation Cockpit

- (instancetype)init
{
	if ((self = [super init])) 
    {
		self.zPosition = 20;
		self.name = @"hud";
		self.userInteractionEnabled = YES; // for pause node

		CGSize currentTimeSize = [@"00:00:00" sizeWithAttributes:@{NSFontAttributeName: k.largeCockpitFont}];
		CGSize bestTimeSize = [@"00:00:00" sizeWithAttributes:@{NSFontAttributeName: k.smallCockpitFont}];

//		_currentLevelView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:240*k.displayScaleFactor alignment:NSTextAlignmentCenter];

		_currentTimeView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:currentTimeSize.width alignment:NSTextAlignmentLeft];

		_bestTimeView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.smallCockpitFont textWidth:bestTimeSize.width alignment:NSTextAlignmentCenter];
//		_bestTimeView.dim = 0.5;

		_currentScoreView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:currentTimeSize.width alignment:NSTextAlignmentRight];

		_bestScoreView = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.smallCockpitFont textWidth:bestTimeSize.width alignment:NSTextAlignmentCenter];
//		_bestScoreView.dim = 0.5;

		_currentLevelNode = [[CockpitLabel alloc] initWithColor:[UIColor whiteColor] font:k.largeCockpitFont textWidth:0 alignment:NSTextAlignmentCenter];

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
	if (self.pauseViewController) return;

	// Pause the scene
	k.viewController.gameView.paused = YES;

	// Add new child viewController
	UIViewController *viewController = [k.viewController.storyboard instantiateViewControllerWithIdentifier:@"Pause"];
	[k.viewController addChildViewController:viewController];
	[k.viewController.view insertSubview:viewController.view aboveSubview:k.viewController.gameView];
	viewController.view.frame = k.viewController.view.bounds;
	[viewController didMoveToParentViewController:k.viewController];
	self.pauseViewController = (PauseViewController *)viewController;
}

- (void)hidePauseMenuAnimated:(BOOL)animated
{
	if (!self.pauseViewController) return;

	if (animated) {

		[self.pauseViewController animateOut:^{
			[k.viewController removeChildViewControllers];
			self.pauseViewController = nil;

			// Unpause the scene
			k.viewController.gameView.paused = NO;
		}];

	} else {

		[k.viewController removeChildViewControllers];
		self.pauseViewController = nil;

		// Unpause the scene
		k.viewController.gameView.paused = NO;
	}
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
//		UIImage *image = [PauseViewController makeCurrentLevelImage];
//		SKTexture *levelTex = [SKTexture textureWithImage:image];
//		self.currentLevelNode = [[SKSpriteNode alloc] initWithTexture:levelTex];
		self.currentLevelNode.text = [PauseViewController currentLevelText];
		self.currentLevelNode.position = CGPointMake(cx, h + self.currentLevelNode.size.height);
		self.currentLevelNode.anchorPoint = CGPointMake(0.5, 1);
		if (!self.currentLevelNode.parent)
			[self addChild:self.currentLevelNode];

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
		SKAction *action2 = [SKAction moveTo:CGPointMake(cx, h + self.currentLevelNode.size.height) duration:1.5];
		action2.timingMode = SKActionTimingEaseIn;
		[self.currentLevelNode runAction:[SKAction sequence:@[action1, [SKAction waitForDuration:3.0], action2, [SKAction removeFromParent]]]];

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
		[self.currentLevelNode removeFromParent];
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
	if (self.currentTimeView.parent) {
		//
		// Update time string only when needed
		//
		NSTimeInterval levelTime = k.level.time;
		if (floor(levelTime) != floor(_lastTime)) {
			_lastTime = levelTime;
			self.currentTimeView.text = [k.level timeString];
		}
	}

	if (self.currentScoreView.parent) {
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
