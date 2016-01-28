#import "Level+Levels.h"

@implementation Level (level003)

- (void)setup_level003
{
	[k.world setBackground:@"nasirkhan01"];
	[k.sound loadTheme:@"industry"];
	k.lines.lineType = LineTypeBlack;

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// chains
	if (k.config.stage == 1) {
		[Chain addWithPos:CGPointMake(w*0.25, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(w*0.75, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx    , cy) color:@"orange"];
	} else if (k.config.stage == 3) {
		[Chain addWithPos:CGPointMake(w*0.15, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(w*0.85, cy) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx    , cy) color:@"orange"];
	}
	if (k.config.stage >= 2) {
		[Chain addWithPos:CGPointMake(w*1/4, cy-h*1/4) color:@"orange"];
		[Chain addWithPos:CGPointMake(w*3/4, cy-h*1/4) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx   , cy-h*1/4) color:@"orange"];
		[Chain addWithPos:CGPointMake(w*1/4, cy+h*1/4) color:@"orange"];
		[Chain addWithPos:CGPointMake(w*3/4, cy+h*1/4) color:@"orange"];
		[Chain addWithPos:CGPointMake(cx   , cy+h*1/4) color:@"orange"];
	}
/*
 # chains
 if k.config.stage == 1:
 chains = [(w*1/4, cy), (w*3/4, cy), (cx, cy)]
 elif k.config.stage == 2:
 chains = [(w*1/4, cy-h*1/4), (w*3/4, cy-h*1/4), (cx, cy-h*1/4), (w*1/4, cy+h*1/4), (w*3/4, cy+h*1/4), (cx, cy+h*1/4)]
 else:
 chains = [(w*1/4, cy), (w*3/4, cy), (cx, cy), (w*1/4, cy-h*1/4), (w*3/4, cy-h*1/4), (cx, cy-h*1/4), (w*1/4, cy+h*1/4), (w*3/4, cy+h*1/4), (cx, cy+h*1/4)]
 
 
 for i in range(len(chains)):
 k.particles.add(Chain({'pos': chains[i], 'color': 'orange'}))
 
 # anchors
 dx = 35+k.config.stage*35
 anchor = [(cx-dx, cy),
 (cx+dx, cy)]
 for i in range(len(anchor)):
 k.particles.add(Anchor({'pos':anchor[i], 'color': 'orange', 'maxLinks': 1}))
 
 # stones
 if k.config.stage >= 2:
 num = (k.config.stage-1)*2
 k.particles.stoneCircle((cx-dx, cy), 'orange', num, 70)
 k.particles.stoneCircle((cx+dx, cy), 'orange', num, 70)
 
 # simple player
 k.player.setPos((cx, h*2/3))
*/
	// anchors
	CGFloat dx = 50*k.displayScaleFactor*(1 + k.config.stage);
	[Anchor addWithPos:CGPointMake(cx-dx, cy) color:@"orange" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx+dx, cy) color:@"orange" maxLinks:1];

	// stones
	if (k.config.stage >= 2) {
		CGFloat r = 80*k.displayScaleFactor;
		NSInteger num = (k.config.stage-1)*2;
		[Particles stoneCircle:CGPointMake(cx-dx, cy) color:@"orange" num:num radius:r];
		[Particles stoneCircle:CGPointMake(cx+dx, cy) color:@"orange" num:num radius:r];
	}

	// player
	k.player.pos = CGPointMake(cx, h*2/3);
}

@end
