#import "Level+Levels.h"

@implementation Level (level022)

- (void)setup_level022
{
	[k.world setBackground:@"GaryP02"];
	[k.sound loadTheme:@"summer"];

	CGFloat /*cx = k.world.center.x,*/ cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[Particle addWithPos:CGPointMake(5*w/12,  4*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(8*w/12,  2*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(7*w/12,  4*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(3*w/12,  6*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(9*w/12,  6*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(5*w/12,  8*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(7*w/12,  8*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(4*w/12, 10*h/12) color:@"orange"];

	[Particle addWithPos:CGPointMake(6*w/12,  2*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(4*w/12,  2*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(3*w/12,  4*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(9*w/12,  4*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(9*w/12,  8*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(3*w/12,  8*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(6*w/12, 10*h/12) color:@"blue"];
	[Particle addWithPos:CGPointMake(8*w/12, 10*h/12) color:@"blue"];
/*
    # particles
    parts = [(5*w/12,  4*h/12),
             (8*w/12,  2*h/12),
             (7*w/12,  4*h/12),
             (3*w/12,  6*h/12),
             (9*w/12,  6*h/12),
             (5*w/12,  8*h/12),
             (7*w/12,  8*h/12),
             (4*w/12, 10*h/12)]
    
    for i in range(8):
        k.particles.add(Particle({'pos': parts[i], 'color': 'orange'}))
    
    parts = [(6*w/12,  2*h/12),
             (4*w/12,  2*h/12),
             (3*w/12,  4*h/12),
             (9*w/12,  4*h/12),
             (9*w/12,  8*h/12),
             (3*w/12,  8*h/12),
             (6*w/12, 10*h/12),
             (8*w/12, 10*h/12)]
    
    for i in range(8):
        k.particles.add(Particle({'pos': parts[i], 'color': 'blue'}))

    # magnets 
    num = k.config.stage * 2
    k.particles.add (Magnet({'pos': (  w/4,   h/4), 'color': 'blue',   'num': num}))
    k.particles.add (Magnet({'pos': (3*w/4,   h/4), 'color': 'orange', 'num': num}))
    k.particles.add (Magnet({'pos': (  w/4, 3*h/4), 'color': 'orange', 'num': num}))    
    k.particles.add (Magnet({'pos': (3*w/4, 3*h/4), 'color': 'blue',   'num': num}))
    k.particles.add (Magnet({'pos': (  w/3,   cy), 'color': 'orange',  'num': num+1}))    
    k.particles.add (Magnet({'pos': (2*w/3,   cy), 'color': 'blue',    'num': num+1}))
*/
	// magnets
	NSInteger num = k.config.stage*2;
	[Magnet addWithPos:CGPointMake(w*0.256, h*0.234) color:@"blue" num:num]; // left top
	[Magnet addWithPos:CGPointMake(w*0.744, h*0.234) color:@"orange" num:num]; // right top
	[Magnet addWithPos:CGPointMake(w*0.256, h*0.766) color:@"orange" num:num]; // left bottom
	[Magnet addWithPos:CGPointMake(w*0.744, h*0.766) color:@"blue" num:num]; // right bottom
	[Magnet addWithPos:CGPointMake(  w/3, cy) color:@"orange" num:num+1]; // center left
	[Magnet addWithPos:CGPointMake(2*w/3, cy) color:@"blue" num:num+1]; // center right

	// player
	k.player.pos = CGPointMake(w/2, h*5/12);
}

@end
