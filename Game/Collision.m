//
//  Collision.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Collision.h"

@implementation Collision

- (id)initWithParticle:(Particle *)part normal:(CGPoint)normal factor:(CGFloat)factor
{
	if ((self = [super init]))
	{
		_p = part;
		_n = normal;
		_f = factor;
	}
	return self;
}

@end
