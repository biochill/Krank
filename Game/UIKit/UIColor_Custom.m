//
//  UIColor+UIColor_Custom.m
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import "UIColor_Custom.h"
#import "Globals.h"

@implementation UIColor (UIColor_Custom)

- (UIColor *)multiply:(CGFloat)f
{
	CGFloat r = 0, g = 0, b = 0, a = 0;

	if ([self getRed:&r green:&g blue:&b alpha:&a]) {
		return [UIColor colorWithRed:fmin(r*f, 1) green:fmin(g*f, 1) blue:fmin(b*f, 1) alpha:a];
	}
	return self;
}

- (UIColor *)verticalGradientPatternWithHeight:(CGFloat)height dimFactor:(CGFloat)dim
{
	CGRect rect = CGRectMake(0, 0, 10, ceil(height));

	UIColor *bottomColor = [self multiply:dim];

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

	UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);

	CGContextRef context = UIGraphicsGetCurrentContext();
	NSAssert(context, @"Must have CG context");

	CGFloat locations[] = {0, 0.2, 1};
	CGFloat comp[12];
	[self getRed:&comp[0] green:&comp[1] blue:&comp[2] alpha:&comp[3]];
	[self getRed:&comp[4] green:&comp[5] blue:&comp[6] alpha:&comp[7]];
	[bottomColor getRed:&comp[8] green:&comp[9] blue:&comp[10] alpha:&comp[11]];

	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, comp, locations, 3);
	CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(rect) - 1), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	CGColorSpaceRelease(space);

	return [UIColor colorWithPatternImage:image];
}
/*
- (UIColor *)verticalGlassEdgeColorWithHeight:(CGFloat)height// dimFactor:(CGFloat)dim
{
	CGRect rect = CGRectMake(0, 0, 1, height);
	
	UIColor *color1 = [self multiply:0.3];
	UIColor *color2 = self;
	UIColor *color3 = [self multiply:0.5];
	UIColor *color4 = self;

	UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
	
	CGFloat comp[16];
	[color1 getRed:&comp[0] green:&comp[1] blue:&comp[2] alpha:&comp[3]];
	[color2 getRed:&comp[4] green:&comp[5] blue:&comp[6] alpha:&comp[7]];
	[color3 getRed:&comp[8] green:&comp[9] blue:&comp[10] alpha:&comp[11]];
	[color4 getRed:&comp[12] green:&comp[13] blue:&comp[14] alpha:&comp[15]];

	CGFloat locations[] = {0, 0.49, 0.5, 1};

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, comp, locations, 4);
	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, CGPointMake(0, 0), CGPointMake(0, height), 0);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(space);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return [UIColor colorWithPatternImage:image];
}
*/
@end
