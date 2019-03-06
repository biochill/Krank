#import "Level+Levels.h"

@implementation Level (level021)

- (void)setup_level021
{
	[k.world setBackground:@"tanakawho07"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[Particle addWithPos:CGPointMake(cx, cy) color:@"white"];

	CGFloat d1y; // y-distance from center to chain group
	CGFloat d2; // x-distance from center to outer chain particle
	if (k.config.stage == 1) {
		d1y = h/4.1;
		d2 = w/3.2;
	} else if (k.config.stage == 2) {
		d1y = h/4;
		d2 = w/3;
	} else {
		d1y = h/4;
		d2 = w/2.5;
	}

	CGFloat d1 = d1y*(w/h);
	CGFloat d2y = d2/(w/h); //min(h/2 - h/24, d2);
	CGFloat d3 = (d1+d2)/2;
	CGFloat d3y = (d1y+d2y)/2;

	// chains
	[Chain addWithPos:CGPointMake(cx+d1, cy+d1y) color:@"white"]; // left top
	[Chain addWithPos:CGPointMake(cx+d1, cy+d2y) color:@"white"]; // left bottom
	[Chain addWithPos:CGPointMake(cx+d2, cy+d1y) color:@"white"]; // right top
	if (k.config.stage >= 2) [Chain addWithPos:CGPointMake(cx+d2, cy+d2y) color:@"white"]; // right bottom
	if (k.config.stage >= 3) [Chain addWithPos:CGPointMake(cx+d3, cy+d3y) color:@"white"]; // center

	[Chain addWithPos:CGPointMake(cx-d1, cy+d1y) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-d1, cy+d2y) color:@"orange"];
	[Chain addWithPos:CGPointMake(cx-d2, cy+d1y) color:@"orange"];
	if (k.config.stage >= 2) [Chain addWithPos:CGPointMake(cx-d2, cy+d2y) color:@"orange"];
	if (k.config.stage >= 3) [Chain addWithPos:CGPointMake(cx-d3, cy+d3y) color:@"orange"];

	[Chain addWithPos:CGPointMake(cx+d1, cy-d1y) color:@"blue"];
	[Chain addWithPos:CGPointMake(cx+d1, cy-d2y) color:@"blue"];
	[Chain addWithPos:CGPointMake(cx+d2, cy-d1y) color:@"blue"];
	if (k.config.stage >= 2) [Chain addWithPos:CGPointMake(cx+d2, cy-d2y) color:@"blue"];
	if (k.config.stage >= 3) [Chain addWithPos:CGPointMake(cx+d3, cy-d3y) color:@"blue"];

	[Chain addWithPos:CGPointMake(cx-d1, cy-d1y) color:@"pink"];
	[Chain addWithPos:CGPointMake(cx-d1, cy-d2y) color:@"pink"];
	[Chain addWithPos:CGPointMake(cx-d2, cy-d1y) color:@"pink"];
	if (k.config.stage >= 2) [Chain addWithPos:CGPointMake(cx-d2, cy-d2y) color:@"pink"];
	if (k.config.stage >= 3) [Chain addWithPos:CGPointMake(cx-d3, cy-d3y) color:@"pink"];
/*
    k.particles.add(Particle({'pos': (cx, cy), 'color': 'white'}))
    
    if k.config.stage == 1:
        d1, d2 = 140, 220
    elif k.config.stage == 2:
        d1, d2 = 170, 270
    else:
        d1, d2 = 170, 320
        
    d2y = min(k.world.rect.height/2 - 20, d2)
    d3, d3y = (d1+d2)/2, (d1+d2y)/2
    
    num_chains = k.config.stage+2
    
    # chains
    chains = [(cx+d1, cy+d1),
              (cx+d1, cy+d2y),
              (cx+d2, cy+d1),
              (cx+d2, cy+d2y),
              (cx+d3, cy+d3y)]
    
    for i in range(num_chains):
        k.particles.add(Chain({'pos': chains[i], 'color': 'white'}))

    # chains
    chains = [(cx-d1, cy+d1),
              (cx-d1, cy+d2y),
              (cx-d2, cy+d1),
              (cx-d2, cy+d2y),
              (cx-d3, cy+d3y)]
    
    for i in range(num_chains):
        k.particles.add(Chain({'pos': chains[i], 'color': 'orange'}))

    # chains
    chains = [(cx+d1, cy-d1),
              (cx+d1, cy-d2y),
              (cx+d2, cy-d1),
              (cx+d2, cy-d2y),
              (cx+d3, cy-d3y)]
    
    for i in range(num_chains):
        k.particles.add(Chain({'pos': chains[i], 'color': 'blue'}))

    # chains
    chains = [(cx-d1, cy-d1),
              (cx-d1, cy-d2y),
              (cx-d2, cy-d1),
              (cx-d2, cy-d2y),
              (cx-d3, cy-d3y)]
    
    for i in range(num_chains):
        k.particles.add(Chain({'pos': chains[i], 'color': 'pink'}))
        
    # anchors
    anchor = [(cx+70, cy), (cx+d2, cy)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': 1}))

    anchor = [(cx-70, cy), (cx-d2, cy)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': 1}))
        
    anchor = [(cx, cy+70), (cx, cy+d2y)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'pink', 'maxLinks': 1}))
                
    anchor = [(cx, cy-70), (cx, cy-d2y)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': 1}))                
*/
	// anchors
	CGFloat r = 100*k.displayScaleFactor, r2 = 285*k.displayScaleFactor;
	[Anchor addWithPos:CGPointMake(cx+r, cy) color:@"orange" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx+r2, cy) color:@"orange" maxLinks:1];

	[Anchor addWithPos:CGPointMake(cx-r, cy) color:@"blue" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx-r2, cy) color:@"blue" maxLinks:1];

	[Anchor addWithPos:CGPointMake(cx, cy+r) color:@"pink" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx, cy+r2) color:@"pink" maxLinks:1];

	[Anchor addWithPos:CGPointMake(cx, cy-r) color:@"white" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx, cy-r2) color:@"white" maxLinks:1];

	// player
	k.player.pos = CGPointMake(cx+r, cy-r);
}

@end
