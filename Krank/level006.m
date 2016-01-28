#import "Level+Levels.h"

@implementation Level (level006)

- (void)setup_level006
{
	[k.world setBackground:@"tanakawho05"];
	[k.sound loadTheme:@"summer"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;
/*
    # particles
    num = k.config.stage>=2 and 4 or 2
    k.particles.ballCircle((cx, cy), 'white', num, h*0.32, -math.pi/2)
        
    # chains
    chains = [(  w/4,   h/4),
             (3*w/4,   h/4),
             (  w/4, 3*h/4),
             (3*w/4, 3*h/4)]
    
    if k.config.stage >= 2:
        c = k.config.stage == 2 and 4 or 12
        k.particles.chainCircle((cx, cy), 'white', c, 120, -math.pi/2)
    
    for i in range(len(chains)):
        k.particles.add(Chain({'pos': chains[i], 'color': 'white'}))
    
    # magnets 
    k.particles.add (Magnet({'pos': (cx, cy), 'color': 'white',  'num': num}))
    
    # anchors
    xd, yd = 70, 70
    anchor = [(cx-xd, cy), (cx+xd, cy)]
    if k.config.stage >= 2:
        anchor.extend([(cx, cy-yd), (cx, cy+yd)])
    for i in range(len(anchor)):
        k.particles.add(Anchor({'pos':anchor[i], 'color': 'white', 'maxLinks': k.config.stage}))
        
    if k.config.stage >= 3:
        k.particles.add(Anchor({'pos':(cx-170, cy),   'color': 'white', 'maxLinks': 1}))
        k.particles.add(Anchor({'pos':(cx+170, cy), 'color': 'white', 'maxLinks': 1}))
*/
	// magnets
	NSInteger num = k.config.stage>=2 ? 4 : 2;
	[Magnet addWithPos:CGPointMake(cx, cy) color:@"white" num:num];

	// particles
//	[Particle addWithPos:CGPointMake(cx, cy - h*0.32) color:@"white"];
//	[Particle addWithPos:CGPointMake(cx, cy + h*0.32) color:@"white"];
//	if (k.config.stage >= 2) {
//		[Particle addWithPos:CGPointMake(cx - w*0.25, cy) color:@"white"];
//		[Particle addWithPos:CGPointMake(cx + w*0.25, cy) color:@"white"];
//	}
	CGFloat dy = 80*k.displayScaleFactor;
	CGFloat r = 4*dy;//300*k.displayScaleFactor;
	[Particles ballCircle:CGPointMake(cx, cy) color:@"white" num:num radius:r start:-M_PI/2];

	// anchors
	[Anchor addWithPos:CGPointMake(cx - dy, cy) color:@"white" maxLinks:k.config.stage];
	[Anchor addWithPos:CGPointMake(cx + dy, cy) color:@"white" maxLinks:k.config.stage];
	if (k.config.stage >= 2) {
		[Anchor addWithPos:CGPointMake(cx, cy - dy) color:@"white" maxLinks:k.config.stage];
		[Anchor addWithPos:CGPointMake(cx, cy + dy) color:@"white" maxLinks:k.config.stage];
	}
	if (k.config.stage == 3) {
		CGFloat dx = dy*3;//230*k.displayScaleFactor;
		[Anchor addWithPos:CGPointMake(cx - dx, cy) color:@"white" maxLinks:1];
		[Anchor addWithPos:CGPointMake(cx + dx, cy) color:@"white" maxLinks:1];
	}
	
	// chains (4 at flower spiral ends)
	[Chain addWithPos:CGPointMake(w*0.275, h*0.254) color:@"white"];
	[Chain addWithPos:CGPointMake(w*0.725, h*0.254) color:@"white"];
	[Chain addWithPos:CGPointMake(w*0.275, h*0.746) color:@"white"];
	[Chain addWithPos:CGPointMake(w*0.725, h*0.746) color:@"white"];

	if (k.config.stage >= 2) {
		const int c = k.config.stage == 2 ? 4 : 12;
		[Particles chainCircle:CGPointMake(cx, cy) color:@"white" num:c radius:dy*2 start:-M_PI/2];
	}

	// player
	k.player.pos = CGPointMake(w*0.6, h*0.9);
}

@end
