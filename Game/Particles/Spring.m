//
//  Spring.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Spring.h"
#import "Particle.h"
#import "Tools.h"
#import "Globals.h"


@interface Spring ()
{
	BOOL _oneWay;
	CGFloat _rl, _ks, _kd;
	BOOL _flag;
}
@property (nonatomic) int identifier;
@end


@implementation Spring

//+ (SKPhysicsJointSpring *)jointWithLength:(double)length part1:(Particle *)part1 part2:(Particle *)part2 damp:(CGFloat)damp
//{
//	SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:part1.physicsBody bodyB:part2.physicsBody anchorA:part1.position anchorB:part2.position];
//	joint.damping = damp;
//	joint.frequency = 0;
//	return joint;
//}

//+ (id)springWithLength:(double)length part1:(Particle *)part1 part2:(Particle *)part2 oneWay:(BOOL)oneWayValue
//				spring:(double)spring damp:(double)damp
//{
//	return [[Spring alloc] initWithLength:length part1:part1 part2:part2 oneWay:oneWayValue spring:spring damp:damp];
//}

- (id)initWithLength:(CGFloat)length part1:(Particle *)part1 part2:(Particle *)part2 oneWay:(BOOL)oneWayValue spring:(CGFloat)spring damp:(CGFloat)damp
{
	if ((self = [super init]))
	{
		static int identifier_count = 0;
		_identifier = identifier_count++;
		
		_rl = length;
		_p1 = part1;
		_p2 = part2;
		_oneWay = oneWayValue;
		_ks = spring;
		_kd = damp;
	}
	return self;
}

- (void)calcForces:(NSTimeInterval)delta
{
/*
// Old code:
	if (l > 0.0001) {

		CGFloat fac = (ks*(l-rl) + kd*CGPointDotProduct(CGPointSub(_p1.vel, _p2.vel), v)/l)/l;
		CGPoint f = CGPointScale(v, fac);
		[_p2 applyForce:f];
		if (!_oneWay)
			[_p1 applyForce:CGPointNeg(f)];
	}
*/

	CGPoint v = CGPointSub(_p1.position, _p2.position);
	CGFloat l = CGPointLength(v);
	CGFloat dist = l - _rl;
	if (dist > 0.001) {

		CGFloat fac = (_ks*dist + _kd*CGPointDotProduct(CGPointSub(_p1.vel, _p2.vel), v)/l)/l;
		CGPoint f = CGPointScale(v, fac*0.008/delta);
		[_p2 applyAccel:f];
		if (!_oneWay)
			[_p1 applyAccel:CGPointNeg(f)];

//		DLog(@"spring %@/%@ l=%.3f vel1=%@ vel2=%@ accel=%@", _p1.name, _p2.name, l, StringFromCGPoint(_p1.vel), StringFromCGPoint(_p2.vel), StringFromCGPoint(f));
	}
}

- (void)drawLine
{
	if (!_p1.isPlayer)
	{
		[k.lines addLineFrom:_p1.position to:_p2.position];
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"[%@ id=%d %@ -> %@]", [self class], _identifier, _p1, _p2];
}

@end
