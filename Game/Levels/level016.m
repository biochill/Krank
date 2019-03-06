#import "Level+Levels.h"

@implementation Level (level016)

- (void)setup_level016
{
	[k.world setBackground:@"OzBandit01"];
	[k.sound loadTheme:@"water"];

	CGFloat cx = k.world.center.x, cy = k.world.center.y, w = k.world.rect.size.width, h = k.world.rect.size.height;
/*
    num = k.config.stage+2
    
    # particles    
    k.particles.ballCircle((cx, cy), 'blue',  num, w*0.25,  k.config.stage%2 and  math.pi/2)
    k.particles.ballCircle((cx, cy), 'white', num, w*0.17, k.config.stage%2 and -math.pi/2)
    
    # magnets 
    k.particles.add (Magnet({'pos': (  w/4,   h/4), 'color': 'white', 'num': num}))
    k.particles.add (Magnet({'pos': (3*w/4,   h/4), 'color': 'blue',  'num': num}))
    k.particles.add (Magnet({'pos': (  w/4, 3*h/4), 'color': 'blue',  'num': num}))    
    k.particles.add (Magnet({'pos': (3*w/4, 3*h/4), 'color': 'white', 'num': num}))

    # simple player
    yd = [0, -h/12, 0][k.config.stage-1]
    k.player.setPos((w/2, cy+yd))
*/
	// particles
	NSInteger num = k.config.stage + 2;
	// ball circles have different radiuses than in Python, otherwise it wouldn't work with tv
	[Particles ballCircle:CGPointMake(cx, cy) color:@"blue" num:num radius:h*0.28 start:(k.config.stage%2 ? M_PI/2 : 0)];
	[Particles ballCircle:CGPointMake(cx, cy) color:@"white" num:num radius:h*0.2 start:(k.config.stage%2 ? -M_PI/2 : 0)];

	// magnets
	[Magnet addWithPos:CGPointMake(w*0.25, h*0.274) color:@"white" num:num];
	[Magnet addWithPos:CGPointMake(w*0.75, h*0.274) color:@"blue" num:num];
	[Magnet addWithPos:CGPointMake(w*0.25, h*0.726) color:@"blue" num:num];
	[Magnet addWithPos:CGPointMake(w*0.75, h*0.726) color:@"white" num:num];

	// player
	CGFloat dy = k.config.stage == 2 ? -h/12 : 0;
	k.player.pos = CGPointMake(w/2, cy+dy);
}

@end
