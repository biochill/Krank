#import "Level+Levels.h"

@implementation Level (Menu)

- (void)setup_menu
{
	[k.world setBackground:@"LaunchImageCopy" alpha:0.85 wantQuadImage:NO];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"space";

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Play", nil) anchor:ANCHOR_TOP | ANCHOR_CENTER command:@"play" position:CGPointMake(cx, h*0.25)]];

	CGFloat y = h*0.75;
    [k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Help", nil) anchor:ANCHOR_BOTTOM command:@"%menu_help" position:CGPointMake(w*0.25, y)]];

    [k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Options", nil) anchor:ANCHOR_BOTTOM command:@"%menu_options" position:CGPointMake(cx, y)]];
    
	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Credits", nil) anchor:ANCHOR_BOTTOM command:@"%menu_credits" position:CGPointMake(w*0.75, y)]];

	k.player.pos = CGPointMake(w*0.6, h*0.25);
	k.player.tailnum = 2;
}

@end
