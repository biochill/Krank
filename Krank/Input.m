//
//  Input.m

#import "Input.h"
#import "Globals.h"
#import "Tools.h"
#import "Sprite.h"


NSString *const InputControllerButtonPressed = @"InputControllerButtonPressed";


@interface Input ()
@property (nonatomic, strong) Sprite *target;
@property (nonatomic, strong) NSMutableArray *gameControllers;
@property (nonatomic) float lastXValue;
@property (nonatomic) float lastYValue;
#if TARGET_OS_TV
#else
@property (nonatomic, strong) CMMotionManager *motion;
@property (nonatomic) CGPoint currentVelocity;
@property (nonatomic) double lastAccelerometerX;
@property (nonatomic) double lastAccelerometerY;
#endif
@end


@implementation Input

- (instancetype)init
{
	if ((self = [super init])) {

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameControllerConnected:) name:GCControllerDidConnectNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameControllerDisconnected:) name:GCControllerDidDisconnectNotification object:nil];
		[self scanGameControllers];

		_lastXValue = 0;
		_lastYValue = 0;

#if TARGET_OS_TV
#else
		_motion = [[CMMotionManager alloc] init];
		if (self.accelerometerEnabled)
			[_motion startAccelerometerUpdates];

		_fingerDistance = 60;
		_currentVelocity = CGPointZero;
		_lastAccelerometerX = 0;
		_lastAccelerometerY = 0;
#endif
	}
	return self;
}

- (void)dealloc
{
//	DLog(@"%s %@", __PRETTY_FUNCTION__, self);
#if TARGET_OS_TV
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#else
	[_motion stopAccelerometerUpdates];
#endif
}

- (void)reset
{
	[_target removeFromParent];
	_lastXValue = 0;
	_lastYValue = 0;
}

#pragma mark - Game Controllers

- (void)scanGameControllers
{
	NSArray *controllers = [GCController controllers];
	_gameControllers = [NSMutableArray arrayWithArray:controllers];
	for (GCController *controller in controllers) {
		DLog(@"Found game controller, vendor='%@'", controller.vendorName);
		[self setupGameController:controller];
	}
}

- (void)setupGameController:(GCController *)controller
{
	controller.playerIndex = GCControllerPlayerIndex1;

	controller.controllerPausedHandler = ^(GCController *controller) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (k.level.currentLevelNumber) {
				// In game level: pause
				[k.level togglePause];
			} else {
				// In menu: go back
				[k.level back];
			}
		});
	};

#if HAVE_LEVEL_SCREENSHOTS
	if (controller.extendedGamepad) {
		controller.extendedGamepad.buttonX.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
			if (pressed) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[k.level next];
				});
			}
		};
	}
#endif

#if !TARGET_OS_TV
	if (controller.extendedGamepad) {

		[self setupDpad:controller.extendedGamepad.dpad];

		controller.extendedGamepad.buttonA.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
			if (pressed) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[[NSNotificationCenter defaultCenter] postNotificationName:InputControllerButtonPressed object:@"buttonA"];
				});
			}
		};

	} else if (controller.gamepad) {

		[self setupDpad:controller.gamepad.dpad];

		controller.gamepad.buttonA.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
			if (pressed) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[[NSNotificationCenter defaultCenter] postNotificationName:InputControllerButtonPressed object:@"buttonA"];
				});
			}
		};
	}
#endif
}

#if !TARGET_OS_TV
- (void)setupDpad:(GCControllerDirectionPad *)dpad
{
	dpad.up.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
		if (pressed) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:InputControllerButtonPressed object:@"up"];
			});
		}
	};

	dpad.down.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
		if (pressed) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:InputControllerButtonPressed object:@"down"];
			});
		}
	};

	dpad.left.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
		if (pressed) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:InputControllerButtonPressed object:@"left"];
			});
		}
	};

	dpad.right.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
		if (pressed) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:InputControllerButtonPressed object:@"right"];
			});
		}
	};
}
#endif

- (void)gameControllerConnected:(NSNotification *)notification
{
	GCController *controller = notification.object;
	DLog(@"%s vendor=%@", __PRETTY_FUNCTION__, controller.vendorName);
	[_gameControllers addObject:controller];
	[self setupGameController:controller];
}

- (void)gameControllerDisconnected:(NSNotification *)notification
{
	GCController *controller = notification.object;
	DLog(@"%s vendor=%@", __PRETTY_FUNCTION__, controller.vendorName);
	[_gameControllers removeObjectIdenticalTo:controller];
}

//-------------------------------------------------------------------------------
#pragma mark - Other

- (void)showTarget
{
	if (self.targetDisplayEnabled)
	{
		_target = [[Sprite alloc] init];
		_target.pos = self.targetPos; // convert from UIView to SKScene coordinates
		[_target setImageName:@"target"];
		_target.zPosition = 10;

		[k.viewController.scene.player addChild:_target];
	}
	else
	{
		[_target removeFromParent];
		_target = nil;
	}
}

//-------------------------------------------------------------------------------

- (void)setTargetDisplayEnabled:(BOOL)targetDisplayEnabled
{
	BOOL oldValue = [[NSUserDefaults standardUserDefaults] boolForKey:kConfigTargetEnabled];
	if (oldValue != targetDisplayEnabled) {
		[[NSUserDefaults standardUserDefaults] setBool:targetDisplayEnabled forKey:kConfigTargetEnabled];
#if !TARGET_OS_TV
		[self showTarget];
#endif
	}
}

- (BOOL)targetDisplayEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kConfigTargetEnabled];
}

//-------------------------------------------------------------------------------

#if !TARGET_OS_TV

- (void)setAccelerometerEnabled:(BOOL)accelerometerEnabled
{
	BOOL oldValue = [[NSUserDefaults standardUserDefaults] boolForKey:kConfigMotionEnabled];
	if (oldValue != accelerometerEnabled) {

		[[NSUserDefaults standardUserDefaults] setBool:accelerometerEnabled forKey:kConfigMotionEnabled];

		_currentVelocity = CGPointZero;
		_lastAccelerometerX = 0;
		_lastAccelerometerY = 0;

		if (accelerometerEnabled) {
			// view should keep the current orientation (either left or right)
			k.viewController.stickToDeviceOrientation = [UIDevice currentDevice].orientation;

			[_motion startAccelerometerUpdates];
		} else {
			[_motion stopAccelerometerUpdates];
		}

		// make iOS invoke -supportedInterfaceOrientations and update itself
		[KrankViewController attemptRotationToDeviceOrientation];
	}
}

- (BOOL)accelerometerEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kConfigMotionEnabled];
}

//-------------------------------------------------------------------------------

- (void)setFingerOffsetEnabled:(BOOL)fingerOffsetEnabled
{
	BOOL oldValue = [[NSUserDefaults standardUserDefaults] boolForKey:kConfigFingerOffsetEnabled];
	if (oldValue != fingerOffsetEnabled)
	{
		[[NSUserDefaults standardUserDefaults] setBool:fingerOffsetEnabled forKey:kConfigFingerOffsetEnabled];
	}
}

- (BOOL)fingerOffsetEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kConfigFingerOffsetEnabled];
}

#endif

//-------------------------------------------------------------------------------

- (void)setFingerPos:(CGPoint)fingerPos
{
	if (k.level.paused) {
		return;
	}
	
	_fingerPos = fingerPos;

	CGPoint pos = fingerPos;
#if !TARGET_OS_TV
	if (self.fingerOffsetEnabled) {
		pos.y -= _fingerDistance;
	}
#endif
	self.targetPos = pos;
}

- (void)jumpToFingerPos:(CGPoint)fingerPos
{
	self.fingerPos = fingerPos;

	if (_target) {
		// Small "thud!" effect on target
		[_target runAction:[SKAction sequence:@[[SKAction scaleTo:0.5 duration:0.15], [SKAction scaleTo:1 duration:0.15]]]];
	}

	// Add emitter to show some "dust" whirled up
	if ([k.sound.currentTheme isEqualToString:@"water"]) {
		SKNode *node = [k.effects targetDroplet];
		node.position = [k.world convertToScenePoint:fingerPos];
		[k.viewController.scene.background addChild:node];
	} else if ([k.sound.currentTheme isEqualToString:@"industry"]) {
		SKNode *node = [k.effects targetSteam];
		node.position = [k.world convertToScenePoint:fingerPos];
		[k.viewController.scene.background addChild:node];
	}
}

- (void)setTargetPos:(CGPoint)targetPos
{
	_targetPos = targetPos;

	CGPoint scenePos = [k.world convertToScenePoint:_targetPos];
	k.player.gravityField.position = scenePos;
	k.player.dragField.position = scenePos;
	_target.position = scenePos;
}

//------------------------------------------------------------------------------------------------------------------------

- (void)onFrame:(NSTimeInterval)delta
{
	if (k.level.paused) return;

#if !TARGET_OS_TV
	//
	// Read device accelerometer
	//
	if (self.accelerometerEnabled)
	{
		double sx = 0, sy = 0; // smoothed accelerometer values

		CMAccelerometerData *accelData = _motion.accelerometerData;
		if (accelData) {
			double x, y;
			x = accelData.acceleration.x;
			y = accelData.acceleration.y;

			double filteringFactor = 0.1;
			sx = fclamp(x * filteringFactor + _lastAccelerometerX * (1.0 - filteringFactor), -1.0, 1.0);
			sy = fclamp(y * filteringFactor + _lastAccelerometerY * (1.0 - filteringFactor), -1.0, 1.0);

			_lastAccelerometerX = sx;
			_lastAccelerometerY = sy;
		}

		CGPoint accel = CGPointMake(-sy, -sx);
		CGPoint vel = CGPointAddMult(_currentVelocity, accel, delta*50000);

		CGPoint newPos = CGPointAddMult(self.targetPos, vel, delta);
		CGRect rect = k.world.rect; // UIView coords
		newPos.x = fclamp(newPos.x, rect.origin.x, rect.size.width);
		newPos.y = fclamp(newPos.y, rect.origin.y, rect.size.height);
		self.targetPos = newPos;

//		DLog(@"accel: smoothed=(%.3f,%.3f) v=(%.3f,%.3f) target=(%.3f,%.3f)", sx, sy, vel.x, vel.y, newPos.x, newPos.y);
	}
#endif

	//
	// Read game controllers
	//

	float x = 0, y = 0;
	BOOL buttonA = NO;

	for (GCController *controller in _gameControllers) {

		// Read all values that can contribute to player movement

		if (controller.extendedGamepad) {

			GCExtendedGamepad *gamePad = controller.extendedGamepad;
			x += gamePad.leftThumbstick.xAxis.value;
			y += gamePad.leftThumbstick.yAxis.value;

			x += gamePad.rightThumbstick.xAxis.value;
			y += gamePad.rightThumbstick.yAxis.value;

			x += gamePad.dpad.xAxis.value;
			y += gamePad.dpad.yAxis.value;

			x -= gamePad.leftShoulder.value;
			x += gamePad.rightShoulder.value;

			x -= gamePad.leftTrigger.value;
			x += gamePad.rightTrigger.value;

			buttonA = gamePad.buttonA.pressed;

		} else if (controller.gamepad) {

			GCGamepad *gamePad = controller.gamepad;
			x += gamePad.dpad.xAxis.value;
			y += gamePad.dpad.yAxis.value;

			x -= gamePad.leftShoulder.value;
			x += gamePad.rightShoulder.value;

			buttonA = gamePad.buttonA.pressed;

		}
#if TARGET_OS_TV
		else if (controller.microGamepad) {

			GCMicroGamepad *gamePad = controller.microGamepad;
			x += gamePad.dpad.xAxis.value;
			y += gamePad.dpad.yAxis.value;

			buttonA = controller.microGamepad.buttonA.pressed;
		}
#endif
	} // for controllers

	float mult = buttonA ? 0.2 : 1;
	x = fclampf(x*mult, -1, 1);
	y = fclampf(y*mult, -1, 1);

	float filterFactor = 0.2;
	float sx = fclampf(x * filterFactor + _lastXValue * (1.0 - filterFactor), -1.0, 1.0);
	float sy = fclampf(y * filterFactor + _lastYValue * (1.0 - filterFactor), -1.0, 1.0);
	_lastXValue = sx;
	_lastYValue = sy;

	if (fabsf(sx) > 0.001 || fabsf(sy) > 0.001) {

//		DLog(@"Game controllers: xy=(%.3f, %.3f)", x, y);
		CGPoint dir = CGPointMake(sx, -sy);
		CGFloat maxVel = 170*k.displayScaleFactor;
		CGPoint vel = CGPointScale(dir, maxVel);
		CGPoint newPos = CGPointAddMult(k.player.part.pos, vel, 60*delta);
		CGRect rect = k.world.rect; // UIView coords
		newPos.x = fclamp(newPos.x, rect.origin.x, rect.size.width);
		newPos.y = fclamp(newPos.y, rect.origin.y, rect.size.height);
		self.targetPos = newPos;
	} else {
		_lastXValue = 0;
		_lastYValue = 0;
	}

}

@end
