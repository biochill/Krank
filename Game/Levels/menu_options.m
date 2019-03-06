//
//  menu_options.m

#import "Level+Levels.h"
#import "Toggle.h"

@implementation Level (menu_options)

- (Toggle *)addToggle:(NSString*)text option:(NSString*)option pos:(CGPoint)pos anchor:(NSInteger)anchor
{
	Toggle *sw;
	sw = [[Toggle alloc] initWithText:NSLocalizedString(text, nil)
                         anchor:anchor
						option:option
                       position:pos
                           font:k.largeFont
                      imageName:@"menu"];
    sw.sound = YES;
    [k.particles addParticle:sw];
	return sw;
}

- (void)setup_menu_options
{
	[k.world setBackground:@"Magda Sobkowiak03" alpha:0.6];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"industry";

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[Tools addLabelWithText:NSLocalizedString(@"Options", nil) pos:CGPointMake(cx, h*0.15) color:[UIColor whiteColor] anchor:ANCHOR_CENTER font:k.largeFont];

#if TARGET_OS_TV

	// Apple TV build needs less options than iOS build.
	// These options are arranged to ensure that the focus engine can reach every button.

	[self addToggle:@"Display Target" option:kConfigTargetEnabled pos:CGPointMake(w*0.5, h*0.45) anchor:ANCHOR_TOP];
	[self addToggle:@"Sound" option:kConfigSoundFXEnabled pos:CGPointMake(w*0.25, h*0.55) anchor:ANCHOR_TOP];
	[self addToggle:@"Music" option:kConfigMusicEnabled pos:CGPointMake(w*0.75, h*0.55) anchor:ANCHOR_TOP];

#else

	[self addToggle:@"Motion" option:kConfigMotionEnabled pos:CGPointMake(w*0.15, h*0.3) anchor:ANCHOR_RIGHT];
	[self addToggle:@"Display Target" option:kConfigTargetEnabled pos:CGPointMake(w*0.15, h*0.5) anchor:ANCHOR_RIGHT];
	[self addToggle:@"Finger Offset" option:kConfigFingerOffsetEnabled pos:CGPointMake(w*0.15, h*0.7) anchor:ANCHOR_RIGHT];

	[self addToggle:@"Sound" option:kConfigSoundFXEnabled pos:CGPointMake(w*0.85, h*0.3) anchor:ANCHOR_LEFT];
	[self addToggle:@"Music" option:kConfigMusicEnabled pos:CGPointMake(w*0.85, h*0.5) anchor:ANCHOR_LEFT];

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Privacy Policy", nil) anchor:ANCHOR_LEFT command:@"privacy" position:CGPointMake(w*0.85, h*0.7) font:k.largeFont]];

#endif

	k.player.pos = CGPointMake(cx, h*0.55);
	k.player.tailnum = 2;

	[self addBackButton:CGPointMake(cx, h*7/8)];
}

@end
