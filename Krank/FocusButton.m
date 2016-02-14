//
//  FocusButton.m
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import "FocusButton.h"
#import "Globals.h"

@implementation FocusButton

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		_focusScale = 1.4;
	}
	return self;
}

- (void)awakeFromNib
{
	_focusScale = 1.4;
}

// For tvOS
- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
	if (context.nextFocusedView == self) {

		self.highlighted = YES;

		[coordinator addCoordinatedAnimations:^{
			self.transform = CGAffineTransformMakeScale(_focusScale, _focusScale);
		} completion:NULL];

		// On tvOS a system sound is played by the Focus Engine, so we do not play it here.

	} else {

		self.highlighted = NO;

		[coordinator addCoordinatedAnimations:^{
			self.transform = CGAffineTransformIdentity;
		} completion:NULL];

	}
}

// For iOS
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	self.highlighted = highlighted;

	if (animated) {
		if (highlighted) {
			[UIView animateWithDuration:0.2 animations:^{
				self.transform = CGAffineTransformMakeScale(_focusScale, _focusScale);
			}];
			[k.sound play:@"part"];
		} else {
			[UIView animateWithDuration:0.1 animations:^{
				self.transform = CGAffineTransformIdentity;
			}];
		}
	} else {
		if (highlighted) {
			self.transform = CGAffineTransformMakeScale(_focusScale, _focusScale);
			[k.sound play:@"part"];
		} else {
			self.transform = CGAffineTransformIdentity;
		}
	}
}

@end
