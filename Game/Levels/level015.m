#import "Level+Levels.h"

@implementation Level (level015)

- (void)setup_level015
{
	[k.world setBackground:@"kahanaboy06"];
	[k.sound loadTheme:@"industry"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particles ballCircle:CGPointMake(cx, cy) color:@"orange" num:k.config.stage*2 radius:h/3 start:-M_PI/2];

	// chains
	if (k.config.stage == 1) {
		[Particles chainCircle:CGPointMake(cx, cy) color:@"orange" num:4 radius:h/2.4];
		[Chain addWithPos:CGPointMake(cx-w*0.2, cy+h*0.1) color:@"blue"];
		[Chain addWithPos:CGPointMake(cx+w*0.2, cy-h*0.1) color:@"blue"];
		[Chain addWithPos:CGPointMake(cx+w*0.2, cy+h*0.1) color:@"blue"];
		[Chain addWithPos:CGPointMake(cx-w*0.2, cy-h*0.1) color:@"blue"];
	} else {
		NSInteger c = k.config.stage == 2 ? 6 : 15;
		[Particles chainCircle:CGPointMake(cx, cy) color:@"orange" num:c radius:h/2.2];
		double start = k.config.stage == 2 ? -M_PI/2 : -M_PI/15;
		[Particles chainCircle:CGPointMake(cx, cy) color:@"blue" num:c radius:h/2.2 start:start];
	}
/*
    # particles
    k.particles.ballCircle((cx, cy), 'orange', k.config.stage * 2, 200, -math.pi/2)
        
    # chains
    if k.config.stage == 1:
        k.particles.chainCircle((cx, cy), 'orange', 4, 250)
    
        chains = [( cx-w*0.2, cy+h*0.1 ), ( cx+w*0.2, cy-h*0.1 ), ( cx+w*0.2, cy+h*0.1 ), ( cx-w*0.2, cy-h*0.1 )]
        
        for i in range(len(chains)):
            k.particles.add(Chain({'pos': chains[i], 'color': 'blue'}))
    else:
        c = k.config.stage==2 and 6 or 15
        k.particles.chainCircle((cx, cy), 'orange', c, 280)
        k.particles.chainCircle((cx, cy), 'blue',   c, 280, k.config.stage == 2 and -math.pi/2 or -math.pi/15)
    
    # magnets 
    k.particles.add (Magnet({'pos': (cx, cy), 'color': 'orange',  'num': min(6, k.config.stage*2)}))
        
    # anchors
    yd = 60
    anchor = [(cx-70, cy-yd), (cx-70, cy+yd), (cx-140, cy), (cx-220, cy)]
    for i in range(min(len(anchor), k.config.stage+1)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': k.config.stage}))

    anchor = [(cx+70, cy-yd), (cx+70, cy+yd), (cx+140, cy), (cx+220, cy)]
    for i in range(min(len(anchor), k.config.stage+1)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': k.config.stage}))
        
    # player
    k.player.setPos((cx, cy+145))
*/
	// magnets
	[Magnet addWithPos:CGPointMake(cx, cy) color:@"orange" num:minl(6, k.config.stage*2)];

	// anchors
	CGFloat dy = 60*k.displayScaleFactor, dx = 70*k.displayScaleFactor; //h/8.5;
	[Anchor addWithPos:CGPointMake(cx-dx, cy-dy) color:@"blue" maxLinks:k.config.stage];
	[Anchor addWithPos:CGPointMake(cx-dx, cy+dy) color:@"blue" maxLinks:k.config.stage];
	[Anchor addWithPos:CGPointMake(cx+dx, cy-dy) color:@"orange" maxLinks:k.config.stage];
	[Anchor addWithPos:CGPointMake(cx+dx, cy+dy) color:@"orange" maxLinks:k.config.stage];
	if (k.config.stage >= 2) {
		[Anchor addWithPos:CGPointMake(cx-dx*2, cy) color:@"blue" maxLinks:k.config.stage];
		[Anchor addWithPos:CGPointMake(cx+dx*2, cy) color:@"orange" maxLinks:k.config.stage];
	}
	if (k.config.stage >= 3) {
		[Anchor addWithPos:CGPointMake(cx-dx*3, cy) color:@"blue" maxLinks:k.config.stage];
		[Anchor addWithPos:CGPointMake(cx+dx*3, cy) color:@"orange" maxLinks:k.config.stage];
	}

	// player
	k.player.pos = CGPointMake(cx, cy+h/5.3);
}

@end
