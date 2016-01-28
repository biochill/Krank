#import "Level+Levels.h"

@implementation Level (level001)

- (void)setup_level001
{
	[k.world setBackground:@"nasirkhan02"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;
/*
 # particles
 parts = [(w*1/3, cy), (w*2/3, cy)]
 
 if k.config.stage == 2:
 parts.extend([(cx, h*1/3), (cx, h*2/3)])
 elif k.config.stage == 3:
 parts.extend([(cx-w*1/12, h*1/3), (cx-w*1/12, h*2/3), (cx+w*1/12, h*1/3), (cx+w*1/12, h*2/3)])
 
 for i in range(len(parts)):
 k.particles.add(Particle({'pos': parts[i], 'color': 'white'}))
 
 # stones
 stones = []
 xd, yd = 80, 60
 if k.config.stage >= 2:
 stones.extend([(cx, cy-yd), (cx, cy+yd), (cx-xd, cy), (cx+xd, cy)])
 if k.config.stage >= 3:
 stones.extend([(cx-xd, cy-yd), (cx+xd, cy-yd), (cx-xd, cy+yd), (cx+xd, cy+yd)])
 
 for i in range(len(stones)):
 k.particles.add(Stone({'pos': stones[i], 'color': 'white'}))
 
 # magnet
 n = min(6, k.config.stage*2)
 k.particles.add (Magnet({'pos': (cx, cy), 'color': 'white', 'num': n}))
 
 # simple player
 k.player.setPos((cx, cy+h*1/4))
*/
	[Particle addWithPos:CGPointMake(w*1/3, cy) color:@"white"];
	[Particle addWithPos:CGPointMake(w*2/3, cy) color:@"white"];
	if (k.config.stage == 2) {
		[Particle addWithPos:CGPointMake(cx, h*1/3) color:@"white"];
		[Particle addWithPos:CGPointMake(cx, h*2/3) color:@"white"];
	} else if (k.config.stage == 3) {
		[Particle addWithPos:CGPointMake(cx-w*1/12, h*1/3) color:@"white"];
		[Particle addWithPos:CGPointMake(cx-w*1/12, h*2/3) color:@"white"];
		[Particle addWithPos:CGPointMake(cx+w*1/12, h*1/3) color:@"white"];
		[Particle addWithPos:CGPointMake(cx+w*1/12, h*2/3) color:@"white"];
	}

	// stones
	CGFloat dx = w/10, dy = h/10;
	if (k.config.stage >= 2) {
		[Stone addWithPos:CGPointMake(cx, cy-dy) color:@"white"];
		[Stone addWithPos:CGPointMake(cx, cy+dy) color:@"white"];
		[Stone addWithPos:CGPointMake(cx-dx, cy) color:@"white"];
		[Stone addWithPos:CGPointMake(cx+dx, cy) color:@"white"];
	}
	if (k.config.stage >= 3) {
		[Stone addWithPos:CGPointMake(cx-dx, cy-dy) color:@"white"];
		[Stone addWithPos:CGPointMake(cx+dx, cy-dy) color:@"white"];
		[Stone addWithPos:CGPointMake(cx-dx, cy+dy) color:@"white"];
		[Stone addWithPos:CGPointMake(cx+dx, cy+dy) color:@"white"];
	}

	// magnet 
	NSInteger n = minl(6, k.config.stage*2);
	[Magnet addWithPos:CGPointMake(cx, cy) color:@"white" num:n];

	// player
	k.player.pos = CGPointMake(cx, cy+h*1/4);
}

@end
