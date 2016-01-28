#import "AppView.h"
#import "Globals.h"


//@interface AppView ()
//#if TARGET_OS_TV
//@property (nonatomic) CGPoint lastPos;
//#endif
//@end

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

- (IBAction)tapRecognized:(UIGestureRecognizer *)recog
{
	CGPoint p = [recog locationInView:self];
//	DLog(@"%s state=%d", __PRETTY_FUNCTION__, (int)recog.state);

	if (recog.state == UIGestureRecognizerStateRecognized) {
		[k.input jumpToFingerPos:p];
	}
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s type %d/%d count %u", __PRETTY_FUNCTION__, (int)event.type, (int)event.subtype, (unsigned)touches.count);

	if (touches.count != 0) {
		UITouch *t = [touches anyObject]; //[[touches allObjects] objectAtIndex:0];
		CGPoint p = [t locationInView:self];
		k.input.fingerPos = p;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s type %d/%d count %u", __PRETTY_FUNCTION__, (int)event.type, (int)event.subtype, (unsigned)touches.count);

	if ([touches count] != 0) {
		UITouch *t = [touches anyObject]; //[[touches allObjects] objectAtIndex:0];
		CGPoint p = [t locationInView:self];
		k.input.fingerPos = p;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s type %d/%d count %u", __PRETTY_FUNCTION__, (int)event.type, (int)event.subtype, (unsigned)touches.count);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s", __PRETTY_FUNCTION__);
}
*/
#endif

@end
