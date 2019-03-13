//
//  PauseViewController.m
//  Krank
//
//  Created by Sven Thoennissen on 10.03.19.
//

#import "PauseViewController.h"
#import "CockpitButton.h"
#import "CockpitLabel.h"
#import "Globals.h"

@interface PauseViewController ()

@end

@implementation PauseViewController

#pragma mark - Overrides

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];

	self.currentLevelView.image = [PauseViewController makeCurrentLevelImage];

	//
	// Buttons
	//

	self.continueButton.text = NSLocalizedString(@"Continue", nil);
	self.continueButton.handler = ^{
		[k.level togglePause];
	};

	self.resetButton.text = NSLocalizedString(@"Reset", nil);
	self.resetButton.handler = ^{
		[k.level reset];
	};

	self.exitButton.text = NSLocalizedString(@"Exit", nil);
	self.exitButton.handler = ^{
		[k.level back];
	};

	//
	// Add focus guides to make focusing easy.
	// We are doing this because the focus engine has difficulties moving diagonally,
	// for example Exit -> Continue, Reset -> Continue, or Continue -> Exit.
	//

	// For Continue button: Guide extends the button to left & right
	UIFocusGuide *focusGuide = [[UIFocusGuide alloc] init];
	[self.continueButton addLayoutGuide:focusGuide];
	[focusGuide.leftAnchor constraintEqualToAnchor:self.exitButton.leftAnchor].active = YES;
	[focusGuide.rightAnchor constraintEqualToAnchor:self.resetButton.rightAnchor].active = YES;
	[focusGuide.topAnchor constraintEqualToAnchor:self.continueButton.topAnchor].active = YES;
	[focusGuide.bottomAnchor constraintEqualToAnchor:self.continueButton.bottomAnchor].active = YES;
	focusGuide.preferredFocusEnvironments = @[self.continueButton];

	// For Exit button: Guide extends the button from the ledge edge to the screen edge, and from the right edge to the screen center
	focusGuide = [[UIFocusGuide alloc] init];
	[self.exitButton addLayoutGuide:focusGuide];
	[focusGuide.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
	[focusGuide.rightAnchor constraintEqualToAnchor:self.continueButton.centerXAnchor].active = YES;
	[focusGuide.topAnchor constraintEqualToAnchor:self.exitButton.topAnchor].active = YES;
	[focusGuide.bottomAnchor constraintEqualToAnchor:self.exitButton.bottomAnchor].active = YES;
	focusGuide.preferredFocusEnvironments = @[self.exitButton];

	// For Reset button: Guide extends the button from the left edge to center of screen, and from the right edge to the screen edge
	focusGuide = [[UIFocusGuide alloc] init];
	[self.resetButton addLayoutGuide:focusGuide];
	[focusGuide.leftAnchor constraintEqualToAnchor:self.continueButton.centerXAnchor].active = YES;
	[focusGuide.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
	[focusGuide.topAnchor constraintEqualToAnchor:self.resetButton.topAnchor].active = YES;
	[focusGuide.bottomAnchor constraintEqualToAnchor:self.resetButton.bottomAnchor].active = YES;
	focusGuide.preferredFocusEnvironments = @[self.resetButton];

	//
	// Notifications
	//
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerButtonPressedNotification:) name:InputControllerButtonPressed object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.view.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// Tell Focus engine to update itself and find a focus item
	[self setNeedsFocusUpdate];

	// Show buttons
	[self animateIn:nil];
}

#pragma mark - Actions

- (IBAction)backgroundPressed:(UITapGestureRecognizer *)sender
{
	if (k.level.inTransition) return;

	if (sender.state == UIGestureRecognizerStateRecognized) {
		self.continueButton.handler();
	}
}

- (IBAction)menuPressed:(UITapGestureRecognizer *)sender
{
	if (k.level.inTransition) return;

	if (sender.state == UIGestureRecognizerStateBegan) {
		self.continueButton.handler();
	}
}

#pragma mark - Notifications

// For iOS
- (void)controllerButtonPressedNotification:(NSNotification *)notification
{
	if (k.level.inTransition) return;

	NSString *buttonIdentifier = notification.object;

	if ([buttonIdentifier isEqualToString:@"up"]) {

		if (self.continueButton.highlighted) {
			[self.continueButton setHighlighted:NO animated:YES];
			[self.resetButton setHighlighted:YES animated:YES];
		} else if (self.resetButton.highlighted) {
			// do nothing
		} else if (self.exitButton.highlighted) {
			// do nothing
		} else {
			[self.resetButton setHighlighted:YES animated:YES];
		}

	} else if ([buttonIdentifier isEqualToString:@"down"]) {

		if (self.resetButton.highlighted) {
			[self.resetButton setHighlighted:NO animated:YES];
			[self.continueButton setHighlighted:YES animated:YES];
		} else if (self.exitButton.highlighted) {
			[self.exitButton setHighlighted:NO animated:YES];
			[self.continueButton setHighlighted:YES animated:YES];
		} else if (self.continueButton.highlighted) {
			// do nothing
		} else {
			[self.continueButton setHighlighted:YES animated:YES];
		}

	} else if ([buttonIdentifier isEqualToString:@"left"]) {

		if (self.resetButton.highlighted) {
			[self.resetButton setHighlighted:NO animated:YES];
			[self.exitButton setHighlighted:YES animated:YES];
		} else if (self.continueButton.highlighted) {
			// do nothing
		} else if (self.exitButton.highlighted) {
			// do nothing
		} else {
			[self.exitButton setHighlighted:YES animated:YES];
		}

	} else if ([buttonIdentifier isEqualToString:@"right"]) {

		if (self.exitButton.highlighted) {
			[self.exitButton setHighlighted:NO animated:YES];
			[self.resetButton setHighlighted:YES animated:YES];
		} else if (self.resetButton.highlighted) {
			// do nothing
		} else if (self.continueButton.highlighted) {
			// do nothing
		} else {
			[self.resetButton setHighlighted:YES animated:YES];
		}

	} else if ([buttonIdentifier isEqualToString:@"buttonA"]) {

		if (self.continueButton.highlighted) {
			self.continueButton.handler();
		} else if (self.exitButton.highlighted) {
			self.exitButton.handler();
		} else if (self.resetButton.highlighted) {
			self.resetButton.handler();
		}
	}
}

#pragma mark - Helpers

+ (UIImage *)makeCurrentLevelImage
{
	NSArray *stageNames = @[@"", NSLocalizedString(@"Easy", nil), NSLocalizedString(@"Hard", nil), NSLocalizedString(@"Extreme", nil)];
	NSString *text = [NSString stringWithFormat:@"%@ %d", stageNames[k.config.stage], (int)k.level.currentLevelNumber];

	UIImage *normalImage = [CockpitLabel makeFancyTextImage:text font:k.largeCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:[UIColor whiteColor]];
	return normalImage;
}

- (void)animateIn:(ActionHandler)completion
{
	k.level.inTransition = YES;

	const CGFloat w = k.world.rect.size.width;
	const CGFloat h = k.world.rect.size.height;

	k.level.inTransition = YES;

	[self.continueButton setHighlighted:NO animated:NO];
	[self.resetButton setHighlighted:NO animated:NO];
	[self.exitButton setHighlighted:NO animated:NO];

	self.continueButton.transform = CGAffineTransformMakeTranslation(0, h - CGRectGetMinY(self.continueButton.frame));
	self.resetButton.transform = CGAffineTransformMakeTranslation(w - CGRectGetMinX(self.resetButton.frame), 0);
	self.exitButton.transform = CGAffineTransformMakeTranslation(0 - CGRectGetMaxX(self.exitButton.frame), 0);
	self.currentLevelView.transform = CGAffineTransformMakeTranslation(0, 0 - CGRectGetMaxY(self.currentLevelView.frame));
	self.view.alpha = 0;

	[UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

		self.continueButton.transform = CGAffineTransformIdentity;
		self.resetButton.transform = CGAffineTransformIdentity;
		self.exitButton.transform = CGAffineTransformIdentity;
		self.currentLevelView.transform = CGAffineTransformIdentity;
		self.view.alpha = 1;

	} completion:^(BOOL finished) {
		k.level.inTransition = NO;
		k.viewController.controllerUserInteractionEnabled = YES;
		if (completion) {
			completion();
		}
	}];
}

- (void)animateOut:(ActionHandler)completion
{
	const CGFloat w = k.world.rect.size.width;
	const CGFloat h = k.world.rect.size.height;

	k.level.inTransition = YES;

	[UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

		self.continueButton.transform = CGAffineTransformMakeTranslation(0, h - CGRectGetMinY(self.continueButton.frame));

		self.resetButton.transform = CGAffineTransformMakeTranslation(w - CGRectGetMinX(self.resetButton.frame), 0);

		self.exitButton.transform = CGAffineTransformMakeTranslation(0 - CGRectGetMaxX(self.exitButton.frame), 0);

		self.currentLevelView.transform = CGAffineTransformMakeTranslation(0, 0 - CGRectGetMaxY(self.currentLevelView.frame));

		self.view.alpha = 0;

	} completion:^(BOOL finished) {
		k.level.inTransition = NO;
		k.viewController.controllerUserInteractionEnabled = NO;
		if (completion) {
			completion();
		}
	}];

}

@end
