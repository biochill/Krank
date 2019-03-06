#import "Player.h"
#import "Globals.h"
#import "Particle.h"
#import "Spring.h"


@interface Player ()
@property (nonatomic) double speedFactor;
@property (nonatomic) CGFloat maxTargetDistance;
@property (nonatomic, strong) SKFieldNode *leftBorderField;
@property (nonatomic, strong) SKFieldNode *rightBorderField;
@property (nonatomic, strong) SKFieldNode *topBorderField;
@property (nonatomic, strong) SKFieldNode *bottomBorderField;
@end


@implementation Player

- (id)init
{
	if ((self = [super init])) {
		[self reset];
	}
	return self;
}

- (void)dealloc
{
	[_gravityField removeFromParent];
	[_dragField removeFromParent];
	[_leftBorderField removeFromParent];
	[_rightBorderField removeFromParent];
	[_topBorderField removeFromParent];
	[_bottomBorderField removeFromParent];

#if !TARGET_OS_TV
	// Disable these gesture recognizers because the snake is gone
	k.viewController.panRecognizer.enabled = NO;
	k.viewController.tapRecognizer.enabled = NO;
	k.viewController.twoTapRecognizer.enabled = NO;
#endif
}

- (void)reset
{
	self.pos = k.world.center;
	self.speedFactor = 8;
	self.maxTargetDistance = 100;
	_tailnum = -1;
	_part = nil;

	[_gravityField removeFromParent];
	[_dragField removeFromParent];
	[_leftBorderField removeFromParent];
	[_rightBorderField removeFromParent];
	[_topBorderField removeFromParent];
	[_bottomBorderField removeFromParent];
}
/*
- (void)onFrame:(NSTimeInterval)delta
{
	self.pos = self.part.pos;

	CGPoint posToTarget = CGCreateVector(_pos, k.input.targetPos);

	CGFloat pttLength = CGPointLength(posToTarget);
	if (pttLength > _maxTargetDistance) {
		posToTarget = CGPointScale(CGPointNorm(posToTarget), _maxTargetDistance);
		pttLength = _maxTargetDistance;
	}

	_part.vel = CGPointAdd(_part.vel, CGPointScale(posToTarget, delta * _speedFactor));

	CGFloat length = CGPointLength(_part.vel);

	if (length > 0.001) {
		CGFloat nearFactor = (1-pttLength/_maxTargetDistance);
		CGFloat dragFactor = 0.002 + 0.09 * nearFactor * nearFactor * nearFactor;
		dragFactor *= delta;
		_part.vel = CGPointSub(_part.vel, CGPointScale(CGPointNorm(_part.vel), length*length*dragFactor));
	}
}
*/

- (void)setupFields
{
	_gravityField = [SKFieldNode springField];
	_gravityField.categoryBitMask = PHYSICS_FIELD_PLAYER;
	_gravityField.strength = 7;
	_gravityField.minimumRadius = 10;
	_gravityField.name = @"Player Gravity";

	_dragField = [SKFieldNode dragField];
	_dragField.categoryBitMask = PHYSICS_FIELD_PLAYER;
	_dragField.falloff = 1;
	_dragField.strength = 1;
	_dragField.minimumRadius = 10;
	_dragField.name = @"Player Drag";

	[k.viewController.scene.player addChild:_gravityField];
	[k.viewController.scene.player addChild:_dragField];

	//
	// Create rectangular linear gravity fields to avoid that balls
	// get stuck at the scene edge. These fields very gently pull balls
	// back to the inside of the scene.
	//

	CGRect frame = k.viewController.scene.frame;
	float grav = 0.03;
	CGFloat thickness = 24*k.displayScaleFactor;

	// Left border
	_leftBorderField = [SKFieldNode linearGravityFieldWithVector:(vector_float3){grav, 0, 0}];
	_leftBorderField.categoryBitMask = PHYSICS_FIELD_BORDER;
	_leftBorderField.region = [[SKRegion alloc] initWithSize:CGSizeMake(thickness, CGRectGetHeight(frame))];
	_leftBorderField.position = CGPointMake(CGRectGetMinX(frame), CGRectGetMidY(frame));
	[k.viewController.scene.level addChild:_leftBorderField];

	// Top
	_topBorderField = [SKFieldNode linearGravityFieldWithVector:(vector_float3){0, -grav, 0}];
	_topBorderField.categoryBitMask = PHYSICS_FIELD_BORDER;
	_topBorderField.region = [[SKRegion alloc] initWithSize:CGSizeMake(CGRectGetWidth(frame), thickness)];
	_topBorderField.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
	[k.viewController.scene.level addChild:_topBorderField];

	// Right
	_rightBorderField = [SKFieldNode linearGravityFieldWithVector:(vector_float3){-grav, 0, 0}];
	_rightBorderField.categoryBitMask = PHYSICS_FIELD_BORDER;
	_rightBorderField.region = [[SKRegion alloc] initWithSize:CGSizeMake(thickness, CGRectGetHeight(frame))];
	_rightBorderField.position = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));
	[k.viewController.scene.level addChild:_rightBorderField];

	// Bottom
	_bottomBorderField = [SKFieldNode linearGravityFieldWithVector:(vector_float3){0, grav, 0}];
	_bottomBorderField.categoryBitMask = PHYSICS_FIELD_BORDER;
	_bottomBorderField.region = [[SKRegion alloc] initWithSize:CGSizeMake(CGRectGetWidth(frame), thickness)];
	_bottomBorderField.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
	[k.viewController.scene.level addChild:_bottomBorderField];
}

- (void)setup
{
	CGFloat direction = 1;

	if (_tailnum < 0) {
		_tailnum = k.config.stage*2;
	}


	// Create snake's main particle
	_part = [[Particle alloc] initWithPos:self.pos imageName:@"circle40" player:1];
	_part.physicsBody.fieldBitMask = PHYSICS_FIELD_PLAYER | PHYSICS_FIELD_MAGNET;
	[k.particles addParticle:self.part];

	// Add an emitter if any
#if !HAVE_LEVEL_SCREENSHOTS
	if ([k.sound.currentTheme isEqualToString:@"water"]) {
		SKEmitterNode *emitter = [k.effects dropletEmitterWithSize:_part.size];
		[self.part addChild:emitter];
	}
#endif

#if !TARGET_OS_TV
	// Enable gestures for iPad
	// (-setTailNum: is called whenever there is a snake on screen)
	k.viewController.panRecognizer.enabled = YES;
	k.viewController.tapRecognizer.enabled = YES;
	k.viewController.twoTapRecognizer.enabled = YES;
#endif

	[self setupFields];

	k.input.targetPos = self.pos;
	[k.input showTarget];

	// Create snake tail
	if (_tailnum) {

		int sizes[6];

		NSAssert(_tailnum <= 6, @"unsupported tailNum sizes %ld", (long)_tailnum);

		if (_tailnum <= 4) {
				sizes[0] = 32;
				sizes[1] = 28;
				sizes[2] = 24;
				sizes[3] = 20;
		} else if (_tailnum <= 6) {
				sizes[0] = 36;
				sizes[1] = 32;
				sizes[2] = 28;
				sizes[3] = 24;
				sizes[4] = 20;
				sizes[5] = 16;
		}

		Particle *op = self.part;
		NSInteger num = minl(_tailnum, 6);
		for (int i = 0; i < num; ++i) {
			CGFloat diameter = sizes[i];
			CGFloat length = i > 0 ? (diameter/2 + 2 + sizes[i-1]/2) : (diameter/2 + 2 + 40/2);

#if TARGET_OS_TV
			// Circle images are 1.5 times larger in tvOS image assets than on iOS.
			length *= 1.5;
#endif

			CGPoint newpos = CGPointAddMult(op.pos, CGPointMake(length, 0), direction);
			NSString *imageName = [NSString stringWithFormat:@"circle%d", sizes[i]];

			Particle *p = [[Particle alloc] initWithPos:newpos imageName:imageName player:2+i drag:0.10];
//			p.physicsBody.linearDamping = 1;
//			p.physicsBody.fieldBitMask = PHYSICS_FIELD_PLAYER_DRAG;
			[k.particles addParticle:p];

#if !HAVE_LEVEL_SCREENSHOTS
			if ([k.sound.currentTheme isEqualToString:@"water"]) {
				SKEmitterNode *emitter = [k.effects dropletEmitterWithSize:p.size];
				[p addChild:emitter];
			}
#endif

//			Spring *sp = [[Spring alloc] initWithLength:length part1:op part2:p oneWay:YES spring:300.0 damp:20.0];
			Spring *sp = [[Spring alloc] initWithLength:length part1:op part2:p oneWay:YES spring:300 damp:30.0];
			[k.particles addSpring:sp];
			op = p;
		}
	}
}

@end
