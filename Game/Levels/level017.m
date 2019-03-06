#import "Level+Levels.h"

@implementation Level (level017)

- (void)setup_level017
{
	[k.world setBackground:@"somadjinn02"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, cy) color:@"orange"];

	// chains
	CGFloat r_array[] = { 75, 130, 205 }; //{ h/7.5, h/4, h/2.8 };
	CGFloat r1 = r_array[k.config.stage-1]*k.displayScaleFactor;
	NSInteger anchors_array[] = { 4, 8, 6 };
	NSInteger numAnchors = anchors_array[k.config.stage-1];

	[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:numAnchors*2 radius:r1+h/10];

	// anchors
	for (NSInteger i = 0; i < numAnchors; ++i) {
		CGPoint pos = CGPointAdd(CGPointMake(cx, cy), CGPointWithAngle(i*2*M_PI/numAnchors, r1));
		[Anchor addWithPos:pos color:@"white" maxLinks:2];
	}

/*
    k.particles.add(Particle({'pos': (cx, cy), 'color': 'orange'}))

    r1 = [75, 130, 205][k.config.stage-1]
    num_anchors = [4, 8, 6][k.config.stage-1]

    k.particles.chainCircle((cx, cy), 'white', num_anchors*2, r1+60)

    for i in range(num_anchors):
        pos = vector((cx, cy)) + vector.withAngle(i*2*math.pi/num_anchors, r1)
        k.particles.add(Anchor({'pos': pos, 'color': 'white', 'maxLinks': 2}))
        
    if k.config.stage == 3:
        r2 = 145
        for i in range(6):
            pos = vector((cx, cy)) + vector.withAngle(i*2*math.pi/num_anchors-math.pi/6, r2)
            k.particles.add(Anchor({'pos': pos, 'color': 'white', 'maxLinks': 2}))
        k.particles.chainCircle((cx, cy), 'white', 6, r2)
        k.particles.chainCircle((cx, cy), 'white', 6, r1, -math.pi/6)
    
    # simple player
    o = r1+(k.config.stage<3 and 60)
    k.player.setPos((cx+o, cy+o))
*/
	if (k.config.stage == 3) {
		CGFloat r2 = 145*k.displayScaleFactor; //h/4.1;
		for (int i = 0; i < 6; ++i) {
			CGPoint pos = CGPointAdd(CGPointMake(cx, cy), CGPointWithAngle((i*2*M_PI/numAnchors - M_PI/6), r2));
			[Anchor addWithPos:pos color:@"white" maxLinks:2];
		}
		[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:6 radius:r2];
		[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:6 radius:r1 start:-M_PI/6];
	}

	// player
	CGFloat d = r1+(k.config.stage<3 ? h/10 : 0);
	k.player.pos = CGPointMake(cx+d, cy+d);
}

@end
