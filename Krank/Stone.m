//
//  Stone.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Stone.h"
#import "Particles.h"
#import "Globals.h"

@implementation Stone

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)aColor
{
	Stone *stone = [[Stone alloc] initWithPos:aPos color:aColor];
	[k.particles addParticle:stone];
	return stone;
}

- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)aColor
{
	if ((self = [super initWithPos:aPos color:aColor imageName:@"dot28_s" player:IsNotAPlayer])) {
		self.imass = 0;
	}
	return self;
}

@end
