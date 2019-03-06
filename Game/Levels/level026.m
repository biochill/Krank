#import "Level+Levels.h"

@implementation Level (level026)

- (void)setup_level026
{
	[k.world setBackground:@"kahanaboy05"];
	[k.sound loadTheme:@"space"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;

	// particles
	[Particle addWithPos:CGPointMake(cx-w*2/6, cy+h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx-w*2/6, cy-h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx+w*2/6, cy+h*2/6) color:@"blue"];
	[Particle addWithPos:CGPointMake(cx+w*2/6, cy-h*2/6) color:@"blue"];
/*
    # particles
    parts  = [(cx-w*2/6,  cy+h*2/6),
              (cx-w*2/6,  cy-h*2/6),
              (cx+w*2/6,  cy+h*2/6),
              (cx+w*2/6,  cy-h*2/6),]
    
    for part in parts:
        k.particles.add(Particle({'pos': part, 'color': 'blue'}))
*/
	// chains
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/8, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/8, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/8, cy-h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/8, cy+h*1/4) color:@"white"];
	[Chain addWithPos:CGPointMake(cx      , cy-h*2/6) color:@"white"];
	[Chain addWithPos:CGPointMake(cx      , cy+h*2/6) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*1/8) color:@"white"];
	[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*1/8) color:@"white"];
	if (k.config.stage >= 2) {
		[Chain addWithPos:CGPointMake(cx-w*1/4, cy)       color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*1/4, cy)       color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*2/6, cy)       color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*2/6, cy)       color:@"white"];
		[Chain addWithPos:CGPointMake(cx      , cy-h*1/4) color:@"white"];
		[Chain addWithPos:CGPointMake(cx      , cy+h*1/4) color:@"white"];
	}
	if (k.config.stage >= 3) {
		[Chain addWithPos:CGPointMake(cx+w*1/4, cy-h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*1/4, cy+h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*1/8, cy-h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx+w*1/8, cy+h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*1/4, cy-h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*1/4, cy+h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*1/8, cy-h*2/6) color:@"white"];
		[Chain addWithPos:CGPointMake(cx-w*1/8, cy+h*2/6) color:@"white"];
	}
/*
    # chains
    chains = [(cx-w*1/4, cy-h*1/4),
              (cx-w*1/4, cy+h*1/4),              
              (cx+w*1/4, cy-h*1/4),
              (cx+w*1/4, cy+h*1/4),
              (cx-w*1/8, cy-h*1/4),
              (cx-w*1/8, cy+h*1/4),              
              (cx+w*1/8, cy-h*1/4),
              (cx+w*1/8, cy+h*1/4),
              (cx,       cy-h*2/6),
              (cx,       cy+h*2/6),
              (cx-w*1/4, cy-h*1/8),
              (cx-w*1/4, cy+h*1/8),              
              (cx+w*1/4, cy-h*1/8),
              (cx+w*1/4, cy+h*1/8),
              (cx-w*1/4, cy),
              (cx+w*1/4, cy),
              (cx-w*2/6, cy),
              (cx+w*2/6, cy),
              (cx, cy-h*1/4),
              (cx, cy+h*1/4),
              (cx+w*1/4, cy-h*2/6),
              (cx+w*1/4, cy+h*2/6),
              (cx+w*1/8, cy-h*2/6),
              (cx+w*1/8, cy+h*2/6),
              (cx-w*1/4, cy-h*2/6),
              (cx-w*1/4, cy+h*2/6),
              (cx-w*1/8, cy-h*2/6),
              (cx-w*1/8, cy+h*2/6)]
    
    num_chains = [14, 20, 28][k.config.stage-1]
    for i in range(num_chains):
        k.particles.add(Chain({'pos': chains[i], 'color': 'white'}))
        
    d = 80
    anchor = [(cx, cy),
              (cx-d, cy-d),
              (cx-d, cy+d), 
              (cx+d, cy-d),
              (cx+d, cy+d),
              (cx-2*d, cy),
              (cx+2*d, cy),]
    num_anchor = k.config.stage == 3 and 7 or 5
    for i in range(num_anchor):
        num = i == 0 and 4 or (i > 4 and 2 or [2, 3, 4][k.config.stage-1])
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': num}))
        
    # simple player
    k.player.setPos((w*2/3,cy+h*0.42))
*/
	// anchors
	CGFloat d = 80*k.displayScaleFactor;
	NSInteger num = 4;
	[Anchor addWithPos:CGPointMake(cx, cy) color:@"white" maxLinks:num];
	num = k.config.stage+1;
	[Anchor addWithPos:CGPointMake(cx-d, cy-d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx-d, cy+d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy-d) color:@"white" maxLinks:num];
	[Anchor addWithPos:CGPointMake(cx+d, cy+d) color:@"white" maxLinks:num];
	if (k.config.stage >= 3) {
		num = 2;
		[Anchor addWithPos:CGPointMake(cx-2*d, cy) color:@"white" maxLinks:num];
		[Anchor addWithPos:CGPointMake(cx+2*d, cy) color:@"white" maxLinks:num];
	}

	// player
	k.player.pos = CGPointMake(w*2/3, cy+h*0.42);
}

@end
