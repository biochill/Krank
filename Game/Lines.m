//
//  Lines.m

#import "Lines.h"
#import "Globals.h"
#import "Tools.h"

@implementation Lines

- (instancetype)init
{
	if ((self = [super init]))
	{
		self.zPosition = -40;
		self.name = @"Lines";
	}
	return self;
}

- (void)addLineFrom:(CGPoint)p1 to:(CGPoint)p2
{
// p1, p2 in SKScene coordinates

//	CGFloat bottom = CGRectGetMaxY(k.viewController.scene.frame);
	CGPoint points[2] = { CGPointMake(p1.x, p1.y), CGPointMake(p2.x, p2.y) };
	SKShapeNode *lineNode = [SKShapeNode shapeNodeWithPoints:points count:2];
	lineNode.glowWidth = 1;
	if (_lineType == LineTypeWhite) {
		lineNode.strokeColor = [SKColor colorWithWhite:0.88 alpha:1];
	} else {
		lineNode.strokeColor = [SKColor blackColor];
	}
	[self addChild:lineNode];
/*
	if (_currentLineIndex >= _maxLines) {
//		NSAssert(NO, @"Out of line views!");
		return;
	}

	UIView *lineView = _lineViews[_currentLineIndex++];
	lineView.hidden = NO;
	CGPoint vec = CGCreateVector(p1, p2);
	CGRect frame = CGRectMake(p1.x, p1.y, vec.x, vec.y);
	lineView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	lineView.bounds = CGRectMake(0, 0, 5.0/[UIScreen mainScreen].scale, CGPointLength(vec));
	lineView.transform = CGAffineTransformMakeRotation(M_PI_2 + atan2(vec.y, vec.x));
	[self addSubview:lineView];
*/
}

- (void)clear
{
	[self removeAllChildren];
}

@end
