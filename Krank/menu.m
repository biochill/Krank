#import "Level+Levels.h"

@implementation Level (Menu)

- (void)setup_menu
{
	[k.world setBackground:@"kahanaboy01" alpha:0.7];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"space";

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Play", nil) anchor:ANCHOR_TOP | ANCHOR_CENTER command:@"play"
                                           position:CGPointMake(cx, h*0.3)]];

//	[k.particles addParticle:[Switch switchWithText:@"Sound" anchor:ANCHOR_LEFT command:@"%menu_sound"
//                                           position:CGPointMake(1*width/4, 1*height/2)]];

	CGFloat y = h*0.7;
    [k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Help", nil) anchor:ANCHOR_BOTTOM command:@"%menu_help" position:CGPointMake(w*0.25, y)]];

//    [k.particles addParticle:[Switch switchWithText:@"Scores" anchor:ANCHOR_TOP command:@"%menu_scores"
//                                           position:CGPointMake(2*width/3, 1*height/3)]];

    [k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Options", nil) anchor:ANCHOR_BOTTOM command:@"%menu_options" position:CGPointMake(cx, y)]];
    
	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Credits", nil) anchor:ANCHOR_BOTTOM command:@"%menu_credits" position:CGPointMake(w*0.75, y)]];

	k.player.pos = k.world.center;
	k.player.tailnum = 2;
}

@end
