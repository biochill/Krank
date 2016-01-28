#import "Level+Levels.h"

@implementation Level (menu_help)

- (CGFloat)drawText:(NSString *)text pos:(CGPoint)pos
{
	CGFloat w = k.world.rect.size.width;

	CGRect rect = CGRectMake(pos.x, pos.y, w - 40 - pos.x, 0);
	SKNode *label = [Tools addLabelWithText:text rect:CGRectIntegral(rect) color:[UIColor whiteColor] anchor:ANCHOR_LEFT | ANCHOR_TOP font:k.helpFont];

	return CGRectGetHeight(label.frame);
}

- (CGFloat)drawIcon:(NSString *)iconName text:(NSString *)text pos:(CGPoint)pos iconAnchor:(NSInteger)iconAnchor
{
	CGFloat w = k.world.rect.size.width;

	CGRect rect = CGRectMake(pos.x, pos.y, w - 40 - pos.x, 0);
	SKNode *label = [Tools addLabelWithText:text rect:CGRectIntegral(rect) color:[UIColor whiteColor] anchor:ANCHOR_LEFT | ANCHOR_TOP font:k.helpFont];

	Sprite *icon = [[Sprite alloc] init];
	[icon setImageName:iconName];
	if (iconAnchor == ANCHOR_TOP) {
		// top centered (with other icons)
		icon.anchorPoint = CGPointMake(0.5, 1);
		icon.pos = CGPointMake(pos.x - 40*k.displayScaleFactor, pos.y);
	} else if (iconAnchor == ANCHOR_RIGHT) {
		// top right
		icon.anchorPoint = CGPointMake(1, 1);
		icon.pos = CGPointMake(pos.x - 10*k.displayScaleFactor, pos.y);
	} else {
		// Center: vertically centered with text, right-aligned
		icon.anchorPoint = CGPointMake(1, 0.5);
		icon.pos = CGPointMake(pos.x - 10*k.displayScaleFactor, pos.y + CGRectGetHeight(label.frame)/2);
	}
	[k.viewController.scene.level addChild:icon];

	return CGRectGetHeight(label.frame);
}

- (void)addBackButton:(CGPoint)position
{
	// No Back button for tv
#if !TARGET_OS_TV
	[k.particles addParticle:[Switch switchWithText:@"Back" anchor:ANCHOR_BOTTOM command:@"back" position:position font:k.smallFont]];
#endif
}

- (void)setup_menu_help
{
	[k.world setBackground:@"Magda Sobkowiak07" alpha:0.6];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"water";

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	[Tools addLabelWithText:NSLocalizedString(@"Help", nil) pos:CGPointMake(cx, h*3.0/28.0) color:[UIColor whiteColor] anchor:ANCHOR_CENTER font:k.largeFont];

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Overview", nil) anchor:ANCHOR_TOP command:@"%menu_help_overview" position:CGPointMake(1*w/2, 10*h/24) font:k.largeFont]];

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"The Goal", nil) anchor:ANCHOR_LEFT command:@"%menu_help_goal" position:CGPointMake(1*w/3, 7*h/12) font:k.largeFont]];

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Misc", nil) anchor:ANCHOR_RIGHT command:@"%menu_help_misc" position:CGPointMake(2*w/3, 7*h/12) font:k.largeFont]];

	k.player.pos = CGPointMake(cx, h*8/12);
	k.player.tailnum = 2;

	[self addBackButton:CGPointMake(cx, h*7/8)];
}
     
//------------------------------------------------------------------------------------------------------------------------

- (void)setup_menu_help_overview
{
	[k.world setBackground:@"Magda Sobkowiak01" alpha:0.55];

	CGFloat cx = k.world.center.x, h = k.world.rect.size.height, w = k.world.rect.size.width;

	CGFloat lh = h/28.0;
	[Tools addLabelWithText:NSLocalizedString(@"Help : Overview", nil) pos:CGPointMake(cx, lh*2.0) color:[UIColor whiteColor] anchor:ANCHOR_CENTER font:k.largeFont];

	CGPoint pos = CGPointMake(w*0.2, lh*4.5);
	pos.y += [self drawIcon:@"snake" text:NSLocalizedString(@"Snake1", nil) pos:pos iconAnchor:ANCHOR_TOP];
#if TARGET_OS_TV
	pos.y += lh;
#else
	pos.y += [self drawText:NSLocalizedString(@"Snake2", nil) pos:pos];
#endif
	pos.y += lh;
	pos.y += [self drawIcon:@"dot28_blue"     text:NSLocalizedString(@"Balls", nil)   pos:pos iconAnchor:ANCHOR_TOP] + lh; // ball
	pos.y += [self drawIcon:@"dot28_d_orange" text:NSLocalizedString(@"Links", nil)   pos:pos iconAnchor:ANCHOR_TOP] + lh; // link/chain
	pos.y += [self drawIcon:@"magnet"         text:NSLocalizedString(@"Magnets", nil) pos:pos iconAnchor:ANCHOR_TOP] + lh;
	pos.y += [self drawIcon:@"anchor"         text:NSLocalizedString(@"Anchors", nil) pos:pos iconAnchor:ANCHOR_TOP] + lh;
	pos.y += [self drawIcon:@"dot28_s_white"  text:NSLocalizedString(@"Stones", nil)  pos:pos iconAnchor:ANCHOR_TOP]; // stone

	k.player.pos = CGPointMake(w*0.7, h*0.9);

	[self addBackButton:CGPointMake(cx, h*0.9)];
}

//------------------------------------------------------------------------------------------------------------------------

- (void)setup_menu_help_goal
{    
	[k.world setBackground:@"Big-E-Mr-G09" alpha:0.6];

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	CGFloat lh = h/28.0;
	[Tools addLabelWithText:NSLocalizedString(@"Help : The Goal", nil) pos:CGPointMake(cx, lh*2.0) color:[UIColor whiteColor] anchor:ANCHOR_CENTER font:k.largeFont];

	CGPoint pos = CGPointMake(w*0.18, lh*4.0);
	CGFloat listx = pos.x + 40*k.displayScaleFactor;
	pos.y += [self drawText:NSLocalizedString(@"Goal", nil) pos:pos] + lh*0.5;

	pos.y += [self drawIcon:@"magnet" text:NSLocalizedString(@"Magnet vanishes", nil) pos:pos iconAnchor:ANCHOR_CENTER] + lh*0.4;
	pos.y += [self drawIcon:@"dot28_blue" text:NSLocalizedString(@"Magnet vanishes 1", nil) pos:CGPointMake(listx, pos.y) iconAnchor:ANCHOR_RIGHT] + lh*0.1;
	pos.y += [self drawIcon:@"dot28_blue" text:NSLocalizedString(@"Magnet vanishes 2", nil) pos:CGPointMake(listx, pos.y) iconAnchor:ANCHOR_RIGHT] + lh*0.1;
	pos.y += [self drawIcon:@"dot28_blue" text:NSLocalizedString(@"Magnet vanishes 3", nil) pos:CGPointMake(listx, pos.y) iconAnchor:ANCHOR_RIGHT] + lh;

	pos.y += [self drawIcon:@"anchor" text:NSLocalizedString(@"Anchor vanishes", nil) pos:pos iconAnchor:ANCHOR_CENTER] + lh*0.4;
	pos.y += [self drawIcon:@"dot28_d_orange" text:NSLocalizedString(@"Anchor vanishes 1", nil) pos:CGPointMake(listx, pos.y) iconAnchor:ANCHOR_RIGHT] + lh*0.1;
	pos.y += [self drawIcon:@"dot28_d_orange" text:NSLocalizedString(@"Anchor vanishes 2", nil) pos:CGPointMake(listx, pos.y) iconAnchor:ANCHOR_RIGHT] + lh*0.1;
	pos.y += [self drawIcon:@"dot28_d_orange" text:NSLocalizedString(@"Anchor vanishes 3", nil) pos:CGPointMake(listx, pos.y) iconAnchor:ANCHOR_RIGHT] + lh;

	pos.y += [self drawText:NSLocalizedString(@"Goal Footnote", nil) pos:pos];

	k.player.pos = CGPointMake(w*0.7, h*0.9);

	[self addBackButton:CGPointMake(cx, h*0.9)];
}

//------------------------------------------------------------------------------------------------------------------------

- (void)setup_menu_help_misc
{
	[k.world setBackground:@"Big-E-Mr-G18" alpha:1];

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	CGFloat lh = h/28.0;
	[Tools addLabelWithText:NSLocalizedString(@"Help : Misc", nil) pos:CGPointMake(cx, lh*3.0) color:[UIColor whiteColor] anchor:ANCHOR_CENTER font:k.largeFont];

	NSArray *texts = @[
	   NSLocalizedString(@"Snake Captured", nil),
#if !TARGET_OS_TV
	   NSLocalizedString(@"Exit Level by Swiping", nil),
#endif
	   NSLocalizedString(@"Connection Broken", nil),
	   NSLocalizedString(@"Skip Levels", nil),
	   NSLocalizedString(@"Hard Stage", nil),
	   NSLocalizedString(@"Extreme Stage", nil),
	   NSLocalizedString(@"Game Controller Hint", nil)
	];

	CGPoint pos = CGPointMake(w*0.15, lh*5.0);
	NSInteger count = 0;
	for (NSString *text in texts) {
		pos.y += lh*1.0 + [self drawIcon:++count % 2 ? @"dot28_d_orange" : @"dot28_blue" text:text pos:pos iconAnchor:ANCHOR_TOP];
	}

	k.player.pos = CGPointMake(w*0.7, h*0.9);

	[self addBackButton:CGPointMake(cx, h*0.9)];
}


@end
