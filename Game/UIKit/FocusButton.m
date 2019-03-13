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

	UIFont *font = self.titleLabel.font;
	if (font) {
		UIColor *textColor = [UIColor whiteColor];
		UIColor *gradient = [textColor verticalGradientColorWithHeight:ceil(font.lineHeight) dimFactor:0.5];
		[self setTitleColor:gradient forState:UIControlStateNormal];
	}
}

#if TARGET_OS_TV
- (UIFocusSoundIdentifier)soundIdentifierForFocusUpdateInContext:(UIFocusUpdateContext *)context
{
	return k.sound.soundFXEnabled ? SoundFocusIdentifierMenuPart : UIFocusSoundIdentifierNone;
}
#endif

// For tvOS
- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
	if (context.nextFocusedItem == self) {

		// Show text in yellow
		self.highlighted = YES;

//		[coordinator addCoordinatedFocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
//			self.transform = CGAffineTransformMakeScale(FocusScale, FocusScale);
//		} completion:NULL];

	} else if (context.previouslyFocusedItem == self) {

		// Show text in white
		self.highlighted = NO;

//		[coordinator addCoordinatedUnfocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
//			self.transform = CGAffineTransformIdentity;
//		} completion:NULL];

	}
}

// For iOS
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	self.highlighted = highlighted;

	if (animated) {
		if (highlighted) {
			[UIView animateWithDuration:0.2 animations:^{
				self.transform = CGAffineTransformMakeScale(FocusScale, FocusScale);
			}];
			[k.sound play:@"part"];
		} else {
			[UIView animateWithDuration:0.1 animations:^{
				self.transform = CGAffineTransformIdentity;
			}];
		}
	} else {
		if (highlighted) {
			self.transform = CGAffineTransformMakeScale(FocusScale, FocusScale);
			[k.sound play:@"part"];
		} else {
			self.transform = CGAffineTransformIdentity;
		}
	}
}

@end
