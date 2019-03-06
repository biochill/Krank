#import "Level+Levels.h"

@implementation Level (level010)

- (void)setup_level010
{
	[k.world setBackground:@"IHP03"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, h*3/16) color:@"white"];
	[Particle addWithPos:CGPointMake(cx, h*13/16) color:@"white"];
	if (k.config.stage >= 2) {
		[Particle addWithPos:CGPointMake(w*1/4, cy) color:@"white"];
		[Particle addWithPos:CGPointMake(w*3/4, cy) color:@"white"];
	}
	if (k.config.stage >= 3) {
		[Particle addWithPos:CGPointMake(w*1/8, cy) color:@"white"];
		[Particle addWithPos:CGPointMake(w*7/8, cy) color:@"white"];
	}

	// magnets
	NSInteger n = minl(6, k.config.stage*2);
	[Magnet addWithPos:CGPointMake(cx, h*1/3) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(cx, h*2/3) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(w*9/24, cy) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(w*15/24, cy) color:@"white" num:n];

	// player
    k.player.pos = CGPointMake(w*15/24, h*1/3);
}

@end
