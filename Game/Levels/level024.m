#import "Level+Levels.h"

@implementation Level (level024)

- (void)setup_level024
{
	[k.world setBackground:@"Big-E-Mr-G05"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, cy) color:@"white"];

	// chains
	[Chain addWithPos:CGPointMake(cx, h*1/5) color:@"blue"];
	[Chain addWithPos:CGPointMake(cx, h*4/5) color:@"blue"];
	[Chain addWithPos:CGPointMake(w*1/4, h*1/4) color:@"blue"];
	[Chain addWithPos:CGPointMake(w*1/4, h*3/4) color:@"blue"];
	[Chain addWithPos:CGPointMake(w*3/4, h*1/4) color:@"blue"];
	[Chain addWithPos:CGPointMake(w*3/4, h*3/4) color:@"blue"];

	[Particles chainCircle:CGPointMake(cx, cy) color:@"orange" num:6 radius:h*2/5];

	if (k.config.stage > 1) {
		[Chain addWithPos:CGPointMake(cx-w*3/8, cy+h*0.2) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx+w*3/8, cy+h*0.2) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx-w*3/8, cy-h*0.2) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx+w*3/8, cy-h*0.2) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx-w*3/8, cy+h*0.3) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx+w*3/8, cy+h*0.3) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx-w*3/8, cy-h*0.3) color:@"pink"];
		[Chain addWithPos:CGPointMake(cx+w*3/8, cy-h*0.3) color:@"pink"];
		if (k.config.stage > 2) {
			[Chain addWithPos:CGPointMake(cx-w*3/8, cy) color:@"pink"];
			[Chain addWithPos:CGPointMake(cx+w*3/8, cy) color:@"pink"];
		}
	}
/*
    k.particles.add(Particle({'pos': (cx, cy), 'color': 'white'}))
    
    # chains
    chains = [(cx, h*1/5),
              (cx, h*4/5),
              (w*1/4, h*1/4),
              (w*1/4, h*3/4),              
              (w*3/4, h*1/4),
              (w*3/4, h*3/4)]
    
    for i in range(len(chains)):
        k.particles.add(Chain({'pos': chains[i], 'color': 'blue'}))

    k.particles.chainCircle((cx, cy), 'orange', 6, h*2/5)

    if k.config.stage > 1:
        chains = [(cx-w*3/8, cy+h*0.2),
                  (cx+w*3/8, cy+h*0.2),
                  (cx-w*3/8, cy-h*0.2),
                  (cx+w*3/8, cy-h*0.2),              
                  (cx-w*3/8, cy+h*0.3),
                  (cx+w*3/8, cy+h*0.3),
                  (cx-w*3/8, cy-h*0.3),
                  (cx+w*3/8, cy-h*0.3),
                  (cx-w*3/8, cy),
                  (cx+w*3/8, cy)]
    
        num_chains = k.config.stage == 2 and 8 or len(chains)
        for i in range(num_chains):
            k.particles.add(Chain({'pos': chains[i], 'color': 'pink'}))
        
    # anchors
    anchor = [(cx, cy-100),
              (cx, cy+100)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': 1}))

    anchor = [(cx+100, cy),
              (cx-100, cy)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': 1}))

    if k.config.stage > 1: 
        d = k.config.stage == 2 and 130 or 100
        anchor = [(cx+d, cy+d),
                  (cx-d, cy+d),
                  (cx+d, cy-d),
                  (cx-d, cy-d)]
        for i in range(len(anchor)):
            k.particles.add(Anchor({'pos':anchor[i], 'color': 'pink', 'maxLinks': 1}))
*/
	// anchors
	CGFloat r = 100*k.displayScaleFactor;
	[Anchor addWithPos:CGPointMake(cx, cy-r) color:@"orange" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx, cy+r) color:@"orange" maxLinks:1];

	[Anchor addWithPos:CGPointMake(cx+r, cy) color:@"blue" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx-r, cy) color:@"blue" maxLinks:1];

	if (k.config.stage > 1) {
		CGFloat d = k.config.stage == 2 ? r*1.3 : r;
		[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"pink" maxLinks:1];
		[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"pink" maxLinks:1];
		[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"pink" maxLinks:1];
		[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"pink" maxLinks:1];
	}

	// player
	k.player.pos = CGPointMake(cx+w*0.2, cy+h*0.1);
}

@end
