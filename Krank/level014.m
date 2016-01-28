#import "Level+Levels.h"

@implementation Level (level014)

- (void)setup_level014
{
	[k.world setBackground:@"GaryP01"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;
/*
 # 18 particles
 parts = [(  w/4,    h/4),
 (3*w/4,    h/4),
 (  w/6,    h/4),
 (5*w/12,   h/4),
 (6*w/12,   h/4),
 (7*w/12,   h/4),
 (5*w/6,    h/4),
 (  w/3,    h/4),
 (2*w/3,    h/4),
 (  w/4,  3*h/4),
 (3*w/4,  3*h/4),
 (  w/6,  3*h/4),
 (5*w/12, 3*h/4),
 (6*w/12, 3*h/4),
 (7*w/12, 3*h/4),
 (5*w/6,  3*h/4),
 (  w/3,  3*h/4),
 (2*w/3,  3*h/4)]
 
 for i in range(18):
 k.particles.add(Particle({'pos': parts[i], 'color': (i%2) and 'orange' or 'blue'}))
 
 # 3 magnets
 k.particles.add (Magnet({'pos': (1*w/3, h/2), 'color': 'orange', 'num': min(5, 2+k.config.stage)}))
 k.particles.add (Magnet({'pos': (2*w/3, h/2), 'color': 'orange', 'num': min(5, 2+k.config.stage)}))
 k.particles.add (Magnet({'pos': (w/2, h/2),   'color': 'blue', 'num': min(6, 3+k.config.stage)}))
 
 # simple player
 k.player.setPos((w/2, 3*h/8))
*/
	// particles
	CGFloat dx = w*0.0867;
	for (int i = 0; i < 5; ++i) {
		NSString *color1 = i % 2 ? @"orange" : @"blue";
		NSString *color2 = i % 2 ? @"blue" : @"orange";
		[Particle addWithPos:CGPointMake(cx + i*dx, h/4) color:color1];
		[Particle addWithPos:CGPointMake(cx + i*dx, 3*h/4) color:color2];
		if (i > 0) {
			[Particle addWithPos:CGPointMake(cx - i*dx, h/4) color:color1];
			[Particle addWithPos:CGPointMake(cx - i*dx, 3*h/4) color:color2];
		}
	}

	// magnets
	[Magnet addWithPos:CGPointMake(1*w/3, h/2) color:@"orange" num:minl(5, 2+k.config.stage)];
	[Magnet addWithPos:CGPointMake(2*w/3, h/2) color:@"orange" num:minl(5, 2+k.config.stage)];
	[Magnet addWithPos:CGPointMake(w/2, h/2) color:@"blue" num:minl(6, 3+k.config.stage)];

	// player
	k.player.pos = CGPointMake(cx, h*3/8);
}

@end
