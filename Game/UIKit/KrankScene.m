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
#import "TestNode.h"

@interface KrankScene ()
@property (nonatomic, strong, readonly) SKNode *game;
@property (nonatomic, strong) SKSpriteNode *cursor1;
@property (nonatomic, strong) SKSpriteNode *cursor2;
@property (nonatomic, strong) SKNode *cursors;
@property (nonatomic) CGFloat currentRadius;
@end

@implementation KrankScene

- (void)sceneDidLoad
{
	self.name = @"Scene";
	self.backgroundColor = [UIColor blackColor];

	//
	// Setup main nodes
	//
	_game = [SKNode node];
	_game.name = @"Game";
	[self addChild:_game];

	_switches = [[SKNode alloc] init];
	_switches.name = @"Switches";
	[self addChild:_switches];

	_level = [SKNode node];
	_level.name = @"Level";
	[_game addChild:_level];

	_player = [SKNode node];
	_player.name = @"Player";
	_player.zPosition = 10;
	[_game addChild:_player];

#if TARGET_OS_TV
	// iOS does not need these cursors, there is no focus engine
	_cursors = [SKNode node];
	_cursors.name = @"Cursors";

	SKTexture *tex = [k.atlas textureNamed:@"dot28_white"];
	_cursor1 = [[SKSpriteNode alloc] initWithTexture:tex];
	_cursor1.name = @"Cursor 1";
	[_cursors addChild:_cursor1];
	_cursor2 = [[SKSpriteNode alloc] initWithTexture:tex];
	_cursor2.name = @"Cursor 2";
	[_cursors addChild:_cursor2];
#endif

	//
	// Setup physics world and borders
	//
	self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
	self.physicsBody.friction = 0;
	self.physicsBody.restitution = 1;

	self.delegate = k;
	self.physicsWorld.contactDelegate = k.particles;
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
	self.background = bgNode;
}

- (void)reset
{
	[self removeAllActions];

	[self.switches removeAllChildren];
	[self.level removeAllChildren];
	[self.player removeAllChildren];

	[self.background removeFromParent];
	self.background = nil;

	[k.cockpit removeFromParent];
	[k.lines removeFromParent];

	[self.cursors removeFromParent];

	self.focusedSwitch = nil;
	self.preferredInitialFocusNode = nil;
}

- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments
{
	if (self.preferredInitialFocusNode) {
		return @[self.preferredInitialFocusNode];
	}
	return @[];
}

- (void)startCursorAnimation:(CGFloat)radius selected:(BOOL)selected
{
	CGFloat angle = 0;//random()%180*M_PI/180;

	self.currentRadius = radius + self.cursor1.texture.size.width/2;

	UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.currentRadius startAngle:angle endAngle:angle + M_PI clockwise:!selected];
	SKAction *loop1 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.currentRadius startAngle:angle + M_PI endAngle:angle + M_PI*2 clockwise:!selected];
	SKAction *loop2 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	[self.cursor1 removeAllActions];
	[self.cursor2 removeAllActions];

	self.cursor1.alpha = 0;
	self.cursor2.alpha = 0;
	[self.cursor1 runAction:[SKAction group:@[loop1, [SKAction fadeAlphaTo:1 duration:0.3]]]];
	[self.cursor2 runAction:[SKAction group:@[loop2, [SKAction fadeAlphaTo:1 duration:0.3]]]];
}

- (void)animateFocusToPosition:(CGPoint)toPosition radius:(CGFloat)radius selected:(BOOL)selected duration:(NSTimeInterval)duration animateOut:(BOOL)animateOut
{
	// position in scene coordinates
	// status = on or off

	CGFloat alpha = animateOut ? 0 : 1;

	// Change rotation direction if needed
	[self updateCursorStatus:selected];

	if (self.cursors.parent) {
		//
		// Already in scene -> move cursors to new position
		//

		SKAction *move = [SKAction moveTo:toPosition duration:duration];
		move.timingMode = SKActionTimingEaseInEaseOut;
		[self.cursors runAction:[SKAction group:@[move, [SKAction fadeAlphaTo:alpha duration:duration]]]];

	} else {
		//
		// Place parent node at position and start animation
		//

		self.cursors.position = toPosition;
		self.cursors.alpha = alpha;
		[self.switches addChild:self.cursors];

		[self startCursorAnimation:radius selected:selected];
	}
}

- (void)updateCursorTexture:(BOOL)selected
{
	self.cursor1.texture = [k.atlas textureNamed:selected ? @"dot28_orange" : @"dot28_white"];
	self.cursor2.texture = self.cursor1.texture;
}

- (void)updateCursorStatus:(BOOL)selected
{
	if (!self.cursors) return;

	[self.cursor1 removeAllActions];
	[self.cursor2 removeAllActions];

	[self updateCursorTexture:selected];

	CGPoint pos = self.cursor1.position;
	CGFloat angle = CGPointEqualToPoint(pos, CGPointZero) ? 0 : atan2(pos.y, pos.x);

	UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.currentRadius startAngle:angle endAngle:angle + M_PI clockwise:!selected];
	SKAction *loop1 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.currentRadius startAngle:angle + M_PI endAngle:angle + M_PI*2 clockwise:!selected];
	SKAction *loop2 = [SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:4]];

	[self.cursor1 runAction:loop1];
	[self.cursor2 runAction:loop2];
}

@end
