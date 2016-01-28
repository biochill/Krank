//
//  Magnet.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Magnet.h"
#import "Globals.h"
#import "Particles.h"
#import "Chain.h"


@interface Magnet ()
{
	int _identifier;
	CGFloat _anglefac;
	NSTimeInterval _actionCounter;
	BOOL _exploding;
}
@property (nonatomic, strong) NSMutableSet *captured;
@property (nonatomic, strong) NSMutableSet *oldCaptured;
@property (nonatomic, strong) NSMutableSet *colorSet;
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic, strong) SKFieldNode *fieldNode;
@end


@implementation Magnet

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)colorName num:(NSInteger)numValue
{
	Magnet *magnet = [[Magnet alloc] initWithPos:aPos color:colorName num:numValue];
	[k.particles addMagnet:magnet];
	return magnet;
}

- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)colorName num:(NSInteger)numValue
{
	if ((self = [super initWithPos:aPos]))
	{
		static int identifier_count = 0;
		_identifier = identifier_count++;

		_colorSet = [[NSMutableSet alloc] initWithCapacity:6];
		_captured = [[NSMutableSet alloc] initWithCapacity:6];
		_oldCaptured = [[NSMutableSet alloc] initWithCapacity:6];
		_actionCounter = 0;
		_colorName = colorName;
		_orbits = numValue;
		_anglefac = k.particles.numberOfMagnets%2 ? 1 : -1;

		self.zPosition = -50;

		// Add orbiting particles
//		CGFloat angle = -M_PI/2;
		NSString *dotImageName = [NSString stringWithFormat:@"dot20_%@", colorName];
		NSString *magnetImageName = [NSString stringWithFormat:@"dot32_%@", colorName];
		[self setImageName:magnetImageName];
		CGFloat fieldRadius = self.size.width/2 + 1;

		for (int i = 0; i < _orbits; ++i) {
			Sprite *dot = [[Sprite alloc] init];
			[dot setImageName:dotImageName];
			dot.name = [NSString stringWithFormat:@"%d", i];
//			CGFloat length = self.size.width/2 + dot.size.width/2 + 1;
//			CGPoint dir = CGPointWithAngle(-(i*2*M_PI/_orbits + angle), length); // original length: 16+10-1
//			dot.position = dir;
			[self addChild:dot];

			fieldRadius = self.size.width/2 + 1 + dot.size.width + 8*k.displayScaleFactor;
		}

		// Create field node to attract other particles.
		// Increase field strength to make attracted particles move faster.
		SKFieldNode *field = [SKFieldNode springField];
		field.categoryBitMask = PHYSICS_FIELD_MAGNET;
		field.region = [[SKRegion alloc] initWithRadius:fieldRadius];
		field.strength = 30;
		field.minimumRadius = self.size.width/2*0.5;
		[self addChild:field];
		_fieldNode = field;

		// Drag field slightly slows captured particles down to avoid bouncing through the magnet.
		// Increase field strength to make particles more "sticky".
		SKFieldNode *dragField = [SKFieldNode dragField];
		dragField.categoryBitMask = PHYSICS_FIELD_MAGNET;
		dragField.region = [[SKRegion alloc] initWithRadius:fieldRadius];
		dragField.strength = 0.75;
		dragField.minimumRadius = self.size.width/2;
		[self addChild:dragField];
	}
	return self;
}

- (void)remove
{
	[k.particles removeMagnet:self];
	[k.effects addSparksWithPos:self.position];
}

- (void)startActions
{
	for (int i = 0; i < _orbits; ++i) {
		Sprite *dot = (Sprite *)[self childNodeWithName:[NSString stringWithFormat:@"%d", i]];
		CGFloat length = self.size.width/2 + 1 + dot.size.width/2;
		CGFloat angle = -(-M_PI/2 + i*2*M_PI/_orbits);

		// Somehow UIBezierPath does not like an arc from <angle> to <angle+2*M_PI> so we split it in two half arcs.
		UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:length startAngle:angle endAngle:angle + M_PI clockwise:_anglefac > 0];
		[path addArcWithCenter:CGPointZero radius:length startAngle:angle + M_PI endAngle:angle + 2*M_PI clockwise:_anglefac > 0];
		[dot runAction:[SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:15]]];
	}
}

- (BOOL)collidesWithParticle:(Particle *)part
{
	CGPoint dist = CGPointSub(part.position, self.position);
	return [self.fieldNode.region containsPoint:dist];
//	CGFloat dist = CGPointLength(attraction);
//	CGFloat regionRadius = self.size.width; // 32 on iPad, 48 on tv
//	return (dist < regionRadius + part.radius);
}

- (void)applyAttractionForce:(Particle *)part
{
//	CGPoint attraction = CGCreateVector(part.pos, self.pos);
//	[part applyAccel:CGPointScale(attraction, 200)]; //-part.playerValue*18)];
	[_captured addObject:part];
	part.captured = YES;

	if ([part isKindOfClass:[Chain class]]) {
		Chain *chain = (Chain *)part;
		[chain unlink];
	}
}

//------------------------------------------------------------------------------------------------------------------------

//- (void)onTick:(NSTimeInterval)delta
- (void)onFrame:(NSTimeInterval)delta
{
	//
	// Use a Set to determine if particles were removed or added.
	// Simply comparing the number of particles does not work, for example if
	// one particle is removed and another is added at the same time.
	//
	if (![_oldCaptured isSubsetOfSet:_captured]) {

		// More captured particles = less volume
		float vol = 1.0/(_captured.count*0.3 + 1);
		[k.sound play:@"magnet_off" volume:vol]; //1.0 - _captured.count/6.0];

		// Unmark particles that got un-captured
		NSMutableSet *difference = [NSMutableSet setWithSet:_oldCaptured];
		[difference minusSet:_captured];
		for (Particle *part in difference)
			part.captured = NO;
	}

	if (![_captured isSubsetOfSet:_oldCaptured]) {
		// More captured particles = more volume
		float vol = 1.0/((_orbits - minl(_captured.count, _orbits))*0.3 + 1);
		[k.sound play:@"magnet_on" volume:vol];//0.2 + _captured.count/6.0];
	}

	//
	// Check if all captured particles match, and run countdown
	//
	if (_captured.count)
	{
		NSUInteger nonplayer = 0;
		for (Particle *p in _captured) {
			if (!p.isPlayer) ++nonplayer;
		}
		
		if (nonplayer >= _orbits)
		{
			_actionCounter += delta;
			
			if (_actionCounter > 3) // explode magnet
			{
				_exploding = YES;
				_actionCounter = 0;

				// Move captured balls around in random directions
				[_colorSet removeAllObjects];
				for (Particle *p in _captured)
				{
					CGPoint vel = CGPointAddMult(p.vel, CGPointNorm(CGPointSub(p.position, self.position)), 500*k.displayScaleFactor);// 1000*k.world.forceFactor);
					[p applyImpulse:vel];
					p.captured = NO;
					[_colorSet addObject:p.colorName];
				}
				
				NSInteger nonchains = 0;
				for (Particle *p in _captured) {
					if ([p isMemberOfClass:[Particle class]]) {
						++nonchains;
					}
				}
				[_captured removeAllObjects];
				if ((_colorSet.count == 1) && [_colorSet member:_colorName] && (nonchains >= _orbits))
				{
					[self remove];
					if (![k.level checkExit])
						[k.sound play:@"magnet_action"];
				} else {
					[k.sound play:@"magnet_action"];
				}
				
				//[k.particles dump:@"magnet exploded"];
			}
			else if (floor(_actionCounter) > floor((_actionCounter-delta)))
			{
				[k.sound play:@"magnet_start"];
			}
		}
		else
		{
			_actionCounter = 0;
		}
	}
	
	[_oldCaptured setSet:_captured];
	[_captured removeAllObjects];
}

- (void)drawLines
{
	if (_oldCaptured.count)
	{
		CGPoint selfpos = self.position;
		CGPoint p1 = selfpos;
		for (Particle *p in _oldCaptured)
		{
			//			CGPoint p2 = CGPointMake(fclamp(p.pos.x, selfpos.x-31, selfpos.x+31), fclamp(p.pos.y, selfpos.y-31, selfpos.y+31));
			CGPoint p2 = p.position;
			[k.lines addLineFrom:p1 to:p2];
			p1 = p2;
		}
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"[%@ id=%d]", [self class], _identifier];
}

@end
