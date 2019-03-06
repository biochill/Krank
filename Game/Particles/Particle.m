//
//  Particle.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Particle.h"
#import "Globals.h"


const NSInteger IsNotAPlayer = 0;

static const double defaultDrag = 0.001;


@interface Particle ()
@property (nonatomic) CGFloat drag;
@property (nonatomic) CGPoint lastPos;
@end


@implementation Particle

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)colorName
{
	Particle *part = [[Particle alloc] initWithPos:aPos color:colorName imageName:nil player:IsNotAPlayer drag:defaultDrag];
	[k.particles addParticle:part];
	return part;
}

//---------------------------------------------------------------------------------

- (instancetype)initWithPos:(CGPoint)aPos imageName:(NSString *)imageName
{
	return [self initWithPos:aPos color:nil imageName:imageName player:IsNotAPlayer drag:defaultDrag];
}

- (instancetype)initWithPos:(CGPoint)aPos imageName:(NSString *)imageName player:(NSInteger)playerValue
{
	return [self initWithPos:aPos color:nil imageName:imageName player:playerValue drag:defaultDrag];
}

- (instancetype)initWithPos:(CGPoint)aPos imageName:(NSString *)imageName player:(NSInteger)playerValue drag:(CGFloat)dragValue
{
	return [self initWithPos:aPos color:nil imageName:imageName player:playerValue drag:dragValue];
}

- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)colorName imageName:(NSString *)imageName player:(NSInteger)playerValue
{
	return [self initWithPos:aPos color:colorName imageName:imageName player:playerValue drag:defaultDrag];
}

//-----------------------------------------------------------------------------

- (instancetype)initWithPos:(CGPoint)pos color:(NSString *)colorName imageName:(NSString *)imageName player:(NSInteger)playerValue drag:(CGFloat)dragValue
{
	if ((self = [super initWithPos:pos])) {

		static int identifier_count = 0;
		_identifier = identifier_count++;

		NSString *name;
		if (colorName) {
			if (imageName) {
				name = [NSString stringWithFormat:@"%@_%@", imageName, colorName];
			} else {
				name = [NSString stringWithFormat:@"dot28_%@", colorName];
			}
			_colorName = colorName;
		} else {
			name = imageName;
			_colorName = @"";
		}
		[self setImageName:name];

		_vel = CGPointZero;
//		_force = CGPointZero;
		_drag = dragValue;
		_imass = 1; // default weight 1 kg
		_radius = self.size.height/2; // assuming square size
		_captured = NO;
		_playerValue = playerValue;
		_lastPos = self.position;

		// Create physics body
		SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:_radius];
		body.mass = self.imass;
		body.dynamic = YES;
		body.affectedByGravity = NO;
		body.allowsRotation = NO;
		body.contactTestBitMask = PHYSICS_CONTACT_OBJECTS;
		body.fieldBitMask = PHYSICS_FIELD_MAGNET | PHYSICS_FIELD_BORDER;
		body.friction = 0;
		body.restitution = 1; // bounce 100% elasically
		body.linearDamping = 0; // we provide our own damping force (via drag)
		self.physicsBody = body;
	}
	return self;
}

- (void)setImass:(CGFloat)imass
{
	_imass = imass;

	self.physicsBody.dynamic = imass != 0;
}

- (BOOL)isPlayer
{
	return _playerValue != IsNotAPlayer;
}

//- (void)setVel:(CGPoint)vel
//{
//	self.physicsBody.velocity = CGVectorMake(vel.x, -vel.y);
//}
//
//- (CGPoint)vel
//{
//	CGVector v = self.physicsBody.velocity;
//	return CGPointMake(v.dx, -v.dy);
//}

- (void)applyImpulse:(CGPoint)impulse
{
// impulse in SKScene coordinates
	[self.physicsBody applyImpulse:CGVectorMake(impulse.x, impulse.y)];
}

- (void)applyAccel:(CGPoint)accel
{
// accel in SKScene coordinates
	CGFloat m = self.imass;
	[self.physicsBody applyForce:CGVectorMake(accel.x*m, accel.y*m)];
	//	self.force = CGPointAdd(_force, aForce);
}

- (void)calcForces:(NSTimeInterval)delta
{
	if (self.imass == 0) return;

	// Compute velocity manually
	CGPoint pos = self.position;
	_vel = CGPointScale(CGPointSub(pos, _lastPos), 1.0/delta);

	// Apply damping force
//	[self applyAccel:CGPointScale(CGPointNeg(_vel), CGPointLength(_vel) * _drag)];
	CGPoint accel = CGPointScale(CGPointNeg(_vel), _drag/delta);
	[self applyAccel:accel];
//	DLog(@"damping %@ accel=%@", self.name, StringFromCGPoint(accel));

	_lastPos = pos;
}
/*
- (void)resetForce
{
	//	self.force = CGPointZero;
}

//------------------------------------------------------------------------------------------------------------------------

- (void)solveForce:(NSTimeInterval)seconds
{
//	self.vel = CGPointAddMult(_vel, _force, (_imass * seconds));
//	CGFloat maxvel = self.isPlayer ? 500 : k.world.rect.size.height;
//	if (CGPointLength(_vel) > maxvel)
//		self.vel = CGPointScale(CGPointNorm(_vel), maxvel);
//	self.pos = CGPointAdd(self.pos, CGPointScale(_vel, seconds));
}
*/
//------------------------------------------------------------------------------------------------------------------------

- (void)collisionAction
{
}

//------------------------------------------------------------------------------------------------------------------------

- (NSString *)description
{
	return [NSString stringWithFormat:@"[%@(%d)]", [self class], _identifier];
}

@end
