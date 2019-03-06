#import "Level+Levels.h"

@implementation Level (level028)

- (void)setup_level028
{
	[k.world setBackground:@"Big-E-Mr-G15"];
	[k.sound loadTheme:@"summer"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, cy+h*2/6) color:@"orange"];
	[Particle addWithPos:CGPointMake(cx, cy-h*2/6) color:@"orange"];

	// chains
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/8, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/8, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/8, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/8, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*0.3, cy      ) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*0.3, cy      ) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*0.4, cy      ) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*0.4, cy      ) color:@"white"];
	[Chain addWithPos:CGPointMake(cx      , cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx      , cy+h*1/4) color:@"white"];

	if (k.config.stage >= 3) {
		[Chain addWithPos:CGPointMake(cx-w*0.35, cy-h*1/4) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*0.35, cy+h*1/4) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*0.35, cy-h*1/4) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*0.35, cy+h*1/4) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*0.35, cy-h*1/8) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*0.35, cy+h*1/8) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*0.35, cy-h*1/8) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*0.35, cy+h*1/8) color:@"white"];
	}
/*
    # particles
    parts  = [(cx,  cy+h*2/6),
              (cx,  cy-h*2/6)]
    
    for part in parts:
        k.particles.add(Particle({'pos': part, 'color': 'orange'}))
    
    # chains
    chains = [(cx-w*1/4, cy-h*1/4),
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
              (cx-w*0.3, cy),
              (cx+w*0.3, cy),
              (cx-w*0.4, cy),
              (cx+w*0.4, cy),
              (cx, cy-h*1/4),
              (cx, cy+h*1/4)]
    
    if k.config.stage == 3:
        chains.extend([(cx-w*0.35, cy-h*1/4),
                       (cx-w*0.35, cy+h*1/4),              
                       (cx+w*0.35, cy-h*1/4),
                       (cx+w*0.35, cy+h*1/4),
                       (cx-w*0.35, cy-h*1/8),
                       (cx-w*0.35, cy+h*1/8),              
                       (cx+w*0.35, cy-h*1/8),
                       (cx+w*0.35, cy+h*1/8),])
    
    for i in range(len(chains)):
        k.particles.add(Chain({'pos': chains[i], 'color': 'white'}))
        
    d = 80
    anchor = [(cx-d, cy-d),
              (cx-d, cy+d), 
              (cx+d, cy-d),
              (cx+d, cy+d),
              (cx, cy),
              (cx-2*d, cy),
              (cx+2*d, cy),]
    num_anchors = [5, 7, 7][k.config.stage-1]
    for i in range(num_anchors):
        maxlinks = i == 4 and 4 or 2
        if k.config.stage == 3 and i < 4:
            maxlinks = 3
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': maxlinks}))
        
    # simple player
    k.player.setPos((w*0.6,h*0.89))
*/
	// anchors
	CGFloat d = 90*k.displayScaleFactor;
	int num = k.config.stage >= 3 ? 3 : 2;
	[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx    , cy) color:@"white" maxLinks:4];
	if (k.config.stage >= 2) {
		[Anchor addWithPos:CGPointMake(cx-2*d, cy) color:@"white" maxLinks:2];
		[Anchor addWithPos:CGPointMake(cx+2*d, cy) color:@"white" maxLinks:2];
	}

	// player
	k.player.pos = CGPointMake(w*0.6, h*0.89);
}

@end
