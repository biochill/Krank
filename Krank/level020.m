#import "Level+Levels.h"

@implementation Level (level020)

- (void)setup_level020
{
	[k.world setBackground:@"GaryP04"];
	[k.sound loadTheme:@"industry"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
#if TARGET_OS_TV
	if (k.config.stage > 1) {
		[Particle addWithPos:CGPointMake(cx-w*0.35, cy+h*0.31) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx-w*0.35, cy-h*0.31) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx+w*0.35, cy+h*0.31) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx+w*0.35, cy-h*0.31) color:@"orange"];
	} else {
		[Particle addWithPos:CGPointMake(cx-w*0.38, cy) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx+w*0.38, cy) color:@"orange"];
	}
#else
	if (k.config.stage > 1) {
		[Particle addWithPos:CGPointMake(cx-w*0.35, cy+h*0.35) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx-w*0.35, cy-h*0.35) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx+w*0.35, cy+h*0.35) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx+w*0.35, cy-h*0.35) color:@"orange"];
	} else {
		[Particle addWithPos:CGPointMake(cx-w*0.40, cy) color:@"orange"];
		[Particle addWithPos:CGPointMake(cx+w*0.40, cy) color:@"orange"];
	}
#endif

	// magnets
	if (k.config.stage < 3) {
		[Magnet addWithPos:CGPointMake(cx, cy) color:@"orange" num:k.config.stage*2];
	}

	// chains
	CGPoint chains[12] = {
#if TARGET_OS_TV
// tv
		CGPointMake(cx        , cy-h*0.432),
		CGPointMake(cx        , cy+h*0.432),
		CGPointMake(cx-w*0.129, cy-h*0.326),
		CGPointMake(cx-w*0.129, cy+h*0.326),
		CGPointMake(cx-w*0.192, cy-h*0.136),
		CGPointMake(cx-w*0.192, cy+h*0.136),
		CGPointMake(cx-w*0.27 , cy        ),
		CGPointMake(cx+w*0.129, cy-h*0.326),
		CGPointMake(cx+w*0.129, cy+h*0.326),
		CGPointMake(cx+w*0.192, cy-h*0.136),
		CGPointMake(cx+w*0.192, cy+h*0.136),
		CGPointMake(cx+w*0.27 , cy        )
#else
		CGPointMake(cx        , cy-h*0.38 ),
		CGPointMake(cx        , cy+h*0.38 ),
		CGPointMake(cx-w*0.158, cy-h*0.260),
		CGPointMake(cx-w*0.158, cy+h*0.260),
		CGPointMake(cx-w*0.22 , cy-h*0.125),
		CGPointMake(cx-w*0.22 , cy+h*0.125),
		CGPointMake(cx-w*0.31 , cy        ),
		CGPointMake(cx+w*0.158, cy-h*0.260),
		CGPointMake(cx+w*0.158, cy+h*0.260),
		CGPointMake(cx+w*0.22 , cy-h*0.125),
		CGPointMake(cx+w*0.22 , cy+h*0.125),
		CGPointMake(cx+w*0.31 , cy        )
#endif
    };

	for (int i = 0; i < 12; i++) {
		[Chain addWithPos:chains[i] color:@"blue"];
	}

	CGFloat r = h/12.8;
	if (k.config.stage > 1) {
		for (int i = 0; i < 12; ++i) {
			CGPoint pos = chains[i];
			CGPoint p = i > 1 ? CGPointMake((i > 6 ? r : -r), 0) : CGPointMake(0, (i ? -r : r));
			[Chain addWithPos:CGPointAdd(pos, p) color:@"blue"];
		}
	}

	r = r + r;
	if (k.config.stage > 2) {
		for (int i = 0; i < 12; ++i) {
			CGPoint pos = chains[i];
			CGPoint p = i > 1 ? CGPointMake((i > 6 ? r : -r), 0) : CGPointMake(0, (i ? -r : r));
			[Chain addWithPos:CGPointAdd(pos, p) color:@"blue"];
		}
	}
/*
    # particles
    if k.config.stage > 1:
        parts = [ (cx-w*2/6,  cy+h*2/6),
                  (cx-w*2/6,  cy-h*2/6),
                  (cx+w*2/6,  cy+h*2/6),
                  (cx+w*2/6,  cy-h*2/6)]
    else:
        parts = [(cx-(w*0.31+120),  cy), (cx+(w*0.31+120),  cy)]
    
    for part in parts:
        k.particles.add(Particle({'pos': part, 'color': 'orange'}))
    
    # magnet 
    if k.config.stage < 3:
        k.particles.add (Magnet({'pos': (cx, cy), 'color': 'orange', 'num': k.config.stage*2}))

    # chains
    chains = [(cx,       cy-h*0.37),
              (cx,       cy+h*0.37),
              (cx-w*0.16, cy-h*1/4),
              (cx-w*0.16, cy+h*1/4),              
              (cx-w*0.22, cy-h*1/8),
              (cx-w*0.22, cy+h*1/8),              
              (cx-w*0.31, cy),
              (cx+w*0.16, cy-h*1/4),
              (cx+w*0.16, cy+h*1/4),
              (cx+w*0.22, cy-h*1/8),
              (cx+w*0.22, cy+h*1/8),
              (cx+w*0.31, cy),]
    
    for i in range(len(chains)):
        k.particles.add(Chain({'pos': chains[i], 'color': 'blue'}))
    if k.config.stage > 1:
        for i in range(len(chains)):
            o = i > 1 and pos(i > 6 and 60 or -60, 0) or pos(0, i and -60 or 60)
            k.particles.add(Chain({'pos': vector(chains[i])+o, 'color': 'blue'}))
    if k.config.stage > 2:
        for i in range(len(chains)):
            o = i > 1 and pos(i > 6 and 120 or -120, 0) or pos(0, i and -120 or 120)
            k.particles.add(Chain({'pos': vector(chains[i])+o, 'color': 'blue'}))
                
    d = 80
    anchor = [(cx-d, cy-d),
              (cx-d, cy+d), 
              (cx+d, cy-d),
              (cx+d, cy+d),
              (cx+2.4*d, cy),
              (cx-2.4*d, cy),
              (cx, cy)]
    num_anchor = [4, 6, 7][k.config.stage-1]
    links = [(2, 2 , 2, 2), (3, 3, 3, 3, 2, 2), (4, 4, 4, 4, 2, 2, 4)][k.config.stage-1]
    for i in range(num_anchor):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': links[i]}))
        
    # simple player
    k.player.setPos((cx+w*0.16,cy+h*0.37))
*/
	// anchors
#if TARGET_OS_TV
	CGFloat d = h/8.3, d2 = 1.75*d;
#else
	CGFloat d = h/9.6, d2 = 2.2*d;
#endif
	CGPoint anchors[7] = {
		CGPointMake(cx-d , cy-d),
		CGPointMake(cx-d , cy+d),
		CGPointMake(cx+d , cy-d),
		CGPointMake(cx+d , cy+d),
		CGPointMake(cx+d2, cy),
		CGPointMake(cx-d2, cy),
		CGPointMake(cx   , cy)
    };
	int links_array1[] = { 2, 2, 2, 2 };
	int links_array2[] = { 3, 3, 3, 3, 2, 2 };
	int links_array3[] = { 4, 4, 4, 4, 2, 2, 4 };
	int anchors_array[] = { sizeof(links_array1) / sizeof(int), sizeof(links_array2) / sizeof(int), sizeof(links_array3) / sizeof(int) };
	int num_anchors = anchors_array[k.config.stage-1];
	int *links_arrays[] = { links_array1, links_array2, links_array3 }, *links = links_arrays[k.config.stage-1];

	for (int i = 0; i < num_anchors; ++i) {
		[Anchor addWithPos:anchors[i] color:@"blue" maxLinks:links[i]];
	}

	// player
#if TARGET_OS_TV
	k.player.pos = CGPointMake(cx+w*0.25, cy+h*0.23);
#else
	k.player.pos = CGPointMake(cx+w*0.12, cy+h*0.36);
#endif
}

@end
