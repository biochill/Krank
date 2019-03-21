//
//  CockpitLabel.m
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//

#import "CockpitLabel.h"
#import "Globals.h"
#import "UIColor_Custom.h"

@interface CockpitLabel ()
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) CGFloat textWidth;
@property (nonatomic) NSTextAlignment alignment;
@end

@implementation CockpitLabel

- (id)initWithColor:(UIColor *)aColor font:(UIFont *)font textWidth:(CGFloat)textWidth alignment:(NSTextAlignment)alignment
{
	if ((self = [super init]))
	{
		_textColor = aColor;
		_font = font;
		_textWidth = textWidth;
		_alignment = alignment;
		_text = @"";
//		_dim = 0.3;
	}
	return self;
}

- (void)setText:(NSString *)text
{
	// this method is called every frame, so this test is important
	if ([_text isEqualToString:text]) return;
	
	_text = text;

	UIImage *textImage = [CockpitLabel makeFancyTextButtonImage:self.text font:self.font alignment:self.alignment textWidth:self.textWidth textColor:self.textColor];
	SKTexture *texture = [SKTexture textureWithImage:textImage];
	self.texture = texture;
	self.size = [texture size];
	self.name = _text;
}
/*
+ (UIImage *)makeFancyText:(NSString *)text font:(UIFont *)font
{
	return [self makeFancyText:text font:font textColor:[UIColor whiteColor]];
}

+ (UIImage *)makeFancyText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor
{
	NSDictionary *attributes = @{NSFontAttributeName:font};
	CGSize textSize = [text sizeWithAttributes:attributes];
	CGRect textRect = CGRectMake(0, 0, textSize.width, textSize.height);

	UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0);

	// draw text
	[text drawInRect:textRect withAttributes:attributes];

	//
	// Now draw gradient on top of text -- see blend mode kCGBlendModeSourceIn
	//

	CGContextRef context = UIGraphicsGetCurrentContext();
	NSAssert(context, @"Must have CG context");

	UIColor *bottomColor = [UIColor blackColor];

	CGFloat locations[] = {0, 0.2, 1};
	CGFloat comp[12];
	[textColor getRed:&comp[0] green:&comp[1] blue:&comp[2] alpha:&comp[3]];
	[textColor getRed:&comp[4] green:&comp[5] blue:&comp[6] alpha:&comp[7]];
	[bottomColor getRed:&comp[8] green:&comp[9] blue:&comp[10] alpha:&comp[11]];

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, comp, locations, 3);
	CGContextSetBlendMode(context, kCGBlendModeSourceIn);
	CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(textRect) - 1), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(space);

	// Finish image
	UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return textImage;
}

+ (UIImage *)makeFancyTextButtonImage:(NSString *)text font:(UIFont *)font alignment:(NSTextAlignment)alignment textWidth:(CGFloat)textWidth textColor:(UIColor *)textColor
{
	UIImage *buttonImage;

	if (font == k.largeCockpitFont)
	{
		buttonImage = [UIImage imageNamed:@"cockpit_s"];
	}
	else if (font == k.smallCockpitFont)
	{
		buttonImage = [UIImage imageNamed:@"cockpit_t"];
	}
	else if (font == k.hugeCockpitFont)
	{
		buttonImage = [UIImage imageNamed:@"cockpit_l"];
	}
	else { NSAssert(NO, @"unsupported font size"); }

	CGFloat buttonWidth = buttonImage.size.width;
	buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonWidth/2, 0, buttonWidth/2 - 1)];

	// With textWidth=0, we make the button just wide enough to show the text
	CGFloat actualWidth = [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
	textWidth = textWidth == 0 ? actualWidth : fmax(textWidth, actualWidth);
	
	CGRect buttonRect = CGRectMake(0, 0, buttonImage.size.width + textWidth, buttonImage.size.height);
	
	//
	// Create image that draws the text first, then a gradient only over the text
	//

	CGRect textRect = CGRectMake(0, 0, textWidth, buttonImage.size.height);
	UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0);

	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = alignment;
	NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};

	// draw text
	[text drawInRect:textRect withAttributes:attributes];

	//
	// Now draw gradient on top of text -- see blend mode kCGBlendModeSourceIn
	//

	CGContextRef context = UIGraphicsGetCurrentContext();
	NSAssert(context, @"Must have CG context");

	UIColor *bottomColor = [UIColor blackColor];

	CGFloat locations[] = {0, 0.2, 1};
	CGFloat comp[12];
	[textColor getRed:&comp[0] green:&comp[1] blue:&comp[2] alpha:&comp[3]];
	[textColor getRed:&comp[4] green:&comp[5] blue:&comp[6] alpha:&comp[7]];
	[bottomColor getRed:&comp[8] green:&comp[9] blue:&comp[10] alpha:&comp[11]];

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, comp, locations, 3);
	CGContextSetBlendMode(context, kCGBlendModeSourceIn);
	CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(textRect) - 1), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(space);

	// Finish image
	UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	//
	// Draw button background, and on top of it the text image
	//

	UIGraphicsBeginImageContextWithOptions(buttonRect.size, NO, 0);

	context = UIGraphicsGetCurrentContext();
	NSAssert(context, @"Must have CG context");

	// paint background button image
	[buttonImage drawInRect:buttonRect];

	// paint text image
	[textImage drawInRect:CGRectInset(buttonRect, buttonImage.size.width/2, 0)];

	// create image
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// clean up
	UIGraphicsEndImageContext();
	
	return finalImage;
}
*/

+ (UIImage *)makeFancyTextButtonImage:(NSString *)text font:(UIFont *)font alignment:(NSTextAlignment)alignment textWidth:(CGFloat)textWidth textColor:(UIColor *)textColor
{
	UIImage *buttonImage;

	if (font == k.largeCockpitFont)
	{
		buttonImage = [UIImage imageNamed:@"cockpit_s"];
	}
	else if (font == k.smallCockpitFont)
	{
		buttonImage = [UIImage imageNamed:@"cockpit_t"];
	}
	else if (font == k.hugeCockpitFont)
	{
		buttonImage = [UIImage imageNamed:@"cockpit_l"];
	}
	else { NSAssert(NO, @"unsupported font size"); }

	CGFloat buttonWidth = buttonImage.size.width;
	buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, buttonWidth/2, 0, buttonWidth/2 - 1)];

	// With textWidth=0, we make the button just wide enough to show the text
	CGFloat actualWidth = [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
	textWidth = textWidth == 0 ? actualWidth : fmax(textWidth, actualWidth);

	CGRect buttonRect = CGRectMake(0, 0, buttonImage.size.width + textWidth, buttonImage.size.height);
	CGRect textRect = CGRectInset(buttonRect, buttonImage.size.width/2, 0);

	//
	// Create image that draws the text first, then a gradient only over the text
	//

	UIColor *gradientColor = [textColor verticalGradientPatternWithHeight:buttonImage.size.height dimFactor:0];
/*
	CGRect textRect = CGRectMake(0, 0, textWidth, buttonImage.size.height);

	UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0);

	//
	// Now draw gradient on top of text -- see blend mode kCGBlendModeSourceIn
	//

	CGContextRef context = UIGraphicsGetCurrentContext();
	NSAssert(context, @"Must have CG context");

	UIColor *bottomColor = [UIColor blackColor];

	CGFloat locations[] = {0, 0.2, 1};
	CGFloat comp[12];
	[textColor getRed:&comp[0] green:&comp[1] blue:&comp[2] alpha:&comp[3]];
	[textColor getRed:&comp[4] green:&comp[5] blue:&comp[6] alpha:&comp[7]];
	[bottomColor getRed:&comp[8] green:&comp[9] blue:&comp[10] alpha:&comp[11]];

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, comp, locations, 3);
	CGContextSetBlendMode(context, kCGBlendModeSourceIn);
	CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetMaxY(textRect) - 1), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(space);

	// Finish image
	UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
*/
	//
	// Draw button background, and on top of it the text image
	//

	UIGraphicsBeginImageContextWithOptions(buttonRect.size, NO, 0);

	CGContextRef context = UIGraphicsGetCurrentContext();
	NSAssert(context, @"Must have CG context");

	// paint background button image
	[buttonImage drawInRect:buttonRect];

	// paint text image
//	[textImage drawInRect:CGRectInset(buttonRect, buttonImage.size.width/2, 0)];

	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = alignment;
	NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName: gradientColor};

	// draw text
	[text drawInRect:textRect withAttributes:attributes];

	// create image
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();

	// clean up
	UIGraphicsEndImageContext();

	return finalImage;
}

@end
