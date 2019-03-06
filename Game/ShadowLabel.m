//
//  ShadowLabel.m
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import "ShadowLabel.h"
#import "UIColor_Custom.h"
#import "Globals.h"

@implementation ShadowLabel

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		_myShadowOffset = CGSizeMake(3, 3);
		_myBlur = 0;
		[self updateShadowMargin];
	}
	return self;
}

- (void)setFont:(UIFont *)font
{
	[super setFont:font];

	if (font == k.largeFont) {
		_myShadowOffset = CGSizeMake(2, 3);
	} else if (font == k.normalFont) {
		_myShadowOffset = CGSizeMake(1, 2);
	}
}

- (void)awakeFromNib
{
	_myShadowOffset = CGSizeMake(2, 4);
	_myBlur = 6;
	[self updateShadowMargin];
}

- (void)setMyShadowOffset:(CGSize)myShadowOffset
{
	_myShadowOffset = myShadowOffset;
	[self updateShadowMargin];
}

- (void)setMyBlur:(CGFloat)myBlur
{
	_myBlur = myBlur;
	[self updateShadowMargin];
}

- (void)updateShadowMargin
{
	CGFloat dx = _myShadowOffset.width + _myBlur;
	CGFloat dy = _myShadowOffset.height + _myBlur;
	_shadowMargin = UIEdgeInsetsMake(-dy, -dx, -dy, -dx);
}

- (void) drawTextInRect:(CGRect)rect
{
	CGFloat myColorValues[] = {0, 0, 0, 0.4};

	CGContextRef myContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(myContext);

	CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
	CGContextSetShadowWithColor(myContext, _myShadowOffset, _myBlur, myColor);

	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = self.textAlignment;// NSTextAlignmentNatural;
	NSDictionary *attributes = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: self.textColor};

	CGSize size = [self.text sizeWithAttributes:attributes];
	CGRect textRect;
	textRect.origin = CGPointMake(0, CGRectGetMidY(rect) - size.height/2);
	textRect.size = size;
	if (style.alignment == NSTextAlignmentRight) {
		textRect.origin.x = CGRectGetWidth(rect) + _shadowMargin.right - size.width;
	} else if (style.alignment == NSTextAlignmentCenter) {
		textRect.origin.x = CGRectGetMidX(rect) - size.width/2;
	}
	[self.text drawInRect:CGRectIntegral(textRect) withAttributes:attributes];

//	[super drawTextInRect:rect];

	CGColorRelease(myColor);
	CGColorSpaceRelease(myColorSpace);

	CGContextRestoreGState(myContext);
}

- (CGSize)sizeThatFits:(CGSize)size
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = [super sizeThatFits:size];

	return UIEdgeInsetsInsetRect(rect, self.shadowMargin).size;
}

@end
