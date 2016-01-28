#import "Level+Levels.h"

@implementation Level (level002)

- (void)setup_level002
{
	[k.world setBackground:@"tanakawho04"];
	[k.sound loadTheme:@"summer"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(w*1/4, h*1/4) color:@"white"];
	[Particle addWithPos:CGPointMake(w*3/4, h*1/4) color:@"white"];
	[Particle addWithPos:CGPointMake(w*1/4, h*3/4) color:@"white"];
	[Particle addWithPos:CGPointMake(w*3/4, h*3/4) color:@"white"];
	if (k.config.stage >= 3) {
		[Particle addWithPos:CGPointMake(cx, h*1/4) color:@"white"];
		[Particle addWithPos:CGPointMake(cx, h*3/4) color:@"white"];
	}

	// stones
	if (k.config.stage >= 2) 
    {
		[Particles stoneCircle:CGPointMake(w*1/3, cy) color:@"white" num:k.config.stage*2 radius:h/10 start:M_PI/4];
		[Particles stoneCircle:CGPointMake(w*2/3, cy) color:@"white" num:k.config.stage*2 radius:h/10 start:M_PI/4];
	}

	// magnets
	NSInteger n = minl(6, k.config.stage*2);
	[Magnet addWithPos:CGPointMake(w*1/3, cy) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(w*2/3, cy) color:@"white" num:n];

	// player
	k.player.pos = CGPointMake(cx, cy-h/6.4);
}

@end
