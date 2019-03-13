#import "Level+Levels.h"


@implementation Level (menu_levels)

- (void)setup_menu_levels
{
	[k.world setBackground:@"Sabby300001" alpha:0.8];
	[k.sound loadTheme:@"menu"];
	self.nextMusicName = @"summer";

	UIViewController *levelsViewController = [k.viewController.storyboard instantiateViewControllerWithIdentifier:@"Levels"];
	[k.viewController addChildViewController:levelsViewController];
	[k.viewController.view insertSubview:levelsViewController.view aboveSubview:k.viewController.gameView];
	levelsViewController.view.frame = k.viewController.view.bounds;
	[levelsViewController didMoveToParentViewController:k.viewController];

	// No cursor
	k.player = nil;

/*

	CGFloat cx = k.world.center.x, w = k.world.rect.size.width, h = k.world.rect.size.height;

	NSInteger num = k.maxLevel;//min(k.numLevels, [k.config numAvailableLevels]);
	NSInteger max = num;
	num = min(10, num);
	int cols = 5;

	for (int i = 0; i < num; ++i) {
		double row = floor((i%cols))+1.5, col = floor((i/cols))+0.8;

		[k.particles addParticle:[Switch switchWithText:[NSString stringWithFormat:@"%d", i+1]
			anchor:ANCHOR_BOTTOM
			command:[NSString stringWithFormat:@"startExit.%d", i+1]
			position:CGPointMake(row*w/(cols+2), col*h/4.7)
			font:k.smallFont
			imageName:[NSString stringWithFormat:@"level%03d", i+1]
			color:nil
			radius:-1
			]];
	}

	[self addBackButton:CGPointMake(cx-2*w/7, h*0.61)];

	CGFloat y = k.world.rect.size.height >= 1024 ? h*0.81 : h*0.79;

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Easy", nil)
		anchor:ANCHOR_BOTTOM
		command:@"stage.1"
		position:CGPointMake(cx-1*w/7, y)
		font:k.smallFont
		imageName:@"menu"
		color:k.config.stage==1 ? @"orange" : @"white"
		radius:-1
		]];

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Hard", nil)
		anchor:ANCHOR_BOTTOM
		command:@"stage.2"
		position:CGPointMake(cx, y)
		font:k.smallFont
		imageName:@"menu"
		color:k.config.stage==2 ? @"orange" : @"white"
		radius:-1
		]];

	[k.particles addParticle:[Switch switchWithText:NSLocalizedString(@"Extreme", nil)
		anchor:ANCHOR_BOTTOM
		command:@"stage.3"
		position:CGPointMake(cx+1*w/7, y)
		font:k.smallFont
		imageName:@"menu"
		color:k.config.stage==3 ? @"orange" : @"white"
		radius:-1
		]];

	if (max > 10) {
		[k.particles addParticle:[Switch switchWithText:@"Next 10"
			anchor:ANCHOR_BOTTOM
			command:@"%menu_levels2"
			position:CGPointMake(cx+2*w/7, h*0.61)
			font:k.smallFont
			]];
	}

	k.player.pos = CGPointMake(cx, h*0.61);
	[k.player setTailNum:k.config.stage*2 direction:-1];
*/
}

@end
