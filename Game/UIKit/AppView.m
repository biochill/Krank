#import "AppView.h"
#import "Globals.h"
#import "Switch.h"

@implementation AppView

#if !TARGET_OS_TV

- (IBAction)panRecognized:(UIGestureRecognizer *)recog
{
	CGPoint p = [recog locationInView:self];
	//	DLog(@"fingerpos=%@ state=%d", NSStringFromCGPoint(p), recog.state);

//#if TARGET_OS_TV
//
//	if (recog.state == UIGestureRecognizerStateBegan) {
//		self.lastPos = p;
//		
//	} else if (recog.state == UIGestureRecognizerStateChanged) {
//		
//		CGPoint v = CGCreateVector(self.lastPos, p);
//		v = CGPointScale(v, 0.5);
//		CGFloat length = CGPointLength(v);
//		CGFloat maxLength = 200;
//		if (length > maxLength) {
//			v = CGPointScale(v, maxLength/length);
//		}
//		
//		CGPoint newFingerPos = CGPointAdd(k.player.pos, v);
//		
//		CGRect rect = k.world.rect;
//		newFingerPos.x = fclamp(newFingerPos.x, rect.origin.x, rect.size.width);
//		newFingerPos.y = fclamp(newFingerPos.y, rect.origin.y, rect.size.height);
//		
//		k.input.fingerPos = newFingerPos;
//	}
//
//#else

	if (recog.state == UIGestureRecognizerStateBegan) {
		[k.input jumpToFingerPos:p];
	} else if (recog.state == UIGestureRecognizerStateChanged) {
		k.input.fingerPos = p;
	}

//#endif
}

- (IBAction)twoTapsRecognized:(UITapGestureRecognizer *)recog
{
	// 2 or more fingers works as pause
	if (recog.state == UIGestureRecognizerStateRecognized) {
		if (k.level.currentLevelNumber != 0) {
			[k.level togglePause];
		}
	}
}

#endif

- (IBAction)tapRecognized:(UIGestureRecognizer *)recog
{
	if (recog.state == UIGestureRecognizerStateRecognized) {
#if TARGET_OS_TV
		KrankScene *scene = (KrankScene *)self.scene;
		[scene.focusedSwitch collisionAction];
#else
		CGPoint p = [recog locationInView:self];
		[k.input jumpToFingerPos:p];
#endif
	}
}

@end
