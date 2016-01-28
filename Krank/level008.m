#import "Level+Levels.h"

@implementation Level (level008)

- (void)setup_level008
{
	[k.world setBackground:@"somadjinn03"];
	[k.sound loadTheme:@"industry"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;
/*
    # particles
    parts = [(  w/4,   h/4),
             (3*w/4,   h/4),
             (  w/4, 3*h/4),
             (3*w/4, 3*h/4)]

    if k.config.stage >= 2:
        parts.extend([(w/4, cy), (3*w/4, cy)])
    
    for i in range(len(parts)):
        k.particles.add(Particle({'pos': parts[i], 'color': 'white'}))
    
    # magnets 
    yd = 190
    n = min(6, 3+k.config.stage)
    k.particles.add (Magnet({'pos': (cx, cy-yd), 'color': 'white', 'num': n-2}))
    k.particles.add (Magnet({'pos': (cx, cy),    'color': 'white', 'num': n}))
    k.particles.add (Magnet({'pos': (cx, cy+yd), 'color': 'white', 'num': n-2}))
    
    # stones
    if k.config.stage >= 2 :
        num = min(k.config.stage*2, 6)
        k.particles.stoneCircle((cx, cy), 'white', num, 80)
        if k.config.stage >= 3:
            k.particles.stoneCircle((cx, cy-yd), 'white', num, 80)
            k.particles.stoneCircle((cx, cy+yd), 'white', num, 80)

    k.player.setPos((cx+(k.config.stage>=2 and 100), 3*h/8))
*/
	// particles
	[Particle addWithPos:CGPointMake(  w/4,   h/4) color:@"white"];
	[Particle addWithPos:CGPointMake(3*w/4,   h/4) color:@"white"];
	[Particle addWithPos:CGPointMake(  w/4, 3*h/4) color:@"white"];
	[Particle addWithPos:CGPointMake(3*w/4, 3*h/4) color:@"white"];
	if (k.config.stage >= 2) {
		[Particle addWithPos:CGPointMake(  w/4, cy) color:@"white"];
		[Particle addWithPos:CGPointMake(3*w/4, cy) color:@"white"];
	}

	// magnets
	CGFloat yd = h/3;
	NSInteger n = minl(6, 3+k.config.stage);
	[Magnet addWithPos:CGPointMake(cx, cy-yd) color:@"white" num:n-2];
	[Magnet addWithPos:CGPointMake(cx, cy) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(cx, cy+yd) color:@"white" num:n-2];

	// stones
	if (k.config.stage >= 2) {
		NSInteger num = minl(k.config.stage*2, 6);
		CGFloat r = h/7.5;
		[Particles stoneCircle:CGPointMake(cx, cy) color:@"white" num:num radius:r];
		if (k.config.stage >= 3) {
			[Particles stoneCircle:CGPointMake(cx, cy-yd) color:@"white" num:num radius:r];
			[Particles stoneCircle:CGPointMake(cx, cy+yd) color:@"white" num:num radius:r];
		}
	}

	// player
	k.player.pos = CGPointMake(cx+(k.config.stage>=2 ? w/8 : 0), h*3/8);
}

@end
