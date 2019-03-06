#import "Level+Levels.h"

@implementation Level (level019)

- (void)setup_level019
{
	[k.world setBackground:@"tanakawho03"];
	[k.sound loadTheme:@"summer"];

	CGFloat /*cx = k.world.center.x, cy = k.world.center.y,*/ w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(5*w/12, 4*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(7*w/12, 4*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(4*w/12, 6*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(8*w/12, 6*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(5*w/12, 8*h/12) color:@"orange"];
	[Particle addWithPos:CGPointMake(7*w/12, 8*h/12) color:@"orange"];

	[Particle addWithPos:CGPointMake(6*w/12, 2*h/12) color:@"pink"];
	[Particle addWithPos:CGPointMake(3*w/12, 4*h/12) color:@"pink"];
	[Particle addWithPos:CGPointMake(9*w/12, 4*h/12) color:@"pink"];
	[Particle addWithPos:CGPointMake(9*w/12, 8*h/12) color:@"pink"];
	[Particle addWithPos:CGPointMake(3*w/12, 8*h/12) color:@"pink"];
	[Particle addWithPos:CGPointMake(6*w/12, 10*h/12) color:@"pink"];

	[Particle addWithPos:CGPointMake(4*w/12, 2*h/12) color:@"white"];
	[Particle addWithPos:CGPointMake(8*w/12, 2*h/12) color:@"white"];
	[Particle addWithPos:CGPointMake(2*w/12, 6*h/12) color:@"white"];
	[Particle addWithPos:CGPointMake(10*w/12, 6*h/12) color:@"white"];
	[Particle addWithPos:CGPointMake(4*w/12, 10*h/12) color:@"white"];
	[Particle addWithPos:CGPointMake(8*w/12, 10*h/12) color:@"white"];

/*
    # particles
    parts = [(5*w/12, 4*h/12),
             (7*w/12, 4*h/12),
             (4*w/12, 6*h/12),
             (8*w/12, 6*h/12),
             (5*w/12, 8*h/12),
             (7*w/12, 8*h/12)]
    
    for i in range(6):
        k.particles.add(Particle({'pos': parts[i], 'color': 'orange'}))
    
    parts = [(6*w/12,  2*h/12),
             (3*w/12,  4*h/12),
             (9*w/12,  4*h/12),
             (9*w/12,  8*h/12),
             (3*w/12,  8*h/12),
             (6*w/12, 10*h/12)]
    
    for i in range(6):
        k.particles.add(Particle({'pos': parts[i], 'color': 'pink'}))

    parts = [( 4*w/12,  2*h/12),
             ( 8*w/12,  2*h/12),
             ( 2*w/12,  6*h/12),
             (10*w/12,  6*h/12),
             ( 4*w/12, 10*h/12),
             ( 8*w/12, 10*h/12)]
    
    for i in range(6):
        k.particles.add(Particle({'pos': parts[i], 'color': 'white'}))

    # 4 magnets 
    num = k.config.stage+3
    k.particles.add (Magnet({'pos': ( 5*w/24,  5*h/24), 'color': 'white',  'num': num}))
    k.particles.add (Magnet({'pos': (19*w/24,  5*h/24), 'color': 'orange', 'num': num}))
    k.particles.add (Magnet({'pos': ( 5*w/24, 19*h/24), 'color': 'orange', 'num': num}))    
    k.particles.add (Magnet({'pos': (19*w/24, 19*h/24), 'color': 'white',  'num': num}))
    k.particles.add (Magnet({'pos': (   w/2,     h/2),  'color': 'pink',   'num': num}))

    # simple player
    k.player.setPos((w/2, 5*h/12))
*/
	// magnets
	NSInteger num = k.config.stage + 3;
	[Magnet addWithPos:CGPointMake(w*0.22, h*0.248) color:@"white" num:num];
	[Magnet addWithPos:CGPointMake(w*0.78, h*0.248) color:@"orange" num:num];
	[Magnet addWithPos:CGPointMake(w*0.22, h*0.752) color:@"orange" num:num];
	[Magnet addWithPos:CGPointMake(w*0.78, h*0.752) color:@"white" num:num];
	[Magnet addWithPos:CGPointMake(   w/2 ,    h/2 ) color:@"pink" num:num];

	// player
	k.player.pos = CGPointMake(w/2, h*5/12);
}

@end
