#import "Level+Levels.h"

@implementation Level (level009)

- (void)setup_level009
{
	[k.world setBackground:@"Big-E-Mr-G12"];
	[k.sound loadTheme:@"water"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[Chain addWithPos:CGPointMake(cx, h*1/5) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx, h*4/5) color:@"orange"];
	[Chain addWithPos:CGPointMake(w*1/4, h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(w*1/4, h*3/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(w*3/4, h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(w*3/4, h*3/4) color:@"orange"];
/*
    # chains
    chains = [(cx, h*1/5),
              (cx, h*4/5),
              (w*1/4, h*1/4),
              (w*1/4, h*3/4),              
              (w*3/4, h*1/4),
              (w*3/4, h*3/4)]
    
    for i in range(len(chains)):
        k.particles.add(Chain({'pos': chains[i], 'color': 'orange'}))
        
    # anchors
    d = 140
    anchor = [(cx-d, cy), (cx+d, cy)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': k.config.stage>=3 and 2 or 1}))
        
    if k.config.stage >= 2:
        k.particles.add(Anchor({'pos': (cx, cy), 'color': 'orange', 'maxLinks': 2}))
        k.particles.ballCircle((cx, cy), 'blue', k.config.stage*2, 70)
        if k.config.stage >= 3:
            k.particles.chainCircle((cx, cy), 'orange', 6, 120, -math.pi/2)
    else:
        k.particles.add(Stone({'pos': (cx, cy), 'color': 'orange'}))

    k.player.setPos((cx, h*2/3))
*/
	// anchors
	CGFloat dx = 140*k.displayScaleFactor;//h/4.3;
	int num = k.config.stage >= 3 ? 2 : 1;
	[Anchor addWithPos:CGPointMake(cx-dx, cy) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+dx, cy) color:@"orange" maxLinks:num];

	if (k.config.stage >= 2) {
		[Anchor addWithPos:CGPointMake(cx, cy) color:@"orange" maxLinks:2];
		[Particles ballCircle:CGPointMake(cx, cy) color:@"blue" num:k.config.stage*2 radius:h/11];
		if (k.config.stage >= 3) {
			[Particles chainCircle:CGPointMake(cx, cy) color:@"orange" num:6 radius:h/6.4 start:-M_PI/2];
		}
	} else {
		[Stone addWithPos:CGPointMake(cx, cy) color:@"orange"];
	}

	// player
	if (k.config.stage == 3)
		k.player.pos = CGPointMake(cx+w*0.2, h*2/3);
	else 
		k.player.pos = CGPointMake(cx, h*2/3);
}

@end
