#import "Level+Levels.h"

@implementation Level (level030)

- (void)setup_level030
{
	[k.world setBackground:@"tanakawho06"];
	[k.sound loadTheme:@"summer"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	if (k.config.stage < 3) {
		[Particle addWithPos:CGPointMake(cx, cy) color:@"blue"];
	} else {
		[Particle addWithPos:CGPointMake(cx-w*0.42, cy) color:@"blue"];
	}

	// chains
	[Chain addWithPos:CGPointMake(cx-w*3/8, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-w*3/8, cy+h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*3/8, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*3/8, cy+h*1/4) color:@"orange"];
    
	[Chain addWithPos:CGPointMake(cx-w*1/8, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-w*1/8, cy+h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*1/8, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*1/8, cy+h*1/4) color:@"orange"];
    
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*1/4) color:@"orange"];

    [Chain addWithPos:CGPointMake(cx+w*3/8, cy-h*1/8) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*3/8, cy+h*1/8) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-w*3/8, cy-h*1/8) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-w*3/8, cy+h*1/8) color:@"orange"];
    
    [Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*1/8) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*1/8) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*1/8) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*1/8) color:@"orange"];
    
	if (k.config.stage >= 2) {
		[Chain addWithPos:CGPointMake(cx-w*1/4, cy      ) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*1/4, cy      ) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*2/6, cy      ) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*2/6, cy      ) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*2/6,  cy+h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*2/6,  cy-h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*2/6,  cy+h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*2/6,  cy-h*2/6) color:@"orange"];
	}
	if (k.config.stage >= 3) {
		[Chain addWithPos:CGPointMake(cx+w*1/16, cy-h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*1/16, cy+h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*1/16, cy-h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*1/16, cy+h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*3/16, cy-h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*3/16, cy+h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*3/16, cy-h*2/6) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*3/16, cy+h*2/6) color:@"orange"];
	}
/*
    # chains
    chains = [(cx+w*3/8,       cy-h*1/8),
              (cx+w*3/8,       cy+h*1/8),
              (cx-w*3/8,       cy-h*1/8),
              (cx-w*3/8,       cy+h*1/8),
              (cx-w*3/8, cy-h*1/4),
              (cx+w*3/8, cy-h*1/4),
              (cx-w*3/8, cy+h*1/4),
              (cx+w*3/8, cy+h*1/4),
              (cx-w*1/4, cy-h*1/4),
              (cx-w*1/4, cy+h*1/4),              

              (cx+w*1/4, cy-h*1/4),
              (cx+w*1/4, cy+h*1/4),
              (cx-w*1/8, cy-h*1/4),
              (cx-w*1/8, cy+h*1/4),              
              (cx+w*1/8, cy-h*1/4),
              (cx+w*1/8, cy+h*1/4),
              (cx-w*1/4, cy-h*1/8),
              (cx-w*1/4, cy+h*1/8),              
              (cx+w*1/4, cy-h*1/8),
              (cx+w*1/4, cy+h*1/8),

              (cx-w*1/4, cy),
              (cx+w*1/4, cy),
              (cx-w*2/6, cy),
              (cx+w*2/6, cy),
              (cx-w*2/6,  cy+h*2/6),
              (cx-w*2/6,  cy-h*2/6),
              (cx+w*2/6,  cy+h*2/6),
              (cx+w*2/6,  cy-h*2/6),

              (cx+w*1/16,  cy-h*2/6),
              (cx+w*1/16,  cy+h*2/6),
              (cx-w*1/16,  cy-h*2/6),
              (cx-w*1/16,  cy+h*2/6),
              (cx+w*3/16,  cy-h*2/6),
              (cx+w*3/16,  cy+h*2/6),
              (cx-w*3/16,  cy-h*2/6),
              (cx-w*3/16,  cy+h*2/6),
]
    
    num_chains = [20, 28, len(chains)][k.config.stage-1]
    for i in range(num_chains):
        k.particles.add(Chain({'pos': chains[i], 'color': 'orange'}))
        
    d = 80
    anchor = [(cx-d, cy-d),
              (cx-d, cy+d), 
              (cx+d, cy-d),
              (cx+d, cy+d),
              (cx, cy-2*d),
              (cx, cy+2*d), 
              (cx+2*d, cy),
              (cx-2*d, cy),
              (cx, cy)]
    num_anchor = [6, 8, 9][k.config.stage-1]
    for i in range(num_anchor):
        num = (i < 4) and (k.config.stage==2 and 4 or 3) or (i == 8 and 8 or (k.config.stage==3 and 3 or 2))
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': num}))
        
    # simple player
    k.player.setPos((w*2/3,cy+h*0.42))
*/
	// anchors
	CGFloat d = 90*k.displayScaleFactor;
	int num = k.config.stage == 2 ? 4 : 3;
	[Anchor addWithPos:CGPointMake(cx-d,   cy-d) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-d,   cy+d) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d,   cy-d) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d,   cy+d) color:@"orange" maxLinks:num];
	num = k.config.stage == 3 ? 3 : 2;
	[Anchor addWithPos:CGPointMake(cx,     cy-2*d) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx,     cy+2*d) color:@"orange" maxLinks:num];
	if (k.config.stage >= 2) {
#if TARGET_OS_TV
		[Anchor addWithPos:CGPointMake(cx+2*d, cy) color:@"orange" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx-2*d, cy) color:@"orange" maxLinks:num];
#else
		[Anchor addWithPos:CGPointMake(cx+1.6*d, cy) color:@"orange" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx-1.6*d, cy) color:@"orange" maxLinks:num];
#endif
	}
	if (k.config.stage >= 3) {
		[Anchor addWithPos:CGPointMake(cx,     cy) color:@"orange" maxLinks:8];
	}

	// player
	k.player.pos = CGPointMake(w*2/3, cy+h*0.42);
}

@end
