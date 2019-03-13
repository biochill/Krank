#import "Particles.h"
#import "Particle.h"
#import "Globals.h"
#import "Effect.h"
#import "Spring.h"
#import "Stone.h"
#import "Magnet.h"
//#import "Collision.h"
#import "Switch.h"
#import "Anchor.h"


@interface Particles ()
@property (nonatomic, strong) NSMutableArray *particles;
@property (nonatomic, strong) NSMutableSet *removedMagnets;
@property (nonatomic, strong) NSMutableSet *removedAnchors;
@property (nonatomic, strong) NSMutableSet *magnets;
@property (nonatomic, strong) NSMutableSet *anchors;
@property (nonatomic, strong) NSMutableSet *springs;
@end


@implementation Particles

- (id)init
{
	if ((self = [super init])) 
    {
		_particles      = [[NSMutableArray alloc] initWithCapacity:10];
		_springs        = [[NSMutableSet   alloc] initWithCapacity:10];
		_magnets        = [[NSMutableSet   alloc] initWithCapacity:10];
		_removedMagnets = [[NSMutableSet   alloc] initWithCapacity:10];
		_anchors        = [[NSMutableSet   alloc] initWithCapacity:10];
		_removedAnchors = [[NSMutableSet   alloc] initWithCapacity:10];
//		collisions     = [[NSMutableSet   alloc] initWithCapacity:10];
	}
	return self;
}

- (NSArray *)parts
{
	return _particles;
}

- (void)addParticle:(Particle *)part
{
	[_particles addObject:part];

	if ([part isKindOfClass:[Switch class]]) {
		// Switches are userInteraction-enabled
		[k.viewController.scene.switches addChild:part];
	} else if (part.playerValue == IsNotAPlayer) {
		[k.viewController.scene.level addChild:part];
	} else {
		[k.viewController.scene.player addChild:part];
	}
}

- (void)addSpring:(Spring *)spring
{
	[_springs addObject:spring];
}

- (void)addMagnet:(Magnet *)magnet
{
	[_magnets addObject:magnet];
	[k.viewController.scene.level addChild:magnet];
}

- (void)removeMagnet:(Magnet *)magnet
{
	[_removedMagnets addObject:magnet]; // keep reference
	[magnet removeFromParent];
}

- (void)removeSpring:(Spring *)spring
{
	[_springs removeObject:spring];
	if ([spring.p1 isKindOfClass:[Chain class]]) {
		Chain *c1 = (Chain *)spring.p1;
		[c1.springs removeObject:spring];
	}
	if ([spring.p2 isKindOfClass:[Chain class]]) {
		Chain *c2 = (Chain *)spring.p2;
		[c2.springs removeObject:spring];
	}
}

- (void)addAnchor:(Anchor *)anchor
{
	[self addParticle:anchor];
	[_anchors addObject:anchor];
}

- (void)removeAnchor:(Anchor *)anchor
{
	[_particles removeObjectIdenticalTo:anchor];
    [anchor.chain removeAllObjects];
	[_removedAnchors addObject:anchor]; // keep reference
	[anchor removeFromParent];
}

+ (void)stoneCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius
{
	[Particles stoneCircle:pos color:color num:num radius:radius start:0];
}

+ (void)stoneCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius start:(double)start
{
	for (int i = 0; i < num; ++i) {
		CGPoint p = CGPointAdd(pos, CGPointWithAngle(start+i*2*M_PI/num, radius));
		[Stone addWithPos:p color:color];
	}
}

+ (void)ballCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius
{
	[Particles ballCircle:pos color:color num:num radius:radius start:0];
}

+ (void)ballCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius start:(double)start
{
	for (int i = 0; i < num; ++i) {
		CGPoint p = CGPointAdd(pos, CGPointWithAngle(start+i*2*M_PI/num, radius));
		[Particle addWithPos:p color:color];
	}
}

+ (void)chainCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius
{
	[Particles chainCircle:pos color:color num:num radius:radius start:0];
}

+ (void)chainCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius start:(CGFloat)start
{
	for (int i = 0; i < num; ++i) {
		CGPoint p = CGPointAdd(pos, CGPointWithAngle(start+i*2*M_PI/num, radius));
		[Chain addWithPos:p color:color];
	}
}

+ (void)chainCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num xRadius:(CGFloat)xRadius yRadius:(CGFloat)yRadius start:(CGFloat)start
{
	for (int i = 0; i < num; ++i) {
		CGPoint p = CGPointAdd(pos, CGPointOvalWithAngle(start+i*2*M_PI/num, xRadius, yRadius));
		[Chain addWithPos:p color:color];
	}
}

- (void)reset
{
    //DLog(@"Particles reset");

	// Prepare chain objects for release to resolve reference loops
	for (Particle *part in _particles) {
		if ([part isMemberOfClass:[Chain class]]) {
			Chain *chain = (Chain *)part;
			[chain releaseChain];
		}
	}
	// Same with anchors, since they are a subclass of Chain
	for (Anchor *anchor in _anchors) {
		[anchor releaseChain];
	}

	[_particles removeAllObjects];
//	[collisions removeAllObjects];
	[_springs removeAllObjects];
	[_anchors removeAllObjects];
	[_magnets removeAllObjects];
	[_removedMagnets removeAllObjects];
	[_removedAnchors removeAllObjects];
}

- (void)onFrame:(NSTimeInterval)delta
{
//	NSTimeInterval stepSize;// = fclamp(delta, 0.001, 0.010);
//	NSInteger steps;// = clampl(delta/stepSize, 1, 20);
//    steps = 1;
//	stepSize = delta/steps;
//    //DLog(@"%f steps %d stepSize %f", delta, steps, stepSize);
//    
//	for (NSInteger i = 0; i < steps; ++i)
//    {
//		[k.player onFrame:delta];
		[self calcForces:delta];
//		[self solveForces:stepSize];
//		[self checkCollisions];
//		[self resolveCollisions];
//		[self resetForces];
//		for (Magnet *magnet in magnets) [magnet onTick:stepSize];
//	}
//
	for (Magnet *magnet in _magnets) [magnet onFrame:delta];
	for (Anchor *anchor in _anchors) [anchor onFrame:delta];

	if ([_removedAnchors count]) {
		[_anchors minusSet:_removedAnchors];
		[_removedAnchors removeAllObjects];
	}

	if (_removedMagnets.count) {
		[_magnets minusSet:_removedMagnets];
		[_removedMagnets removeAllObjects];
	}
}

- (void)startActions
{
	for (Magnet *magnet in _magnets) {
		[magnet startActions];
	}
	for (Anchor *anchor in _anchors) {
		[anchor startActions];
	}
}

- (void)drawLines
{
	for (Spring *spring in _springs) {
		[spring drawLine];
	}

	for (Magnet *magnet in _magnets) {
		[magnet drawLines];
	}
}

- (void)calcForces:(NSTimeInterval)delta
{
	for (Particle *part in _particles)
	{
		[part calcForces:delta];

		// magnet collisions
		for (Magnet *magnet in _magnets) {
			if ([magnet collidesWithParticle:part]) {
				[magnet applyAttractionForce:part];
			}
		}
	}

	for (Spring *spring in _springs) {
		 [spring calcForces:delta];
	}
}
/*
- (void)resetForces
{
	for (Particle *part in _particles) [part resetForce];
}

- (void)solveForces:(NSTimeInterval)seconds
{
	for (Particle *part in _particles) [part solveForce:seconds];
}

- (void)checkCollisions
{
	[collisions removeAllObjects];

	World *world = k.world;

	for (int index = 0; index < _particles.count; ++index)
	{
		Particle *part = _particles[index];
        CGPoint pp = part.pos;

		//
		// Test collisions with boundaries
		//

		CGPoint norm = CGPointZero;
		CGFloat radius = part.radius;
		CGFloat topBorder = world.top + radius;
		CGFloat bottomBorder = world.bottom - radius;
		CGFloat leftBorder = world.left + radius;
		CGFloat rightBorder = world.right - radius;

		if      (pp.y < topBorder)    norm = CGPointMake(0, 1);
		else if (pp.y > bottomBorder) norm = CGPointMake(0, -1);
		else if (pp.x < leftBorder)   norm = CGPointMake(1, 0);
		else if (pp.x > rightBorder)  norm = CGPointMake(-1, 0);

		if (!CGPointEqualToPoint(norm, CGPointZero))
		{
			pp = CGPointMake(fclamp(pp.x, leftBorder, rightBorder), fclamp(pp.y, topBorder, bottomBorder));
			part.pos = pp;
			CGFloat sq = CGPointDotProduct(norm, norm) * part.imass;
			CGFloat factor = sq > 0.001 ? (factor = 2 * CGPointDotProduct(part.vel, norm) / sq) : 0;

			//DLog(@"border collision, part %d pos(%f,%f) sq %f factor %f", part.index, part.pos.x, part.pos.y, sq, factor);
			[collisions addObject:[[Collision alloc] initWithParticle:part normal:CGPointNeg(norm) factor:-factor]];
			[k.sound play:@"wall" volume:fclampf((CGPointLength(part.vel)-50)/200, 0, 1) pos:pp.x];
			[SparkGroup addWithPos:pp numSparks:-factor/10];
		}

		//
		// Collisions with other particles
		//

		for (Particle *other in _particles)
		{
			if (other == part) continue;

			CGPoint partToOther = CGCreateVector(pp, other.pos);
			CGFloat distance = CGPointLength(partToOther);
			CGFloat radius = part.radius + other.radius;
			if (distance < radius && distance > 0.0001) 
			{
				CGPoint relvel = CGPointSub(part.vel, other.vel);
				CGPoint norm = CGPointNorm(partToOther);
				if (CGPointDotProduct(relvel, norm) > 0) { // particles approaching
					CGFloat f = 1.0-distance/radius;
					CGFloat factor = 2 * (f*16+CGPointDotProduct(relvel, norm)) / (CGPointDotProduct(norm, norm)*(part.imass+other.imass));
					factor = fmin(1000, factor);

					BOOL tailtotail = part.isPlayer && other.isPlayer && (labs(part.playerValue - other.playerValue)==1);
					if (!tailtotail)
					{
						//DLog(@"collision %@ %@", [part longdescription], [other longdescription]);
						[collisions addObject:[[Collision alloc] initWithParticle:part normal:CGPointNeg(norm) factor:-factor]];
					}

					if (!part.captured) 
					{
						if (!other.captured && !(part.isPlayer && other.isPlayer))
							[self handleChainCollision:part with:other];

						if (!tailtotail) { // ignore tail to tail collisions
							if (part.index < other.index) {
								if (![other isMemberOfClass:[Switch class]] && ![part isMemberOfClass:[Switch class]]) {
									[k.sound play:@"part" volume:fclampf((CGPointLength(relvel)-50)/200, 0, 1) pos:pp.x];
								}
								CGPoint sparkPos = CGPointAddMult(pp, partToOther, 0.5);
								CGPoint sparkVel = CGPointScale(CGCreateVector(part.vel, other.vel), 0.5);
								[SparkGroup addWithPos:sparkPos numSparks:minl(factor/10, 20) startVel:sparkVel];
								if (!part.isPlayer && other.isPlayer)
									k.score = k.score + factor/10.0;
							}
							[part collisionAction];
//							if (k.reset) return;
						}
					}
				}
			}
		}

	}
}
*/
//------------------------------------------------------------------------------------------------------------------------

- (void)handleChainCollision:(Particle *)c1 with:(Particle *)c2
{
// c1 + c2 are Particles (never the player) or Chains or Anchors

// -isKindOfClass: = class or subclass
// -isMemberOfClass = class (exact match, not subclasses)

	//
	// Check if a particle unlinks a chain or anchor
	//
	if (![c1 isKindOfClass:[Chain class]]) {
		if ([c1 isMemberOfClass:[Particle class]] && [c2 isKindOfClass:[Chain class]])
        {
			Chain *chain2 = (Chain *)c2;
			[chain2 unlink];
		}
		return;
	}
	if (![c2 isKindOfClass:[Chain class]]) {
		if ([c2 isMemberOfClass:[Particle class]] && [c1 isKindOfClass:[Chain class]])
        {
			Chain *chain1 = (Chain *)c1;
			[chain1 unlink];
		}
		return;
	}

	//
	// Check if two chains link against each other or against an anchor
	//
	if ([c1 isMemberOfClass:[Chain class]])
    {
		Chain *chain1 = (Chain *)c1;
		Chain *chain2 = (Chain *)c2;
		[chain1 link:chain2];
	} 
    else if ([c2 isMemberOfClass:[Chain class]]) 
    {
		Chain *chain1 = (Chain *)c1;
		Chain *chain2 = (Chain *)c2;
		[chain2 link:chain1];
	}
}

//------------------------------------------------------------------------------------------------------------------------
/*
- (void)resolveCollisions
{
//	for (Collision *collision in collisions) 
//    {
//		CGPoint newvel = CGPointSub(collision.p.vel, CGPointScale(collision.n, (collision.f * collision.p.imass)));
//		collision.p.vel = newvel;
//	}
}

//------------------------------------------------------------------------------------------------------------------------

- (void)fixZOrder
{
    for (Particle *part in _particles)
    {
        if ([part isMemberOfClass:[Magnet class]]) [part sendToFront];
	}
    
    [[k.lines superview] bringSubviewToFront:k.lines];
    
    for (Particle *part in _particles)
    {
        if ([part isMemberOfClass:[Anchor class]]) [part sendToFront];
	}

    for (Particle *part in _particles)
    {
        if ([part isMemberOfClass:[Chain class]] || [part isMemberOfClass:[Particle class]]) [part sendToFront];
	}
    
	for (Particle *part in _particles)
    {
        if (part.isPlayer) [part sendToFront];
	}
}
*/
//------------------------------------------------------------------------------------------------------------------------

- (NSUInteger)numberOfMagnets
{
	return _magnets.count - _removedMagnets.count;
}

//------------------------------------------------------------------------------------------------------------------------

- (NSUInteger)numberOfAnchors
{
	return _anchors.count - _removedAnchors.count;
}

//------------------------------------------------------------------------------------------------------------------------

- (NSMutableSet *)anchorsForColor:(NSString *)color
{
	NSMutableSet *res = [NSMutableSet setWithCapacity:10];
	for (Anchor *a in _anchors)
    {
		if ([_removedAnchors containsObject:a]) continue;
		if ([a.colorName isEqualToString:color])
			[res addObject:a];
	}
	return res;
}

//------------------------------------------------------------------------------------------------------------------------
/*
#if DEBUG
- (void) dump:(NSString*)title
{
    DLog(@"------------------------- %@", title);
    DLog(@"----------------- anchors");
    for (Anchor * anchor in _anchors)
    {
        DLog(@"%@", anchor);
    }
    for (Anchor * anchor in removedAnchors)
    {
        DLog(@"- %@", anchor);
    }
    DLog(@"----------------- chains");
    for (Particle * part in _particles)
    {
        if ([part isMemberOfClass:[Chain class]])
            DLog(@"%@", [(Chain *)part longDescription]);
    }
    DLog(@"----------------- springs");
    for (Spring * spring in springs)
    {
        if (!spring.p1.isPlayer && !spring.p2.isPlayer)
            DLog(@"%@", spring);
    }
    DLog(@"----------------- particles");
    for (Particle * part in _particles)
    {
        if ([part isMemberOfClass:[Particle class]])
            DLog(@"%@", part);
    }    
    DLog(@" ");
}
#endif
*/
#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
	if (k.level.inTransition) return;

//	DLog(@"Contact %@ <-> %@, normal=(%.3f,%.3f) impulse=%.3f", contact.bodyA.node.name, contact.bodyB.node.name, contact.contactNormal.dx, contact.contactNormal.dy, contact.collisionImpulse);

	SKNode *nodeA = contact.bodyA.node;
	Particle *partA;
	if ([nodeA isKindOfClass:[Particle class]]) {
		partA = (Particle *)nodeA;
		[partA collisionAction];
	}

	SKNode *nodeB = contact.bodyB.node;
	Particle *partB;
	if ([nodeB isKindOfClass:[Particle class]]) {
		partB = (Particle *)nodeB;
		[partB collisionAction];
	}

	CGPoint contactPoint = contact.contactPoint;//[k.world convertFromScenePoint:contact.contactPoint];

	// Wall check
	if (nodeA == k.viewController.scene && partB) {

		[k.sound play:@"wall" volume:[self soundVolumeForContact:contact] pos:contactPoint.x];

		[k.effects addSparksWithPos:contactPoint numSparks:clampl(contact.collisionImpulse/5, 4, 20)];

	} else {
		// Contact with other particle

		if (!partA.captured)
		{
			if (!partB.captured && !(partA.isPlayer || partB.isPlayer)) {
				[self handleChainCollision:partA with:partB];
			}

			BOOL tailtotail = partA.isPlayer && partB.isPlayer && (labs(partA.playerValue - partB.playerValue)==1);

			if (!tailtotail) {

				if (![partB isMemberOfClass:[Switch class]] && ![partA isMemberOfClass:[Switch class]]) {
					[k.sound play:@"part" volume:[self soundVolumeForContact:contact] pos:contactPoint.x];
				}

				//	CGPoint sparkPos = CGPointAddMult(pp, partToOther, 0.5);
				//	CGPoint sparkVel = CGPointScale(CGCreateVector(part.vel, other.vel), 0.5);
				[k.effects addSparksWithPos:contactPoint numSparks:clampl(contact.collisionImpulse/10, 2, 20)];
				if ((!partA.isPlayer && partB.isPlayer) || (partA.isPlayer && !partB.isPlayer)) {
					CGFloat factor = 2 * sqrt(contact.collisionImpulse) / (partA.imass + partB.imass);
					k.score = k.score + factor;
				}
			}

		}
	}
}

- (float)soundVolumeForContact:(SKPhysicsContact *)contact
{
	// hard impulses at 400-900
	// soft impulses at 8-90
	return fclampf(sqrt(contact.collisionImpulse)/25, 0, 1);
}

@end
