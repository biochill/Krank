//
//  KrankScene.m
//  Krank
//
//  Created by Sven Thoennissen on 19.01.16.
//
//

#import "KrankScene.h"
#import "Globals.h"

@interface KrankScene ()
@property (nonatomic, strong, readonly) SKNode *game;
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

- (void)setBackground:(NSString *)background alpha:(CGFloat)alpha
{
	// want jpg
	NSString *fileName = [background stringByAppendingPathExtension:@"jpg"];
	UIImage *normalImage = [UIImage imageNamed:fileName];
	UIImage *quadImage = [Tools makeLandscapeQuadImage:normalImage size:self.frame.size alpha:alpha];

	SKTexture *texture = [SKTexture textureWithImage:quadImage];
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
}

@end
