//
//  TestNode.m
//  Krank
//
//  Created by Sven Thoennissen on 10.03.19.
//

#import "TestNode.h"
#import "DLog.h"

@implementation TestNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)touches.count);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)touches.count);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)touches.count);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	DLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)touches.count);
}

@end
