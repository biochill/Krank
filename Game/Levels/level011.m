#import "Level+Levels.h"

@implementation Level (level011)

- (void)setup_level011
{
	[k.world setBackground:@"IHP05"];
	[k.sound loadTheme:@"industry"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, /*w = k.world.rect.size.width,*/ h = k.world.rect.size.height;

/*
 k.particles.add(Particle({'pos': (cx, cy), 'color': 'white'}))
 
 # chains
 num = k.config.stage * 6
 k.particles.chainCircle((cx, cy), 'blue', num, 200)
 
 # anchors
 anchor = [(cx, cy-100),
 (cx, cy+100),
 (cx+100, cy),
 (cx-100, cy)]
 for i in range(len(anchor)):
 n = i < 2 and (k.config.stage == 3 and 3 or 1) or min(2, k.config.stage)
 k.particles.add(Anchor({'pos':anchor[i], 'color': 'blue', 'maxLinks': n}))
 
 # simple player
 k.player.setPos((cx+200,cy+150))
*/
	// particles
	[Particle addWithPos:CGPointMake(cx, cy) color:@"white"];

	// chains
	NSInteger num = k.config.stage * 6;
	[Particles chainCircle:CGPointMake(cx, cy) color:@"blue" num:num radius:h/3];

	// anchors
	num = ((k.config.stage == 3) ? 3 : 1);
	CGFloat dr = 100*k.displayScaleFactor;
	[Anchor addWithPos:CGPointMake(cx, cy-dr) color:@"blue" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx, cy+dr) color:@"blue" maxLinks:num];
	num = minl(2, k.config.stage);
	[Anchor addWithPos:CGPointMake(cx+dr, cy) color:@"blue" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-dr, cy) color:@"blue" maxLinks:num];

	// player
	k.player.pos = CGPointMake(cx+h*0.38, cy+h*0.25);
}

@end
