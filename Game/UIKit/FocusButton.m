//
//  FocusButton.m
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import "FocusButton.h"
#import "Globals.h"
#import "UIColor_Custom.h"


const CGFloat FocusScale = 1.4;


@implementation FocusButton

- (void)awakeFromNib
{
	[super awakeFromNib];
}

// For tvOS
#if TARGET_OS_TV

- (void)setTransform:(CGAffineTransform)transform
{
	DLog(@"Setting transform for %@: %@", self.description, NSStringFromCGAffineTransform(transform));
	[super setTransform:transform];

}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
	if (context.nextFocusedItem == self) {

		DLog(@"Focusing button %@", self.description);

		// Show text in yellow
//		self.highlighted = YES;

		[coordinator addCoordinatedFocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
			self.transform = CGAffineTransformMakeScale(FocusScale, FocusScale);
		} completion:NULL];

	} else if (context.previouslyFocusedItem == self) {

		DLog(@"Unfocusing button %@", self.description);

		// Show text in white
//		self.highlighted = NO;

		[coordinator addCoordinatedUnfocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
			self.transform = CGAffineTransformIdentity;
		} completion:NULL];

	}
}
#endif

// For iOS
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	self.highlighted = highlighted;

	if (animated) {
		if (highlighted) {
			[UIView animateWithDuration:0.2 animations:^{
				self.transform = CGAffineTransformMakeScale(FocusScale, FocusScale);
			}];
		} else {
			[UIView animateWithDuration:0.1 animations:^{
				self.transform = CGAffineTransformIdentity;
			}];
		}
	} else {
		if (highlighted) {
			self.transform = CGAffineTransformMakeScale(FocusScale, FocusScale);
		} else {
			self.transform = CGAffineTransformIdentity;
		}
	}
}

@end
