//
//  LevelsViewController.m
//  Krank
//
//  Created by Sven Thoennissen on 30.11.15.
//
//

#import "LevelsViewController.h"
#import "LevelCollectionViewCell.h"
#import "Tools.h"
#import "Globals.h"
#import "UIColor_Custom.h"
#import "MenuButton.h"
//#import "Switch.h"
#import "CockpitLabel.h"

@interface LevelsViewController ()
@property (nonatomic) NSInteger highlightedLevel;
@end

@implementation LevelsViewController

// MARK: - Overrides

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor clearColor];

	self.highlightedLevel = 0;

	//
	// Configure buttons and help text
	//

	self.easyLabel.text = NSLocalizedString(@"Easy", nil);
	self.hardLabel.text = NSLocalizedString(@"Hard", nil);
	self.extremeLabel.text = NSLocalizedString(@"Extreme", nil);

	self.easyLabel.font = k.largeFont;
	self.hardLabel.font = k.largeFont;
	self.extremeLabel.font = k.largeFont;

	UIColor *gradient = [[UIColor whiteColor] verticalGradientPatternWithHeight:k.largeFont.lineHeight dimFactor:0.5];
	self.easyLabel.textColor = gradient;
	self.hardLabel.textColor = gradient;
	self.extremeLabel.textColor = gradient;

	[self updateButtons];
	[self updateHelpText];

	self.helpLabel.font = k.helpFont;
	self.helpLabel.textColor = [[UIColor whiteColor] verticalGradientPatternWithHeight:k.helpFont.lineHeight dimFactor:0.5];

	// Back label
	self.backLabel.text = NSLocalizedString(@"Back", nil);
	self.backLabel.textColor = [[UIColor whiteColor] verticalGradientPatternWithHeight:k.smallFont.lineHeight dimFactor:0.5];
	self.backLabel.font = k.smallFont;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	//
	// Scroll current level to visible before requesting focus update
	//
	NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:kConfigCurrentLevelNumber];
	// When switching between easy/hard/extreme, make sure a valid level is focused.
	NSInteger maxLevel = [k.config highestAvailableLevel];
	if (level > maxLevel) {
		level = maxLevel;
	}
#if TARGET_OS_TV
	[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:level - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
#else
	// Select works better than scroll on iOS (?)
	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:level - 1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

	// Make this cell visually stand out
	// -- Actually, do not make it stand out, in case the user plays the game without game controller.
	//	self.highlightedLevel = level;
#endif

	// The system sends a focus update before here, and since this would result in another "part" sound (see -collectionView:didUpdateFocus), we are trying to mute that sound and only play when we request the next update.
//	_playFocusSound = YES;
	[self setNeedsFocusUpdate];

	// Notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statChangedNotification:) name:KrankBestStatChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerButtonPressedNotification:) name:InputControllerButtonPressed object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self name:KrankBestStatChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:InputControllerButtonPressed object:nil];
}
/*
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	//
	// Set gradient color on buttons which depends on button height
	//

	// Stage buttons
	CGFloat height = CGRectGetHeight(self.easyLabel.frame);
	UIColor *textColor = [[UIColor whiteColor] verticalGradientColorWithHeight:height dimFactor:0.5];
	self.easyLabel.textColor = textColor;
	self.hardLabel.textColor = textColor;
	self.extremeLabel.textColor = textColor;

	// Back button
	if (self.backLabel) {
		height = CGRectGetHeight(self.backLabel.frame);
		textColor = [[UIColor whiteColor] verticalGradientColorWithHeight:height dimFactor:0.5];
		self.backLabel.textColor = textColor;
	}
	
	// Setup help text
	if (self.helpLabel.text) {
		// Use some sample text to determine height; do not use height of frame because it is larger than the text.
		height = ceil([@"Hard" sizeWithAttributes:@{NSFontAttributeName: self.helpLabel.font}].height);
		textColor = [[UIColor whiteColor] verticalGradientColorWithHeight:height dimFactor:0.7];
		self.helpLabel.textColor = textColor;
	}
}
*/

#pragma mark - Helpers

- (void)updateButtons
{
	UIImage *normalImage = [UIImage imageNamed:@"menu_white"];
	UIImage *selectedImage = [UIImage imageNamed:@"menu_orange"];
	
	switch (k.config.stage) {
		case 1:
			self.easyButton.selected = YES;
			self.hardButton.selected = NO;
			self.extremeButton.selected = NO;

			[self.easyButton setImage:selectedImage forState:UIControlStateNormal];
			[self.hardButton setImage:normalImage forState:UIControlStateNormal];
			[self.extremeButton setImage:normalImage forState:UIControlStateNormal];

			self.easyButton.accessibilityValue = NSLocalizedString(@"on", nil);
			self.hardButton.accessibilityValue = NSLocalizedString(@"off", nil);
			self.extremeButton.accessibilityValue = NSLocalizedString(@"off", nil);

			break;

		case 2:
			self.easyButton.selected = NO;
			self.hardButton.selected = YES;
			self.extremeButton.selected = NO;
			
			[self.easyButton setImage:normalImage forState:UIControlStateNormal];
			[self.hardButton setImage:selectedImage forState:UIControlStateNormal];
			[self.extremeButton setImage:normalImage forState:UIControlStateNormal];

			self.easyButton.accessibilityValue = NSLocalizedString(@"off", nil);
			self.hardButton.accessibilityValue = NSLocalizedString(@"on", nil);
			self.extremeButton.accessibilityValue = NSLocalizedString(@"off", nil);

			break;
			
		case 3:
			self.easyButton.selected = NO;
			self.hardButton.selected = NO;
			self.extremeButton.selected = YES;

			[self.easyButton setImage:normalImage forState:UIControlStateNormal];
			[self.hardButton setImage:normalImage forState:UIControlStateNormal];
			[self.extremeButton setImage:selectedImage forState:UIControlStateNormal];

			self.easyButton.accessibilityValue = NSLocalizedString(@"off", nil);
			self.hardButton.accessibilityValue = NSLocalizedString(@"off", nil);
			self.extremeButton.accessibilityValue = NSLocalizedString(@"on", nil);

			break;
	}
}

- (void)setHighlightedLevel:(NSInteger)highlightedLevel
{
	// De-highlight current cell
	if (_highlightedLevel != 0) {
		LevelCollectionViewCell *cell = (LevelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_highlightedLevel - 1 inSection:0]];
		[UIView animateWithDuration:0.1 animations:^{
			cell.imageView.transform = CGAffineTransformIdentity;
		}];
	}

	_highlightedLevel = highlightedLevel;

	// Highlight new cell
	if (_highlightedLevel != 0) {

		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_highlightedLevel - 1 inSection:0];
		LevelCollectionViewCell *cell = (LevelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
		[UIView animateWithDuration:0.2 animations:^{
			cell.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
		}];

		[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

		[[NSUserDefaults standardUserDefaults] setInteger:_highlightedLevel forKey:kConfigCurrentLevelNumber];
	}
}

- (BOOL)isHighlightedLevelVisible
{
	if (self.highlightedLevel != 0) {
		NSArray<NSIndexPath *> *visibleItems = [self.collectionView indexPathsForVisibleItems];
		if (visibleItems.count) {
			NSInteger highlightedItem = self.highlightedLevel - 1;
			for (NSIndexPath *indexPath in visibleItems) {
				if (highlightedItem == indexPath.item)
					return YES;
			}
		}
	}
	return NO;
}

- (void)updateHelpText
{
	switch (k.config.stage) {
		case 1:
			self.helpLabel.text = nil;
			break;
		case 2:
			self.helpLabel.text = NSLocalizedString(@"Hard Mode Help", nil);
			break;
		case 3:
			self.helpLabel.text = NSLocalizedString(@"Extreme Mode Help", nil);
			break;
	}
}

#pragma mark - Actions

- (IBAction)menuPressed:(id)sender
{
	[k.level back];
}

- (IBAction)modePressed:(id)sender
{
	NSInteger stage = [sender tag]; // 1..3
	[k.level command:[NSString stringWithFormat:@"stage.%d", (int)stage]];

	// On tvOS 9.1 a system sound is played by the Focus Engine. Play our own sound as well.
	[k.sound play:@"wall"];

	[self updateButtons];

#if TARGET_OS_TV
	// Update rotating spheres cursor
	[k.viewController.scene updateCursorStatus:YES];
#endif

	// Change collectionView to show level images of new stage.
	self.easyButton.enabled = NO;
	self.hardButton.enabled = NO;
	self.extremeButton.enabled = NO;
	[UIView animateWithDuration:0.4 animations:^{
		self.collectionView.alpha = 0;
		self.helpLabel.alpha = 0;
	} completion:^(BOOL finished) {
		[self.collectionView reloadData];
		[self updateHelpText];
		[UIView animateWithDuration:0.4 animations:^{
			self.collectionView.alpha = 1;
			self.helpLabel.alpha = 1;
		} completion:^(BOOL finished) {
			self.easyButton.enabled = YES;
			self.hardButton.enabled = YES;
			self.extremeButton.enabled = YES;
		}];
	}];

	// Inform accessibility that the button has changed
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, sender);
}

#pragma mark - Notifications

- (void)statChangedNotification:(NSNotification *)notification
{
	NSString *stat = notification.object;
	if (stat) {

		NSDictionary *userInfo = notification.userInfo;
		NSInteger stage = [userInfo[@"stage"] integerValue];

		if (k.config.stage == stage) {

			NSInteger level = [userInfo[@"level"] integerValue];

			if ([stat isEqualToString:@"score"]) {

				for (LevelCollectionViewCell *cell in [self.collectionView visibleCells]) {
					if (cell.levelNumber == level) {
						[cell updateContents];
						break;
					}
				}

			} else if ([stat isEqualToString:@"time"]) {

				for (LevelCollectionViewCell *cell in [self.collectionView visibleCells]) {
					if (cell.levelNumber == level) {
						[cell updateContents];
						break;
					}
				}
			}
		}

	} else {
		// Everything has changed

		for (LevelCollectionViewCell *cell in [self.collectionView visibleCells]) {
			[cell updateContents];
		}
	}
}

- (void)highlightVisibleLevel
{
	// Find the level that is currently visible in center of UICollectionView, and highlight it.

	NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
	if (visibleItems.count) {
		NSIndexPath *indexPath = visibleItems[visibleItems.count/2];
		self.highlightedLevel = indexPath.item + 1;
	}
}

- (void)controllerButtonPressedNotification:(NSNotification *)notification
{
	NSString *button = notification.object;

	if ([button isEqualToString:@"up"]) {

		if (_backButton.highlighted) {

			[self.backButton setHighlighted:NO animated:YES];
			[self.hardButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if (_easyButton.highlighted || _hardButton.highlighted || _extremeButton.highlighted) {
			// One of the buttons is highlighted -> highlight currently displayed level

			[self highlightVisibleLevel];
			[k.sound playMenuButtonSound];

			// De-highlight button
			if (self.easyButton.highlighted)
				[self.easyButton setHighlighted:NO animated:YES];
			if (self.hardButton.highlighted)
				[self.hardButton setHighlighted:NO animated:YES];
			if (self.extremeButton.highlighted)
				[self.extremeButton setHighlighted:NO animated:YES];

		} else if (![self isHighlightedLevelVisible]) {
			// Nothing is highlighted -> highlight currently displayed level

			NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
			if (visibleItems.count) {
				NSIndexPath *indexPath = visibleItems[visibleItems.count/2];
				self.highlightedLevel = indexPath.item + 1;
				[k.sound playMenuButtonSound];
			}
		}

	} else if ([button isEqualToString:@"down"]) {

		if (_backButton.isHighlighted) {
			// do nothing
		} else if (self.easyButton.isHighlighted) {

			[self.easyButton setHighlighted:NO animated:YES];
			[self.backButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if (self.hardButton.isHighlighted) {

			[self.hardButton setHighlighted:NO animated:YES];
			[self.backButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if (self.extremeButton.isHighlighted) {

			[self.extremeButton setHighlighted:NO animated:YES];
			[self.backButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if ([self isHighlightedLevelVisible]) {

			self.highlightedLevel = 0;
			[self.hardButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else {
			// Nothing is highlighted, so highlight these buttons by default.

			switch (k.config.stage) {
				case 1:
					[self.easyButton setHighlighted:YES animated:YES];
					break;
				case 2:
					[self.hardButton setHighlighted:YES animated:YES];
					break;
				case 3:
					[self.extremeButton setHighlighted:YES animated:YES];
					break;
			}
			[k.sound playMenuButtonSound];
		}

	} else if ([button isEqualToString:@"left"]) {

		if (self.backButton.highlighted) {
			// do nothing
		} else if (self.easyButton.highlighted) {
			// do nothing
		} else if (self.hardButton.highlighted) {

			[self.hardButton setHighlighted:NO animated:YES];
			[self.easyButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if (self.extremeButton.highlighted) {

			[self.extremeButton setHighlighted:NO animated:YES];
			[self.hardButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if ([self isHighlightedLevelVisible]) {

			if (self.highlightedLevel > 1) {
				self.highlightedLevel = self.highlightedLevel - 1;
				[k.sound playMenuButtonSound];
				[[NSUserDefaults standardUserDefaults] setInteger:self.highlightedLevel forKey:kConfigCurrentLevelNumber];
			}

		} else {
			// Nothing is highlighted

			// Highlight left-most visible level
			NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
			NSIndexPath *leftMost;
			for (NSIndexPath *indexPath in visibleItems) {
				if (!leftMost || indexPath.item < leftMost.item) {
					leftMost = indexPath;
				}
			}
			if (leftMost) {
				self.highlightedLevel = leftMost.item + 1;
				[k.sound playMenuButtonSound];
				[[NSUserDefaults standardUserDefaults] setInteger:self.highlightedLevel forKey:kConfigCurrentLevelNumber];
			}
		}

	} else if ([button isEqualToString:@"right"]) {

		if (_backButton.highlighted) {
			// do nothing
		} else if (self.easyButton.highlighted) {

			[self.easyButton setHighlighted:NO animated:YES];
			[self.hardButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if (self.hardButton.highlighted) {

			[self.hardButton setHighlighted:NO animated:YES];
			[self.extremeButton setHighlighted:YES animated:YES];
			[k.sound playMenuButtonSound];

		} else if (self.extremeButton.highlighted) {
			// do nothing
		} else if ([self isHighlightedLevelVisible]) {

			if (self.highlightedLevel < k.maxLevel) {
				self.highlightedLevel = self.highlightedLevel + 1;
				[k.sound playMenuButtonSound];
				[[NSUserDefaults standardUserDefaults] setInteger:self.highlightedLevel forKey:kConfigCurrentLevelNumber];
			}

		} else {
			// Nothing is highlighted

			// Highlight right-most visible level
			NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
			NSIndexPath *rightMost;
			for (NSIndexPath *indexPath in visibleItems) {
				if (!rightMost || indexPath.item > rightMost.item) {
					rightMost = indexPath;
				}
			}
			if (rightMost) {
				self.highlightedLevel = rightMost.item + 1;
				[k.sound playMenuButtonSound];
				[[NSUserDefaults standardUserDefaults] setInteger:self.highlightedLevel forKey:kConfigCurrentLevelNumber];
			}
		}

	} else if ([button isEqualToString:@"buttonA"]) {

		if (self.backButton.highlighted) {
			[self menuPressed:self.backButton];
		} else if (self.easyButton.highlighted) {
			[self modePressed:self.easyButton];
		} else if (self.hardButton.highlighted) {
			[self modePressed:self.hardButton];
		} else if (self.extremeButton.highlighted) {
			[self modePressed:self.extremeButton];
		} else if (self.highlightedLevel != 0) {

			if (self.highlightedLevel <= [k.config highestAvailableLevel]) {

				NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.highlightedLevel - 1 inSection:0];
				LevelCollectionViewCell *cell = (LevelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
				CGAffineTransform prevTransform = cell.imageView.transform;

				[UIView animateWithDuration:0.1 animations:^{
					cell.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
				} completion:^(BOOL finished) {
					[UIView animateWithDuration:0.1 animations:^{
						cell.imageView.transform = prevTransform;
					} completion:NULL];
				}];

				[k.level command:[NSString stringWithFormat:@"startExit.%d", (int)self.highlightedLevel]];
			}
		}
	}
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return k.maxLevel;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	LevelCollectionViewCell *levelCell = (LevelCollectionViewCell *)cell;
	levelCell.levelNumber = indexPath.item + 1; // 1..30
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	LevelCollectionViewCell *levelCell = (LevelCollectionViewCell *)cell;
	levelCell.levelNumber = indexPath.item + 1; // 1..30
	[levelCell updateContents];

	if (self.highlightedLevel != 0 && indexPath.item == self.highlightedLevel - 1) {
		levelCell.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
	} else {
		levelCell.imageView.transform = CGAffineTransformIdentity;
	}
}

//- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
//{
//	if (context.nextFocusedIndexPath && _playFocusSound) {
//		// On tvOS 9.1 a system sound is played by the Focus Engine (so we don't play our own sound here).
//	}
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger level = indexPath.item + 1; // 1..30
	if (level <= [k.config highestAvailableLevel]) {

#if !TARGET_OS_TV
		LevelCollectionViewCell *cell = (LevelCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
		[UIView animateWithDuration:0.1 animations:^{
			cell.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.1 animations:^{
				cell.imageView.transform = CGAffineTransformIdentity;
			} completion:NULL];
		}];
#endif

		[k.level command:[NSString stringWithFormat:@"startExit.%d", (int)level]];
	}
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger level = indexPath.item + 1; // 1..30
	return level <= [k.config highestAvailableLevel];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger level = indexPath.item + 1; // 1..30
	return level <= [k.config highestAvailableLevel];
}

#pragma mark - Focus

- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments
{
	// Take current level into focus

	NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:kConfigCurrentLevelNumber];

	// When switching between easy/hard/extreme, make sure a valid level is focused.
	NSInteger maxLevel = [k.config highestAvailableLevel];
	if (level > maxLevel) {
		level = maxLevel;
	}

	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:level - 1 inSection:0];
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	if (cell) {
		return @[cell];
	}

	return @[];
}

@end
