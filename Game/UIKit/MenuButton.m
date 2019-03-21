//
//  MenuButton.m
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import "KrankViewController.h"
#import "MenuButton.h"
#import "FocusButton.h"
#import "Globals.h"
#import "LevelCollectionViewCell.h"

@implementation MenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
//		_focusScale = 1.4;
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
//	_focusScale = 1.4;
}

#if TARGET_OS_TV

// For tvOS
- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
	CGFloat radius = self.imageView.image.size.height/2;

	if (context.nextFocusedItem == self) {
		// Focusing towards the self button

		CGRect rect = self.bounds;
		CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		CGPoint screenPoint = [self convertPoint:center toView:nil];
		CGPoint scenePoint = [k.world convertToScenePoint:screenPoint];

		[coordinator addCoordinatedFocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
			[k.viewController.scene animateFocusToPosition:scenePoint radius:radius selected:self.isSelected duration:animationContext.duration animateOut:NO];
		} completion:NULL];

	} else if ([context.nextFocusedItem isKindOfClass:[LevelCollectionViewCell class]]) {
		// Focusing away from self, to a cell

		UICollectionViewCell *cell = (UICollectionViewCell *)context.nextFocusedItem;

		CGRect rect = context.nextFocusedItem.frame;
		rect.origin = CGPointZero;
		CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		CGPoint screenPoint = [cell convertPoint:center toView:nil];
		CGPoint scenePoint = [k.world convertToScenePoint:screenPoint];

		[coordinator addCoordinatedUnfocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
			[k.viewController.scene animateFocusToPosition:scenePoint radius:radius selected:NO duration:animationContext.duration animateOut:YES];
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
