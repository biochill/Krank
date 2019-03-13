//
//  Toggle.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Toggle.h"
#import "Globals.h"


@implementation Toggle

- (id)initWithText:(NSString *)text anchor:(NSInteger)anchor option:(NSString *)option position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName
{
	if ((self = [super initWithText:text anchor:anchor command:nil position:pos font:font imageName:imageName color:@"white"])) {
		_imagePrefix = imageName;
		_option = option;
		self.soundEnabled = YES;
		[self updateImage];
	}
	return self;
}

- (BOOL)isSelected
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:self.option];
}

- (void)updateImage
{
	NSString *colorName = self.isSelected ? @"orange" : @"white";
	NSString *imageName = [NSString stringWithFormat:@"%@_%@", self.imagePrefix, colorName];

//#if TARGET_OS_TV
//	UIImage *image = [UIImage imageNamed:imageName];
//	[self.button setImage:image forState:UIControlStateNormal];
//	self.button.accessibilityValue = on ? NSLocalizedString(@"on", nil) : NSLocalizedString(@"off", nil);
//	self.button.selected = on;
//#else
	[self setImageName:imageName];
//#endif
}
/*
- (void)buttonAction:(id)sender
{
	// Small animation to show click
//	if ([sender isKindOfClass:[MenuButton class]]) {
//		MenuButton *button = sender;
//		[UIView animateWithDuration:0.1 animations:^{
//			button.transform = CGAffineTransformMakeScale(button.focusScale*0.8, button.focusScale*0.8);
//		} completion:^(BOOL finished) {
//			[UIView animateWithDuration:0.1 animations:^{
//				button.transform = CGAffineTransformMakeScale(button.focusScale, button.focusScale);
//			} completion:NULL];
//		}];
//	}

	[self collisionAction];

	// Inform accessibility that the button has changed
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, sender);
}
*/

- (void)collisionAction
{
	BOOL newValue = !self.isSelected;
	self.command = [NSString stringWithFormat:@"#%@ %d", self.option, newValue];
	[super collisionAction];

	[self updateImage];

	// Flip focus cursors
	[k.viewController.scene updateCursorStatus:newValue];
}

#if TARGET_OS_TV

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
	// Similar to the same method in Switch

	KrankScene *scene = (KrankScene *)self.scene;

	if (context.nextFocusedItem == self) {

		scene.focusedSwitch = self;

		[coordinator addCoordinatedFocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
			[scene animateFocusToPosition:self.position radius:self.radius selected:self.isSelected duration:animationContext.duration animateOut:NO];
		} completion:NULL];

	} else {

		if (scene.focusedSwitch == self) {
			scene.focusedSwitch = nil;
		}

	}
}

#endif

@end
