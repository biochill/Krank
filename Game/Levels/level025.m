#import "Level+Levels.h"

@implementation Level (level025)

- (void)setup_level025
{
	[k.world setBackground:@"Big-E-Mr-G18"];
	[k.sound loadTheme:@"water"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particles ballCircle:CGPointMake(cx, cy) color:@"orange" num:(k.config.stage == 1 ? 2 : 4) radius:h*0.32];

	// chains
	[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:(k.config.stage == 1 ? 8 : 16) radius:h*0.42];
	[Particles chainCircle:CGPointMake(cx, cy) color:@"blue" num:(k.config.stage >= 3 ? 12 : 4) radius:h*0.32 start:-M_PI/2-M_PI/4];
/*
    # particles
    num = [2,4,4][k.config.stage-1]
    k.particles.ballCircle((cx, cy), 'orange', num, h*0.32)
    
    # chains
    num = [8, 16, 16][k.config.stage-1]
    k.particles.chainCircle((cx, cy), 'white', num, h*0.42)

    num = [4, 4, 12][k.config.stage-1]
    k.particles.chainCircle((cx, cy), 'blue', num, h*0.32, -math.pi/2-math.pi/4)
        
    # anchors
    d = 120
    anchor = [(cx, cy-d),
              (cx+d, cy),
              (cx, cy+d),
              (cx-d, cy),]
    for i in range(len(anchor)):
        num = k.config.stage == 1 and 1 or 2
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': num}))

    d = 50
    anchor = [(cx, cy),
              (cx-d, cy-d),
              (cx+d, cy+d),
              (cx-d, cy+d), 
              (cx+d, cy-d),
              ]
    num_anchor = [3, 5, 5][k.config.stage-1]
    for i in range(num_anchor):
        num = i == 0 and (min(4, k.config.stage*2)) or [1,1,3][k.config.stage-1]
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': num}))
        
    # simple player
    k.player.setPos((cx+w*0.23,cy+h*0.38))
*/
	// anchors
	CGFloat d = 120*k.displayScaleFactor;
	NSInteger num = k.config.stage == 1 ? 1 : 2;
	[Anchor addWithPos:CGPointMake(cx  , cy-d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy)   color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx  , cy+d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-d, cy)   color:@"white" maxLinks:num];

	d = 50*k.displayScaleFactor;
	num = minl(4, k.config.stage*2);
	[Anchor addWithPos:CGPointMake(cx  , cy  ) color:@"blue" maxLinks:num];
	num = k.config.stage >= 3 ? 3 : 1;
	[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"blue" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"blue" maxLinks:num];
	if (k.config.stage >= 2) {
		[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"blue" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"blue" maxLinks:num];
	}

	// player
	k.player.pos = CGPointMake(cx+w*0.23, cy+h*0.38);
}

@end
