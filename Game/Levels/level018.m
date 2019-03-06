#import "Level+Levels.h"

@implementation Level (level018)

- (void)setup_level018
{
	[k.world setBackground:@"nasirkhan03"];
	[k.sound loadTheme:@"water"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, cy) color:@"orange"];

	CGPoint outerRadius = CGPointMake(w/2.8, h/2.3);
	CGPoint innerRadius = CGPointMake(w/3.55, h/3.15);

	if (k.config.stage == 1) {
		innerRadius = CGPointMake(w/3.2, h/2.7);
	} else if (k.config.stage == 2) {
		outerRadius = CGPointMake(w/3.0, h/2.4);
		innerRadius = CGPointMake(w/4.1, h/3.4);
	}
	CGPoint radBlue = k.config.stage == 2 ? outerRadius : innerRadius;

	// chains
	[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:5 xRadius:innerRadius.x yRadius:innerRadius.y start:-M_PI/2];
	[Particles chainCircle:CGPointMake(cx, cy) color:@"blue" num:5 xRadius:radBlue.x yRadius:radBlue.y start:M_PI/2];

	if (k.config.stage > 1) {
		[Particles chainCircle:CGPointMake(cx, cy) color:@"pink" num:5 xRadius:outerRadius.x yRadius:outerRadius.y start:-M_PI/2];
	}
	if (k.config.stage > 2) {
		[Particles chainCircle:CGPointMake(cx, cy) color:@"orange" num:5 xRadius:outerRadius.x yRadius:outerRadius.y start:M_PI/2];
	}
/*
    k.particles.add(Particle({'pos': (cx, cy), 'color': 'orange'}))

    xd = k.config.stage == 2 and 50
    rd = k.config.stage == 2 and 80
    
    # chains
    k.particles.chainCircle((cx, cy), 'white', 5, 170,   -math.pi/2)
    k.particles.chainCircle((cx, cy), 'blue',  5, 170+rd, math.pi/2)

    if k.config.stage > 1:
        k.particles.chainCircle((cx, cy), 'pink',   5, 250, -math.pi/2)
    if k.config.stage > 2:
        k.particles.chainCircle((cx, cy), 'orange', 5, 250,  math.pi/2)
        
    # anchors
    anchor = [(cx+xd-50, cy-100), (cx+xd-50, cy+100)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': 1}))

    anchor = [(cx+xd+50, cy-100), (cx+xd+50, cy+100)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': 1}))
        
    if k.config.stage > 1:
        anchor = [(cx+xd-150, cy-100), (cx+xd-150, cy+100)]
        for i in range(len(anchor)):
            k.particles.add(Anchor({'pos':anchor[i], 'color': 'pink', 'maxLinks': 1}))
    
    if k.config.stage > 2:
        anchor = [(cx+150, cy-100), (cx+150, cy+100)]
        for i in range(len(anchor)):
            k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': 1}))
        
    # simple player
    k.player.setPos((cx+100,cy))
*/
	// anchors
	CGFloat dxx = w/16, dx = k.config.stage == 2 ? dxx : 0;
	CGFloat dy = 100*k.displayScaleFactor;
	[Anchor addWithPos:CGPointMake(cx+dx-dxx, cy-dy) color:@"white" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx+dx-dxx, cy+dy) color:@"white" maxLinks:1];

	[Anchor addWithPos:CGPointMake(cx+dx+dxx, cy-dy) color:@"blue" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx+dx+dxx, cy+dy) color:@"blue" maxLinks:1];

	if (k.config.stage > 1) {
		[Anchor addWithPos:CGPointMake(cx+dx-dxx*3, cy-dy) color:@"pink" maxLinks:1];
		[Anchor addWithPos:CGPointMake(cx+dx-dxx*3, cy+dy) color:@"pink" maxLinks:1];
	}

	if (k.config.stage > 2) {
		[Anchor addWithPos:CGPointMake(cx+dx+dxx*3, cy-dy) color:@"orange" maxLinks:1];
		[Anchor addWithPos:CGPointMake(cx+dx+dxx*3, cy+dy) color:@"orange" maxLinks:1];
	}

	// player
	k.player.pos = CGPointMake(cx+h/6, cy);
}

@end
