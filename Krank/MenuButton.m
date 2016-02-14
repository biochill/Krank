//
//  MenuButton.m
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import "MenuButton.h"
#import "Globals.h"
#import "LevelCollectionViewCell.h"

@implementation MenuButton

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

		CGPoint viewPoint = [k.viewController.gameView convertPoint:self.center fromView:self.superview];
		CGPoint scenePoint = [k.world convertToScenePoint:viewPoint];

		[coordinator addCoordinatedAnimations:^{
			[k.viewController.scene animateFocusToPosition:scenePoint radius:48 status:self.selected duration:[UIView inheritedAnimationDuration]];
//			self.transform = CGAffineTransformMakeScale(_focusScale, _focusScale);
		} completion:NULL];

		// On tvOS a system sound is played by the Focus Engine, so we do not play it here.

	} else {

		self.highlighted = NO;

		if ([context.nextFocusedView isKindOfClass:[LevelCollectionViewCell class]]) {

			// Animate cursor spheres towards collectionView
			CGPoint viewPoint = [k.viewController.gameView convertPoint:self.center fromView:self.superview];
			CGPoint target = CGPointAdd(viewPoint, CGPointMake(0, -300));
			CGPoint scenePoint = [k.world convertToScenePoint:target];
			[k.viewController.scene animateFocusOutWithTargetPosition:scenePoint];
		}

//		[coordinator addCoordinatedAnimations:^{
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

//- (void)setOption:(NSString *)option
//{
//	_option = option;
//	[self updateImage];
//}
//
//- (void)updateImage
//{
//	BOOL on = self.option ? [[NSUserDefaults standardUserDefaults] boolForKey:self.option] : NO;
//	NSString *colorName = on ? @"orange" : @"white";
//	NSString *imageName = [NSString stringWithFormat:@"menu_%@", colorName];
//	[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}

//- (void)setSelected:(BOOL)selected
//{
//	[super setSelected:selected];
////	[self updateImage];
//
//	if (self.highlighted) {
//		[k.viewController.scene updateCursorStatus:selected];
//	}
//}

@end
