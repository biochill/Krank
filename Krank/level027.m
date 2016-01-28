#import "Level+Levels.h"

@implementation Level (level027)

- (void)setup_level027
{
	[k.world setBackground:@"IHP02"];
	[k.sound loadTheme:@"industry"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[Particle addWithPos:CGPointMake(cx-w*2/6, cy+h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx-w*2/6, cy-h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx+w*2/6, cy+h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx+w*2/6, cy-h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx      , cy-h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx      , cy+h*2/6) color:@"blue"];

	[Particle addWithPos:CGPointMake(cx-w*1/4, cy-h*1/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(cx-w*1/4, cy+h*1/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(cx+w*1/4, cy-h*1/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(cx+w*1/4, cy+h*1/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(cx-w*1/8, cy-h*1/4) color:@"orange"];
	[Particle addWithPos:CGPointMake(cx-w*1/8, cy+h*1/4) color:@"orange"];

	[Particle addWithPos:CGPointMake(cx+w*1/8, cy-h*1/4) color:@"pink"];
	[Particle addWithPos:CGPointMake(cx+w*1/8, cy+h*1/4) color:@"pink"];
	[Particle addWithPos:CGPointMake(cx-w*1/4, cy-h*1/8) color:@"pink"];
	[Particle addWithPos:CGPointMake(cx-w*1/4, cy+h*1/8) color:@"pink"];
	[Particle addWithPos:CGPointMake(cx+w*1/4, cy-h*1/8) color:@"pink"];
	[Particle addWithPos:CGPointMake(cx+w*1/4, cy+h*1/8) color:@"pink"];

	[Particle addWithPos:CGPointMake(cx-w*1/4, cy      ) color:@"white"];
	[Particle addWithPos:CGPointMake(cx+w*1/4, cy      ) color:@"white"];
	[Particle addWithPos:CGPointMake(cx-w*2/6, cy      ) color:@"white"];
	[Particle addWithPos:CGPointMake(cx+w*2/6, cy      ) color:@"white"];
	[Particle addWithPos:CGPointMake(cx      , cy-h*1/4) color:@"white"];
	[Particle addWithPos:CGPointMake(cx      , cy+h*1/4) color:@"white"];
/*
    # particles
    parts = [ [(cx-w*2/6,  cy+h*2/6), 'blue'],
              [(cx-w*2/6,  cy-h*2/6), 'blue'],
              [(cx+w*2/6,  cy+h*2/6), 'blue'],
              [(cx+w*2/6,  cy-h*2/6), 'blue'],
              [(cx,        cy-h*2/6), 'blue'],
              [(cx,        cy+h*2/6), 'blue'],
              [(cx-w*1/4, cy-h*1/4), 'orange'],
              [(cx-w*1/4, cy+h*1/4), 'orange'],     
              [(cx+w*1/4, cy-h*1/4), 'orange'],
              [(cx+w*1/4, cy+h*1/4), 'orange'],
              [(cx-w*1/8, cy-h*1/4), 'orange'],
              [(cx-w*1/8, cy+h*1/4), 'orange'],     
              [(cx+w*1/8, cy-h*1/4), 'pink'],
              [(cx+w*1/8, cy+h*1/4), 'pink'],
              [(cx-w*1/4, cy-h*1/8), 'pink'],
              [(cx-w*1/4, cy+h*1/8), 'pink'],     
              [(cx+w*1/4, cy-h*1/8), 'pink'],
              [(cx+w*1/4, cy+h*1/8), 'pink'],
              [(cx-w*1/4, cy), 'white'],
              [(cx+w*1/4, cy), 'white'],
              [(cx-w*2/6, cy), 'white'],
              [(cx+w*2/6, cy), 'white'],
              [(cx, cy-h*1/4), 'white'],
              [(cx, cy+h*1/4), 'white'],]
    
    for i in range(len(parts)):
        k.particles.add(Particle({'pos': parts[i][0], 'color': parts[i][1]}))
        
    num = k.config.stage+3    
        
    d = 80
    magnet = [[(cx-d, cy-d), 'orange'],
              [(cx-d, cy+d), 'white'], 
              [(cx+d, cy-d), 'blue'],
              [(cx+d, cy+d), 'pink'],]
    for i in range(len(magnet)):
        k.particles.add(Magnet({'pos':magnet[i][0], 'color': magnet[i][1], 'num': num}))
        
    # simple player
    k.player.setPos((w*0.6,h*0.89))
*/
	// magnets
	NSInteger num = k.config.stage + 3;
	CGFloat d = h/9.6;
	[Magnet addWithPos:CGPointMake(cx-d, cy-d) color:@"orange" num:num];
	[Magnet addWithPos:CGPointMake(cx-d, cy+d) color:@"white" num:num];
	[Magnet addWithPos:CGPointMake(cx+d, cy-d) color:@"blue" num:num];
	[Magnet addWithPos:CGPointMake(cx+d, cy+d) color:@"pink" num:num];

	// player
	k.player.pos = CGPointMake(w*0.6, h*0.89);
}

@end
