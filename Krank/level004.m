#import "Level+Levels.h"

@implementation Level (level004)

- (void)setup_level004
{
	[k.world setBackground:@"Big-E-Mr-G02"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;
/*
 # chains
 chains = [(w/2, h*1/5),
 (w/2, h*4/5),
 (w*1/4, h*1/4),
 (w*1/4, h*3/4),
 (w*3/4, h*1/4),
 (w*3/4, h*3/4)]
 
 for i in range(len(chains)):
 k.particles.add(Chain({'pos': chains[i], 'color': 'white'}))
 
 # anchors
 dy = 100
 anchor = [(cx, cy-dy), (cx, cy+dy)]
 for i in range(len(anchor)):
 k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': 1}))
 
 # stones
 if k.config.stage >= 2:
 num = k.config.stage == 2 and 10 or 16
 for i in range(num):
 pos = (cx-num*14+(i+0.5)*28, cy)
 k.particles.add(Stone({'pos': pos, 'color': 'white'}))
 
 # simple player
 k.player.setPos((cx+(k.config.stage>1 and dy), cy++(k.config.stage>1 and dy)))
*/
	// chains
	[Chain addWithPos:CGPointMake(cx, h*0.205) color:@"white"];
	[Chain addWithPos:CGPointMake(cx, h*0.795) color:@"white"];
	[Chain addWithPos:CGPointMake(w*1/4, h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(w*1/4, h*3/4) color:@"white"];
	[Chain addWithPos:CGPointMake(w*3/4, h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(w*3/4, h*3/4) color:@"white"];

	// anchors
	CGFloat dy = 120*k.displayScaleFactor;
	[Anchor addWithPos:CGPointMake(cx, cy-dy) color:@"white" maxLinks:1];
	[Anchor addWithPos:CGPointMake(cx, cy+dy) color:@"white" maxLinks:1];

	// stones
	if (k.config.stage >= 2) {
		int num = k.config.stage == 2 ? 8 : 14;
		// Find stone width by using a template stone that is not added to the scene.
		Stone *templateStone = [[Stone alloc] initWithPos:CGPointZero color:@"white"];
		CGFloat dx = templateStone.size.width;
		for (int i = 0; i < num; ++i)
			[Stone addWithPos:CGPointMake(cx-num*dx/2+(i+0.5)*dx, cy) color:@"white"];
	}

	// player
	k.player.pos = CGPointMake((cx + (k.config.stage > 1 ? dy : 0)), (cy + (k.config.stage > 1 ? dy : 0)));
}

@end
