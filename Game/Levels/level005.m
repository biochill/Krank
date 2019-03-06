#import "Level+Levels.h"

@implementation Level (level005)

- (void)setup_level005
{
	[k.world setBackground:@"GaryP03"];
	[k.sound loadTheme:@"water"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

/*
	xd = 170
    # particles
    if k.config.stage == 1:
        parts = [( cx-w*0.2, cy-h*0.2 ),
                 ( cx+w*0.2, cy+h*0.2 ),
                 ( cx+w*0.2, cy-h*0.2 ),
                 ( cx-w*0.2, cy+h*0.2 )]
        
        for i in range(len(parts)):
            k.particles.add(Particle({'pos': parts[i], 'color': i < 2 and 'blue' or 'white'}))
    else:
        num = (k.config.stage-1)*3
        k.particles.ballCircle((cx-xd, cy), 'white',  num, 150)
        k.particles.ballCircle((cx+xd, cy), 'blue',   num, 150)        
    
    # magnets 
    n = min(6, k.config.stage*2)
    k.particles.add (Magnet({'pos': (cx-xd, cy), 'color': 'white', 'num': n}))
    k.particles.add (Magnet({'pos': (cx+xd, cy), 'color': 'blue',  'num': n}))

    # stones
    if k.config.stage >= 2:
        num = (k.config.stage-1)*3
        k.particles.stoneCircle((cx-xd, cy), 'blue',  num, 70+(k.config.stage-2)*30)
        k.particles.stoneCircle((cx+xd, cy), 'white', num, 70+(k.config.stage-2)*30)        
*/
	// particles
	CGFloat dx = 170*k.displayScaleFactor;
	NSInteger num = minl(6, k.config.stage*2);
	if (k.config.stage == 1) {
		[Particle addWithPos:CGPointMake(cx-w*0.2, cy-h*0.2) color:@"blue"];
		[Particle addWithPos:CGPointMake(cx+w*0.2, cy+h*0.2) color:@"blue"];
		[Particle addWithPos:CGPointMake(cx+w*0.2, cy-h*0.2) color:@"white"];
		[Particle addWithPos:CGPointMake(cx-w*0.2, cy+h*0.2) color:@"white"];
	} else {
		[Particles ballCircle:CGPointMake(cx-dx, cy) color:@"white" num:num radius:150*k.displayScaleFactor];
		[Particles ballCircle:CGPointMake(cx+dx, cy) color:@"blue" num:num radius:150*k.displayScaleFactor];

		// stones
//		CGFloat r = h/11 + (k.config.stage - 2)*h/25.6;
		CGFloat r = (70 + (k.config.stage - 2)*30)*k.displayScaleFactor;
		[Particles stoneCircle:CGPointMake(cx-dx, cy) color:@"blue" num:num radius:r];
		[Particles stoneCircle:CGPointMake(cx+dx, cy) color:@"white" num:num radius:r];
	}

	// magnets
	[Magnet addWithPos:CGPointMake(cx-dx, cy) color:@"white" num:num];
	[Magnet addWithPos:CGPointMake(cx+dx, cy) color:@"blue" num:num];

	// player
	k.player.pos = CGPointMake(cx, cy+(k.config.stage > 1 ? h/4 : 0));
}

@end
