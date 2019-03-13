#import "Level+Levels.h"

@implementation Level (Menu)

- (void)setup_menu
{
	[k.world setBackground:@"LaunchImageCopy" alpha:0.85 wantQuadImage:NO];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"space";

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

#if TARGET_OS_TV
	CGFloat lowerY = h*0.75;
	CGFloat upperY = h*0.25;
#else
	CGFloat lowerY = h*0.75;
	CGFloat upperY = h*0.25;
#endif

	Switch *playNode = [Switch switchWithText:NSLocalizedString(@"Play", nil) anchor:ANCHOR_TOP | ANCHOR_CENTER command:@"play" position:CGPointMake(cx, upperY)];
	[k.particles addParticle:playNode];
	k.viewController.scene.preferredInitialFocusNode = playNode;

    [k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Help", nil) anchor:ANCHOR_BOTTOM command:@"%menu_help" position:CGPointMake(w*0.25, lowerY)]];

    [k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Options", nil) anchor:ANCHOR_BOTTOM command:@"%menu_options" position:CGPointMake(cx, lowerY)]];
    
	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Credits", nil) anchor:ANCHOR_BOTTOM command:@"%menu_credits" position:CGPointMake(w*0.75, lowerY)]];

	k.player.pos = CGPointMake(w*0.6, h*0.25);
	k.player.tailnum = 2;
}

@end
