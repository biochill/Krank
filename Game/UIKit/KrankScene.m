//
//  KrankScene.m
//  Krank
//
//  Created by Sven Thoennissen on 19.01.16.
//
//

@import QuartzCore.CAMediaTimingFunction;

#import "KrankScene.h"
#import "Globals.h"

@interface KrankScene ()
@property (nonatomic, strong, readonly) SKNode *game;
@property (nonatomic, strong) SKSpriteNode *cursor1, *cursor2;
@property (nonatomic) CGPoint prevCursorCenter;
@property (nonatomic) CGFloat currentRadius;
@end

@implementation KrankScene

- (instancetype)initWithSize:(CGSize)size
{
	if ((self = [super initWithSize:size])) {
		self.name = @"Scene";
		self.backgroundColor = [UIColor blackColor];
	}
	return self;
}

- (void)didMoveToView:(SKView *)view
{
	//
	// Setup main nodes
	//
	_game = [SKNode node];
	_game.name = @"Game";
	[self addChild:_game];

	_level = [SKNode node];
	_level.name = @"Level";
	[_game addChild:_level];

	_player = [SKNode node];
	_player.name = @"Player";
	[_game addChild:_player];

	//
	// Setup physics world and borders
	//
	self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
	self.physicsBody.friction = 0;
	self.physicsBody.restitution = 1;

	self.physicsWorld.gravity = CGVectorMake(0, 0);
}

- (void)setBackgroundImage:(UIImage *)image alpha:(CGFloat)alpha
{
	SKTexture *texture = [SKTexture textureWithImage:image];
	SKSpriteNode *bgNode = [[SKSpriteNode alloc] initWithTexture:texture];
	bgNode.name = @"Background";
	bgNode.anchorPoint = CGPointZero;
	bgNode.zPosition = -100;
	bgNode.alpha = alpha;
	[self addChild:bgNode];
	_background = bgNode;
}

- (void)reset
{
	[self removeAllActions];

	[_level removeAllChildren];
	[_player removeAllChildren];

	[_background removeFromParent];
	_background = nil;

	[k.cockpit removeFromParent];
	[k.lines removeFromParent];

	[_cursor1 removeFromParent];
	[_cursor2 removeFromParent];
	_cursor1 = nil;
	_cursor2 = nil;
	_prevCursorCenter = CGPointZero;
}

- (void)animateFocusToPosition:(CGPoint)position radius:(CGFloat)radius status:(BOOL)on duration:(NSTimeInterval)duration
{
// position in scene coordinates

	SKTexture *tex = [k.atlas textureNamed:on ? @"dot28_orange" : @"dot28_white"];

	if (!_cursor1) {
		_cursor1 = [[SKSpriteNode alloc] initWithTexture:tex];
		[_game addChild:_cursor1];
	}

	if (!_cursor2) {
		_cursor2 = [[SKSpriteNode alloc] initWithTexture:tex];
		[_game addChild:_cursor2];
	}

	CGPoint destCenter = position;

	CGFloat angle = random()%180*M_PI/180;

	_currentRadius = radius + _cursor1.texture.size.width/2;
	CGPoint dest1 = CGPointAdd(destCenter, CGPointWithAngle(angle, _currentRadius));
	CGPoint dest2 = CGPointAdd(destCenter, CGPointWithAngle(angle + M_PI, _currentRadius));

	UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:destCenter radius:_currentRadius startAngle:angle endAngle:angle + M_PI clockwise:on];
	SKAction *loop1 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	path = [UIBezierPath bezierPathWithArcCenter:destCenter radius:_currentRadius startAngle:angle + M_PI endAngle:angle + M_PI*2 clockwise:on];
	SKAction *loop2 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	[_cursor1 removeAllActions];
	[_cursor2 removeAllActions];

	if (CGPointEqualToPoint(_prevCursorCenter, CGPointZero)) {

		_cursor1.position = dest1;
		_cursor2.position = dest2;
		_cursor1.alpha = 0;
		_cursor2.alpha = 0;
		[_cursor1 runAction:[SKAction group:@[loop1, [SKAction fadeAlphaTo:1 duration:0.3]]]];
		[_cursor2 runAction:[SKAction group:@[loop2, [SKAction fadeAlphaTo:1 duration:0.3]]]];

	} else {

		_cursor1.alpha = 1;
		_cursor2.alpha = 1;

		NSTimeInterval d = duration*4;
		SKAction *move1 = [SKAction moveTo:dest1 duration:d];
		move1.timingMode = SKActionTimingEaseInEaseOut;
		SKAction *move2 = [SKAction moveTo:dest2 duration:d];
		move2.timingMode = SKActionTimingEaseInEaseOut;

		SKAction *initial1 = [SKAction sequence:@[move1, [SKAction setTexture:tex]]];
		SKAction *initial2 = [SKAction sequence:@[move2, [SKAction setTexture:tex]]];

		[_cursor1 runAction:[SKAction sequence:@[initial1, loop1]]];
		[_cursor2 runAction:[SKAction sequence:@[initial2, loop2]]];
	}
	_prevCursorCenter = destCenter;
}

- (void)updateCursorStatus:(BOOL)cursorStatus
{
	[_cursor1 removeAllActions];
	[_cursor2 removeAllActions];

	_cursor1.texture = [k.atlas textureNamed:cursorStatus ? @"dot28_orange" : @"dot28_white"];
	_cursor2.texture = _cursor1.texture;

	CGPoint diff = CGPointSub(_cursor1.position, _prevCursorCenter);
	CGFloat angle = atan2(diff.y, diff.x);

	CGPoint dest1 = CGPointAdd(_prevCursorCenter, CGPointWithAngle(angle, _currentRadius));
	CGPoint dest2 = CGPointAdd(_prevCursorCenter, CGPointWithAngle(angle + M_PI, _currentRadius));

	UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_prevCursorCenter radius:_currentRadius startAngle:angle endAngle:angle + M_PI clockwise:cursorStatus];
	SKAction *loop1 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	path = [UIBezierPath bezierPathWithArcCenter:_prevCursorCenter radius:_currentRadius startAngle:angle + M_PI endAngle:angle + M_PI*2 clockwise:cursorStatus];
	SKAction *loop2 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	_cursor1.position = [k.world convertToScenePoint:dest1];
	_cursor2.position = [k.world convertToScenePoint:dest2];
	[_cursor1 runAction:loop1];
	[_cursor2 runAction:loop2];
}

- (void)animateFocusOutWithTargetPosition:(CGPoint)target
{
	[_cursor1 removeAllActions];
	[_cursor2 removeAllActions];

	SKAction *move1 = [SKAction moveTo:target duration:0.4];
	move1.timingMode = SKActionTimingEaseInEaseOut;
	SKAction *move2 = [SKAction moveTo:target duration:0.4];
	move2.timingMode = SKActionTimingEaseInEaseOut;
	[_cursor1 runAction:[SKAction group:@[move1, [SKAction fadeAlphaTo:0 duration:0.4]]]];
	[_cursor2 runAction:[SKAction group:@[move2, [SKAction fadeAlphaTo:0 duration:0.4]]]];
}

@end
