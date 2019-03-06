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

	SKTexture *texture = [SKTexture textureWithImage:[self makeFancyTextImage]];
	self.texture = texture;
	self.size = [texture size];
	self.name = _text;
}

- (UIImage *)makeFancyTextImage
{
	return [CockpitLabel makeFancyTextImage:self.text font:self.font alignment:self.alignment textWidth:self.textWidth textColor:self.textColor];
}

+ (UIImage *)makeFancyTextImage:(NSString *)text font:(UIFont *)font alignment:(NSTextAlignment)alignment textWidth:(CGFloat)textWidth textColor:(UIColor *)textColor
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
	
	CGRect rect = CGRectMake(0, 0, buttonImage.size.width + textWidth, buttonImage.size.height);
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = alignment;
//	style.alignment = NSTextAlignmentNatural;
//	if (self.alignment == ANCHOR_RIGHT) {
//		style.alignment = NSTextAlignmentRight;
//	} else if (self.anchor == ANCHOR_CENTER) {
//		style.alignment = NSTextAlignmentCenter;
//	}
	CGFloat dim = 0.3;
	UIColor *gradientColor = dim != 1.0 ? [textColor verticalGradientColorWithHeight:CGRectGetHeight(rect) dimFactor:dim] : textColor;
	NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:gradientColor};
	
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
	
	// paint background button image
	[buttonImage drawInRect:rect];
	
	// draw text
	CGRect textRect = CGRectInset(rect, buttonWidth/2, 0);
	[text drawInRect:textRect withAttributes:attributes];
	
	// create image
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// clean up
	UIGraphicsEndImageContext();
	
	return finalImage;
}

@end
