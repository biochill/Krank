#import "Level+Levels.h"

@implementation Level (level007)

- (void)setup_level007
{
	[k.world setBackground:@"tanakawho01"];
	[k.sound loadTheme:@"summer"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

/*
 # particles
 parts = [(  w/4,   h/4),
 (  w/2,   h/4),
 (3*w/4,   h/4),
 (  w/4, 3*h/4),
 (  w/2, 3*h/4),
 (3*w/4, 3*h/4)]
 
 for i in range(6):
 k.particles.add(Particle({'pos': parts[i], 'color': 'orange'}))
 
 # magnet
 n = min(6, 3+k.config.stage)
 k.particles.add (Magnet({'pos': (w/2, h/2), 'color': 'orange', 'num': n}))
 
 # stones
 if k.config.stage >= 2:
 num = (k.config.stage-1)*5
 k.particles.stoneCircle((cx, cy), 'orange', num, 90, -math.pi/2)
 
 # simple player
 k.player.setPos((cx, cy-130))
 
*/

	// particles
	[Particle addWithPos:CGPointMake(  w/4,   h/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(2*w/4,   h/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(3*w/4,   h/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(  w/4, 3*h/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(2*w/4, 3*h/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(3*w/4, 3*h/4) color:@"orange"];

	// stones
	if (k.config.stage >= 2) {
		[Particles stoneCircle:CGPointMake(cx, cy) color:@"orange" 
                           num:(k.config.stage-1)*5 
                        radius:(k.config.stage == 1 ? h/8.5 : h/6.4)
                         start:-M_PI/2];
	}

	// magnets
	NSInteger n = minl(6, 3+k.config.stage);
	[Magnet addWithPos:CGPointMake(cx, cy) color:@"orange" num:n];

	// player
	k.player.pos = CGPointMake(cx + w*0.18, cy);
}

@end
