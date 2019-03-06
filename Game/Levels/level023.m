#import "Level+Levels.h"

@implementation Level (level023)

- (void)setup_level023
{
	[k.world setBackground:@"darkmatter01"];
	[k.sound loadTheme:@"summer"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, cy) color:@"blue"];

	// chains

	// vertical row at x center
	[Chain addWithPos:CGPointMake(cx, cy-h*2/6) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx, cy+h*2/6) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx, cy-h*1/6) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx, cy+h*1/6) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx, cy-h*1/4) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx, cy+h*1/4) color:@"orange"];

	// 12 particles matching the red drops on the bg picture! (mirrored for each quadrant)
#if TARGET_OS_TV
	CGPoint p1 = CGPointMake(w*0.094, h*0.269);
	CGPoint p2 = CGPointMake(w*0.207, h*0.272);
	CGPoint p3 = CGPointMake(w*0.330, h*0.227);
#else
	CGPoint p1 = CGPointMake(w*0.094, h*0.261);
	CGPoint p2 = CGPointMake(w*0.207, h*0.264);
	CGPoint p3 = CGPointMake(w*0.330, h*0.228);
#endif

	[Chain addWithPos:p1 color:@"orange"];
	[Chain addWithPos:p2 color:@"orange"];
	[Chain addWithPos:p3 color:@"orange"];

	[Chain addWithPos:CGPointMake(w - p1.x, p1.y) color:@"orange"];
	[Chain addWithPos:CGPointMake(w - p2.x, p2.y) color:@"orange"];
	[Chain addWithPos:CGPointMake(w - p3.x, p3.y) color:@"orange"];

	[Chain addWithPos:CGPointMake(w - p1.x, h - p1.y) color:@"orange"];
	[Chain addWithPos:CGPointMake(w - p2.x, h - p2.y) color:@"orange"];
	[Chain addWithPos:CGPointMake(w - p3.x, h - p3.y) color:@"orange"];

	[Chain addWithPos:CGPointMake(p1.x, h - p1.y) color:@"orange"];
	[Chain addWithPos:CGPointMake(p2.x, h - p2.y) color:@"orange"];
	[Chain addWithPos:CGPointMake(p3.x, h - p3.y) color:@"orange"];

	if (k.config.stage == 3) {
		[Chain addWithPos:CGPointMake(cx-w*1/4, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*1/4, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*1/8, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*1/8, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx-w*3/8, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx+w*3/8, cy) color:@"orange"];
	}
/*
    # particle
    k.particles.add(Particle({'pos': (cx, cy), 'color': 'blue'}))
    
    # chains
    chains = [(cx,       cy-h*2/6),
              (cx,       cy+h*2/6),
              (cx,       cy-h*1/6),
              (cx,       cy+h*1/6),
              (cx,       cy-h*1/4),
              (cx,       cy+h*1/4),
              (cx-w*1/4, cy+h*1/4),              
              (cx+w*1/4, cy+h*1/4),
              (cx-w*1/8, cy+h*1/4),              
              (cx+w*1/8, cy+h*1/4),
              (cx-w*3/8, cy+h*1/4),              
              (cx+w*3/8, cy+h*1/4),
              (cx-w*1/4, cy-h*1/4),
              (cx+w*1/4, cy-h*1/4),
              (cx-w*1/8, cy-h*1/4),
              (cx+w*1/8, cy-h*1/4),
              (cx-w*3/8, cy-h*1/4),
              (cx+w*3/8, cy-h*1/4)]
    
    if k.config.stage == 3:
        chains.extend([(cx-w*1/4, cy),              
                      (cx+w*1/4, cy),
                      (cx-w*1/8, cy),              
                      (cx+w*1/8, cy),
                      (cx-w*3/8, cy),              
                      (cx+w*3/8, cy)])
    
    for i in range(len(chains)):
        k.particles.add(Chain({'pos': chains[i], 'color': 'orange'}))
        
    if k.config.stage == 1:
        d = 115
        anchor = [(cx-d, cy), (cx+d, cy)]
        for i in range(len(anchor)):
            k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': 3}))
    else:
        d = 80
        anchor = [(cx-d, cy-d),
                  (cx+d, cy+d),
                  (cx+d, cy-d),
                  (cx-d, cy+d)]        
        
        for i in range(len(anchor)):
            links = k.config.stage == 3 and 4 or (i < 2 and 3 or k.config.stage)
            k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': links}))
*/
	// anchors
	if (k.config.stage == 1) {
		CGFloat d = 145*k.displayScaleFactor;
		[Anchor addWithPos:CGPointMake(cx-d, cy) color:@"orange" maxLinks:3];
		[Anchor addWithPos:CGPointMake(cx+d, cy) color:@"orange" maxLinks:3];
	} else {
		CGFloat d = 80*k.displayScaleFactor;
		NSInteger links = k.config.stage == 3 ? 4 : 3;
		[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"orange" maxLinks:links];
		links = k.config.stage == 3 ? 4 : 3;
		[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"orange" maxLinks:links];
		links = k.config.stage == 3 ? 4 : 2;
		[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"orange" maxLinks:links];
		links = k.config.stage == 3 ? 4 : 2;
		[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"orange" maxLinks:links];
	}

	// player
	k.player.pos = CGPointMake(w*0.72, h*0.61);
}

@end
