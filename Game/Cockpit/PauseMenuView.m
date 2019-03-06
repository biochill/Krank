//
//  PauseMenuView.m
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import "PauseMenuView.h"
#import "CockpitButton.h"
#import "CockpitLabel.h"
#import "Globals.h"


//@interface PauseMenuView ()
//@end


@implementation PauseMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {

		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

		//
		//
		//

		//
		// Buttons
		//
		_continueButton = [CockpitButton buttonWithText:NSLocalizedString(@"Continue", nil)];
		_continueButton.handler = ^{
			[k.level togglePause];
		};
		[self addSubview:_continueButton];
		
		_resetButton = [CockpitButton buttonWithText:NSLocalizedString(@"Reset", nil)];
		_resetButton.handler = ^{
			[k.level reset];
		};
		[self addSubview:_resetButton];

		_exitButton = [CockpitButton buttonWithText:NSLocalizedString(@"Exit", nil)];
		_exitButton.handler = ^{
			[k.level back];
		};
		[self addSubview:_exitButton];

#if TARGET_OS_TV
		// Gesture recognizer for menu button
		UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuPressed:)];
		recog.allowedPressTypes = @[@(UIPressTypeMenu)];
		[self addGestureRecognizer:recog];
#else
		// Gesture Recognizer for background tap
		UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundPressed:)];
		[self addGestureRecognizer:recog];
#endif

		// Notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerButtonPressedNotification:) name:InputControllerButtonPressed object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:InputControllerButtonPressed object:nil];
}

- (void)setupCurrentLevelView
{
	NSArray *stageNames = @[@"", NSLocalizedString(@"Easy", nil), NSLocalizedString(@"Hard", nil), NSLocalizedString(@"Extreme", nil)];
	NSString *text = [NSString stringWithFormat:@"%@ %d", stageNames[k.config.stage], (int)k.level.currentLevelNumber];

	UIImage *normalImage = [CockpitLabel makeFancyTextImage:text font:k.largeCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:[UIColor whiteColor]];

	[_currentLevelView removeFromSuperview];
	_currentLevelView = [[UIImageView alloc] initWithImage:normalImage];
	[self addSubview:_currentLevelView];
}

- (void)backgroundPressed:(UITapGestureRecognizer *)recognizer
{
	if (k.level.inTransition) return;

	if (recognizer.state == UIGestureRecognizerStateRecognized) {
		self.continueButton.handler();
	}
}

- (void)menuPressed:(UITapGestureRecognizer *)recognizer
{
	if (k.level.inTransition) return;

	if (recognizer.state == UIGestureRecognizerStateBegan) {
		self.continueButton.handler();
	}
}

- (UIView *)preferredFocusedView
{
	if (self.hidden) {
		return nil;
	}
	return self.continueButton;
}

- (void)controllerButtonPressedNotification:(NSNotification *)notification
{
	if (!self.superview || k.level.inTransition) return; // not on-screen

	NSString *button = notification.object;

	if ([button isEqualToString:@"up"]) {

		if (_continueButton.highlighted) {
			[_continueButton setHighlighted:NO animated:YES];
			[_resetButton setHighlighted:YES animated:YES];
		} else if (_resetButton.highlighted) {
			// do nothing
		} else if (_exitButton.highlighted) {
			// do nothing
		} else {
			[_resetButton setHighlighted:YES animated:YES];
		}

	} else if ([button isEqualToString:@"down"]) {

		if (_resetButton.highlighted) {
			[_resetButton setHighlighted:NO animated:YES];
			[_continueButton setHighlighted:YES animated:YES];
		} else if (_exitButton.highlighted) {
			[_exitButton setHighlighted:NO animated:YES];
			[_continueButton setHighlighted:YES animated:YES];
		} else if (_continueButton.highlighted) {
			// do nothing
		} else {
			[_continueButton setHighlighted:YES animated:YES];
		}

	} else if ([button isEqualToString:@"left"]) {

		if (_resetButton.highlighted) {
			[_resetButton setHighlighted:NO animated:YES];
			[_exitButton setHighlighted:YES animated:YES];
		} else if (_continueButton.highlighted) {
			// do nothing
		} else if (_exitButton.highlighted) {
			// do nothing
		} else {
			[_exitButton setHighlighted:YES animated:YES];
		}

	} else if ([button isEqualToString:@"right"]) {

		if (_exitButton.highlighted) {
			[_exitButton setHighlighted:NO animated:YES];
			[_resetButton setHighlighted:YES animated:YES];
		} else if (_resetButton.highlighted) {
			// do nothing
		} else if (_continueButton.highlighted) {
			// do nothing
		} else {
			[_resetButton setHighlighted:YES animated:YES];
		}

	} else if ([button isEqualToString:@"buttonA"]) {

		if (_continueButton.highlighted) {
			_continueButton.handler();
		} else if (_exitButton.highlighted) {
			_exitButton.handler();
		} else if (_resetButton.highlighted) {
			_resetButton.handler();
		}
	}
}

- (void)presentWithCompletion:(ActionHandler)completion
{
	k.level.inTransition = YES;

	const CGFloat w = self.bounds.size.width;
	const CGFloat h = self.bounds.size.height;
	const CGFloat cx = self.center.x;

	[_continueButton setHighlighted:NO animated:NO];
	[_resetButton setHighlighted:NO animated:NO];
	[_exitButton setHighlighted:NO animated:NO];

	_continueButton.center = CGPointMake(cx, h + _continueButton.bounds.size.height/2);
	_resetButton.center = CGPointMake(w + _resetButton.bounds.size.width/2, h/3);
	_exitButton.center = CGPointMake(-_exitButton.bounds.size.width/2, h/3);
	_currentLevelView.center = CGPointMake(cx, -CGRectGetHeight(_currentLevelView.frame));

	self.alpha = 0;
	[UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.continueButton.center = CGPointMake(cx, 2*h/3);
		self.resetButton.center = CGPointMake(3*w/4, h/3);
		self.exitButton.center = CGPointMake(1*w/4, h/3);
		self.currentLevelView.center = CGPointMake(cx, h*0.025 + CGRectGetHeight(self.currentLevelView.frame)/2);
		self.alpha = 1;
	} completion:^(BOOL finished) {
		k.level.inTransition = NO;
		[self setNeedsFocusUpdate];
		if (completion) {
			completion();
		}
	}];
}

- (void)dismissAnimated:(BOOL)animated completion:(ActionHandler)completion
{
	const CGFloat w = k.world.rect.size.width;
	const CGFloat h = k.world.rect.size.height;
	const CGFloat cx = k.world.center.x;

	if (animated) {

		k.level.inTransition = YES;

		[UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.continueButton.center = CGPointMake(cx, h + self.continueButton.bounds.size.height/2);
			self.resetButton.center = CGPointMake(w + self.resetButton.bounds.size.width/2, h/3);
			self.exitButton.center = CGPointMake(-self.exitButton.bounds.size.width/2, h/3);
			self.currentLevelView.center = CGPointMake(cx, -CGRectGetHeight(self.currentLevelView.frame)/2);
			self.alpha = 0;
		} completion:^(BOOL finished) {
			k.level.inTransition = NO;
			if (completion) {
				completion();
			}
		}];

	} else {

		_continueButton.center = CGPointMake(cx, h + _continueButton.bounds.size.height/2);
		_resetButton.center = CGPointMake(w + _resetButton.bounds.size.width/2, h/3);
		_exitButton.center = CGPointMake(-_exitButton.bounds.size.width/2, h/3);
		_currentLevelView.center = CGPointMake(cx, -CGRectGetHeight(_currentLevelView.frame)/2);

		if (completion) {
			completion();
		}
	}
}

@end
