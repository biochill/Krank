#import "KrankViewController.h"
#import "Effect.h"
#import "Globals.h"
#import "Tools.h"


@implementation Effect

//- (id)init
//{
//	if ((self = [super init])) {
//	}
//	return self;
//}

- (void)reset
{
//	for (SKEmitterNode *node in _effects) {
//		[node removeAllActions];
//	}

//	[_effects removeAllObjects];
//	[_effectsToRemove removeAllObjects];
}

- (void)addSparksWithPos:(CGPoint)aPos
{
	[self addSparksWithPos:aPos numSparks:80 startVel:CGPointZero];
}

- (void)addSparksWithPos:(CGPoint)aPos numSparks:(NSInteger)numSparks
{
	[self addSparksWithPos:aPos numSparks:numSparks startVel:CGPointZero];
}

- (void)addSparksWithPos:(CGPoint)pos numSparks:(NSInteger)numSparks startVel:(CGPoint)startVel
{
// pos in SKScene coordinates

	SKEmitterNode *emitter = [SKEmitterNode node];
	emitter.zPosition = 30;
	emitter.position = pos;

	if ([k.sound.currentTheme isEqualToString:@"water"]) {

		// Water bubbles emitter

		emitter.numParticlesToEmit = maxl(1, numSparks/5);
		emitter.particleBirthRate = 10;
		emitter.particleTexture = [k.atlas textureNamed:@"bubble"];
		emitter.particlePositionRange = CGVectorMake(40, 40);
		emitter.emissionAngleRange = 2*M_PI;
		emitter.particleSpeed = 0;
		emitter.particleSpeedRange = 40;
		emitter.particleLifetime = 1.5;
		emitter.particleLifetimeRange = 2;
		emitter.particleAlpha = 0.7;
		emitter.particleAlphaRange = 0.6;
		emitter.particleAlphaSpeed = -0.3;
#if TARGET_OS_TV
		emitter.particleSize = CGSizeMake(45, 45);
#else
		emitter.particleSize = CGSizeMake(30, 30);
#endif
		emitter.particleScale = 0.6;
		emitter.particleScaleRange = 0.6;

		// make particle wiggle - does not seem to work?
//		emitter.particleAction = [SKAction repeatActionForever:[SKAction group:@[[SKAction scaleXBy:0.5 y:-0.5 duration:0.2], [SKAction scaleXBy:-0.5 y:0.5 duration:0.2]]]];

		//	DLog(@"new emitter: num=%d pos=%@", (int)numSparks, StringFromCGPoint(pos));

		[k.viewController.scene.level addChild:emitter];

		[emitter runAction:[SKAction sequence:@[[SKAction waitForDuration:4], [SKAction removeFromParent]]]];
		return;
	}

	// Sparks emitter

	if (k.lines.lineType == LineTypeBlack) {
		emitter.particleColor = [UIColor blackColor];
		emitter.particleColorBlendFactor = 1.0;
	}

	emitter.numParticlesToEmit = numSparks;
	emitter.particleBirthRate = 500;
	emitter.particleTexture = [k.atlas textureNamed:@"spark"];
	emitter.emissionAngleRange = 2*M_PI;
	emitter.particleSpeed = 80;
	emitter.particleSpeedRange = 120;
	emitter.particleLifetime = 1;
	emitter.particleLifetimeRange = 0.6;
	emitter.particleAlpha = 1;
	emitter.particleAlphaSpeed = -1/1.3;
	emitter.particleSize = CGSizeMake(3, 3);

//	DLog(@"new emitter: num=%d pos=%@", (int)numSparks, StringFromCGPoint(pos));

	[k.viewController.scene.level addChild:emitter];

	[emitter runAction:[SKAction sequence:@[[SKAction waitForDuration:1.3], [SKAction removeFromParent]]]];
}

- (SKEmitterNode *)dropletEmitterWithSize:(CGSize)size
{
	SKEmitterNode *emitter;
	emitter = [SKEmitterNode node];
	emitter.zPosition = -1;
	emitter.targetNode = k.viewController.scene;

	emitter.particleBirthRate = 2;
	emitter.particleTexture = [k.atlas textureNamed:@"ring"];
	//		emitter.particlePosition = CGPointMake(5, 5);
//	emitter.particlePositionRange = CGVectorMake(20, 20);
	//	emitter.particleSpeed = 20;
//	emitter.particleSpeedRange = 40;
	emitter.particleLifetime = 1.5;
	emitter.particleLifetimeRange = 1;
	emitter.particleAlpha = 0.5;
	emitter.particleAlphaRange = 0.6;
	emitter.particleAlphaSpeed = -0.8/2.0;
//	emitter.emissionAngleRange = 2*M_PI;
	emitter.particleSize = size;
	emitter.particleScaleRange = 0.8;
	emitter.particleScaleSpeed = 2/2.0;

	return emitter;
}
/*
- (SKEmitterNode *)steamEmitterWithSize:(CGSize)size
{
	SKEmitterNode *emitter;
	emitter = [SKEmitterNode node];
	emitter.zPosition = -1;
	emitter.targetNode = k.viewController.scene;

	emitter.particleBirthRate = 20;
	emitter.particleTexture = [k.atlas textureNamed:@"spark"];
	//		emitter.particlePosition = CGPointMake(5, 5);
		emitter.particlePositionRange = CGVectorMake(7, 7);
	//	emitter.particleSpeed = 20;
	emitter.particleSpeedRange = 10;
	emitter.particleLifetime = 1.5;
	emitter.particleLifetimeRange = 1;
	emitter.particleAlpha = 0.5;
	emitter.particleAlphaRange = 0.6;
	emitter.particleAlphaSpeed = -0.8/2.0;
	//	emitter.emissionAngleRange = 2*M_PI;
	emitter.particleSize = size;// CGSizeMake(10, 10);
	emitter.particleScaleRange = 0.6;
	emitter.particleScaleSpeed = 2/2.0;
	emitter.particleColor = [UIColor colorWithWhite:0.5 alpha:1];

	return emitter;
}
*/
- (SKEmitterNode *)targetSteam
{
	SKEmitterNode *emitter;
	emitter = [SKEmitterNode node];
	emitter.zPosition = -1;
	emitter.targetNode = k.viewController.scene;

	if (k.lines.lineType == LineTypeBlack) {
		emitter.particleColor = [UIColor blackColor];
		emitter.particleColorBlendFactor = 1.0;
	}

	CGFloat maxLifeTime = 1.8;
	emitter.particleBirthRate = 500;
	emitter.numParticlesToEmit = 12;
	emitter.particleTexture = [k.atlas textureNamed:@"spark"];
	emitter.particlePositionRange = CGVectorMake(28, 28);
	emitter.particleSpeed = 4;
	emitter.particleSpeedRange = 6;
	emitter.yAcceleration = 8.0;
	emitter.emissionAngle = M_PI_2;
	emitter.emissionAngleRange = M_PI*0.1;
	emitter.particleLifetime = maxLifeTime - maxLifeTime/3;
	emitter.particleLifetimeRange = emitter.particleLifetime; // +- half
	emitter.particleAlpha = 0.5;
	emitter.particleAlphaRange = 0.6;
	emitter.particleAlphaSpeed = -0.8/maxLifeTime;
	emitter.particleSize = CGSizeMake(18, 18);
	emitter.particleScaleRange = 0.8;
	emitter.particleScaleSpeed = 1;

	[emitter runAction:[SKAction sequence:@[[SKAction waitForDuration:maxLifeTime], [SKAction removeFromParent]]]];

	return emitter;
}

- (SKNode *)targetDroplet
{
	SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[k.atlas textureNamed:@"ring"]];
	node.zPosition = -90;
	node.size = CGSizeMake(24, 24);

	SKAction *enlarge = [SKAction scaleTo:7 duration:1.5];
	SKAction *fade = [SKAction fadeAlphaTo:0 duration:1.5];
	[node runAction:[SKAction sequence:@[[SKAction group:@[enlarge, fade]], [SKAction removeFromParent]]]];

	return node;
}

@end
