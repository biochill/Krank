#import "Level+Levels.h"

@implementation Level (level029)

- (void)setup_level029
{
	[k.world setBackground:@"kahanaboy07"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx, cy) color:@"blue"];

	// chains
	int num_chains1[] = { 6, 12, 16 };
	[Particles chainCircle:CGPointMake(cx, cy) color:@"orange" num:num_chains1[k.config.stage-1] radius:h*0.42];

	int num_chains2[] = { 4, 8, 8 };
	[Particles chainCircle:CGPointMake(cx, cy) color:@"pink" num:num_chains2[k.config.stage-1] radius:h*0.32 start:-M_PI/8];
/*
    k.particles.add(Particle({'pos': (cx, cy), 'color': 'blue'}))
    
    # chains
    num = [6,12,16][k.config.stage-1]
    k.particles.chainCircle((cx, cy), 'orange', num, h*0.42)

    num = [4,8,8][k.config.stage-1]
    k.particles.chainCircle((cx, cy), 'pink', num, h*0.32, -math.pi/8)
        
    # anchors
    d = 120
    anchor = [(cx+d, cy),
              (cx, cy-d),
              (cx, cy+d),
              (cx-d, cy),
              (cx+d, cy+d),
              (cx-d, cy-d),
              (cx-d, cy+d),
              (cx+d, cy-d),]
    num_anchor = k.config.stage == 3 and 8 or 4
    for i in range(num_anchor):
        num = min(2, k.config.stage)
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': num}))

    d = 50
    anchor = [(cx-d, cy-d),
              (cx+d, cy-d),
              (cx+d, cy+d),
              (cx-d, cy+d), ]
    for i in range(len(anchor)):
        num = min(2, k.config.stage)
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'pink', 'maxLinks': num}))
        
    # simple player
    k.player.setPos((w*2/3,cy+h*0.42))
*/
	// anchors
	CGFloat d = h/5;
	NSInteger num = minl(2, k.config.stage);
	[Anchor addWithPos:CGPointMake(cx+d, cy  ) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx,   cy-d) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx,   cy+d) color:@"orange" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-d, cy  ) color:@"orange" maxLinks:num];
	if (k.config.stage >= 3) {
		[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"orange" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"orange" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"orange" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"orange" maxLinks:num];
	}

	d = h/12;
	[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"pink" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"pink" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"pink" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"pink" maxLinks:num];

	// player
	k.player.pos = CGPointMake(w*2/3, cy+h*0.42);
}

@end
