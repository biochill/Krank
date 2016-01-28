#import "Level+Levels.h"

@implementation Level (level013)

- (void)setup_level013
{
	[k.world setBackground:@"tanakawho02"];
	[k.sound loadTheme:@"industry"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, /*w = k.world.rect.size.width,*/ h = k.world.rect.size.height;

	// particles
	CGFloat dx = 170*k.displayScaleFactor; //h/4;
	NSInteger num = minl(6, 2+k.config.stage);
	[Particles ballCircle:CGPointMake(cx-dx, cy) color:@"blue" num:num radius:dx*0.85];
	[Particles ballCircle:CGPointMake(cx+dx, cy) color:@"white" num:num radius:dx*0.85 start:-M_PI];

	// magnets
	[Magnet addWithPos:CGPointMake(cx-dx, cy) color:@"white" num:num];
	[Magnet addWithPos:CGPointMake(cx+dx, cy) color:@"blue" num:num];

/*
    xd = 150
    # 6 white particles
    num = min(6, 2+k.config.stage)    
    k.particles.ballCircle((cx-xd, cy), 'blue', num, 120)
    k.particles.ballCircle((cx+xd, cy), 'white', num, 120, -math.pi)
    
    # 2 magnets 
    k.particles.add (Magnet({'pos': (cx-xd, cy), 'color': 'white', 'num': num}))
    k.particles.add (Magnet({'pos': (cx+xd, cy), 'color': 'blue', 'num': num}))

    # chains
    k.particles.chainCircle((cx, cy), 'white', 4, 100, -math.pi/4)
    
    # anchors
    anchor = [(cx-80, cy),
              (cx+80, cy)]
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': 1}))
        
    # simple player
    k.player.setPos((w/2, cy-3*h/16))
*/
	// chains
	[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:4 radius:dx*0.8 start:-M_PI/4];

	// anchors
	dx = 80*k.displayScaleFactor;
	[Anchor addWithPos:CGPointMake(cx - dx, cy) color:@"white" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx + dx, cy) color:@"white" maxLinks:1];

	// player
	k.player.pos = CGPointMake(cx, h*0.2);
}

@end
