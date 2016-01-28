#import "Level+Levels.h"

@implementation Level (menu_credits)

- (void)drawCreditsEntry:(NSString *)text pos:(CGPoint)pos
{
	[Tools addLabelWithText:text pos:pos color:[UIColor darkGrayColor] anchor:ANCHOR_CENTER font:k.normalFont];
}

- (void)drawCreditsSection:(NSString*)text pos:(CGPoint)pos
{
	[Tools addLabelWithText:text pos:pos color:[UIColor blackColor] anchor:ANCHOR_CENTER font:k.largeFont];
}

- (void)setup_menu_credits
{
	[k.world setBackground:@"IHP08"];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"water";

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	if (version) {
		NSString *vString = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Version", nil), version];
		[Tools addLabelWithText:vString pos:CGPointMake(cx, h*0.05) color:[UIColor blackColor] anchor:ANCHOR_CENTER font:k.tinyFont];
	}

	CGFloat y = h*0.185;

	[self drawCreditsSection:NSLocalizedString(@"Code", nil) pos:CGPointMake(cx, y)];

	y += h*0.06;

	[self drawCreditsEntry:@"monsterkodi & biochill" pos:CGPointMake(cx, y)];

	y += h*0.07;

	[self drawCreditsSection:NSLocalizedString(@"Sound (Credits)", nil) pos:CGPointMake(cx, y)];

	y += h*0.06;

	[self drawCreditsEntry:@"legoluft" pos:CGPointMake(cx, y)];

	y += h*0.07;    

	[self drawCreditsSection:NSLocalizedString(@"Images", nil) pos:CGPointMake(cx, y)];

	y += h*0.06;    

	NSString *images_left[] = { @"Big-E-Mr-G", @"*GaryP*", @"kahanaboy", @"OzBandit", @"somadjinn" };

	for (int i = 0; i < sizeof(images_left) / sizeof(NSString *); ++i)
		[self drawCreditsEntry:images_left[i] pos:CGPointMake(cx - w/11, y + i*h*0.045)];

	NSString *images_right[] = { @"darkmatter", @"IHP", @"nasirkhan", @"Sabby3000", @"tanakawho" };

	for (int i = 0; i < sizeof(images_right) / sizeof(NSString*); ++i) 
		[self drawCreditsEntry:images_right[i] pos:CGPointMake(cx + w/11, y + i*h*0.045)];

	y += 5*h*0.045;

	[self drawCreditsEntry:@"Magda Sobkowiak" pos:CGPointMake(cx, y)];

	y += h*0.07;

	[self drawCreditsEntry:NSLocalizedString(@"Font by Nick Curtis", nil) pos:CGPointMake(cx, y)];

	k.player.pos = CGPointMake(w*0.6, h*0.875);
	k.player.tailnum = 2;

	[self addBackButton:CGPointMake(cx, h*7/8)];
}

@end
