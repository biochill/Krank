#import "Level+Levels.h"

@implementation Level (level012)

- (void)setup_level012
{
	[k.world setBackground:@"somadjinn01"];
	[k.sound loadTheme:@"water"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	if (k.config.stage == 1) {
		[Particle addWithPos:CGPointMake(w*1/8, cy) color:@"white"];
		[Particle addWithPos:CGPointMake(w*7/8, cy) color:@"white"];
	} else if (k.config.stage == 2) {
		[Particle addWithPos:CGPointMake(w*1/4, h/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*3/4, h/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*1/4, h*3/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*3/4, h*3/4) color:@"white"];
	} else {
		[Particle addWithPos:CGPointMake(w*1/4, h/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*3/4, h/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*1/4, h*3/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*3/4, h*3/4) color:@"white"];
		[Particle addWithPos:CGPointMake(w*1/8, cy) color:@"white"];
		[Particle addWithPos:CGPointMake(w*7/8, cy) color:@"white"];
	}

	[Particle addWithPos:CGPointMake(w*1/4, cy) color:@"blue"];
	[Particle addWithPos:CGPointMake(w*3/4, cy) color:@"blue"];
	if (k.config.stage >= 2) {
		[Particle addWithPos:CGPointMake(cx, h*3/16) color:@"blue"];
		[Particle addWithPos:CGPointMake(cx, h*13/16) color:@"blue"];
	}
	if (k.config.stage >= 3) {
		[Particle addWithPos:CGPointMake(cx, h*3/32) color:@"blue"];
		[Particle addWithPos:CGPointMake(cx, h*29/32) color:@"blue"];
	}
/*
    # particles
    if k.config.stage == 1:
        parts = [(w/8, cy), (w*7/8, cy)]
    elif k.config.stage == 2:
        parts = [(w/4, h/4), (3*w/4, h/4), (w/4, 3*h/4), (3*w/4, 3*h/4)]
    elif k.config.stage >= 3:
        parts = [(w/4, h/4), (3*w/4, h/4), (w/4, 3*h/4), (3*w/4, 3*h/4), (w/8, cy), (w*7/8, cy)]
    
    for i in range(len(parts)):
        k.particles.add(Particle({'pos': parts[i], 'color': 'white'}))
    
    # particles
    parts = [(w/4, cy), (w*3/4, cy)]
    
    if k.config.stage >= 2:
        parts.extend([(cx, h*3/16), (cx, h*13/16)])

    if k.config.stage >= 3:
        parts.extend([(cx, h*3/32), (cx, h*29/32)])
    
    for i in range(len(parts)):
        k.particles.add(Particle({'pos': parts[i], 'color': 'blue'}))    
    
    # magnets 
    n = min(k.config.stage*2, 6)
    k.particles.add (Magnet({'pos': (w/2,     h*1/3), 'color': 'white', 'num': n}))
    k.particles.add (Magnet({'pos': (w/2,     h*2/3), 'color': 'white', 'num': n}))
    k.particles.add (Magnet({'pos': (w*9/24,  h/2),   'color': 'blue',  'num': n}))
    k.particles.add (Magnet({'pos': (w*15/24, h/2),   'color': 'blue',  'num': n}))

    # simple player
    pos = vector(k.world.rect.center)
    if k.config.stage > 1:
        pos += (w*3/24, h*3/24)
    k.player.setPos(pos)
*/
	// magnets
	NSInteger n = minl(6, k.config.stage*2);
	[Magnet addWithPos:CGPointMake(w/2, h*1/3) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(w/2, h*2/3) color:@"white" num:n];
	[Magnet addWithPos:CGPointMake(w*9/24, h/2) color:@"blue" num:n];
	[Magnet addWithPos:CGPointMake(w*15/24, h/2) color:@"blue" num:n];

	// player
	CGPoint pos = k.world.center;
	if (k.config.stage > 1)
		pos = CGPointAdd(pos, CGPointMake(w*3/24, h*3/24));
	k.player.pos = pos;
}

@end
