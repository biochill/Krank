#import "Tools.h"
#import "Globals.h"
#import "UIColor_Custom.h"
//#import "ShadowLabel.h"
#import "KrankViewController.h"

@implementation Tools

+ (SKNode *)addLabelWithText:(NSString *)text rect:(CGRect)rect color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font
{
	SKNode *node = [self labelWithText:text rect:rect color:color anchor:anchor font:font];
	[k.viewController.scene.level addChild:node];
	return node;
}

+ (SKNode *)addLabelWithText:(NSString *)text pos:(CGPoint)pos color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font
{
	SKNode *node = [self labelWithText:text pos:pos color:color anchor:anchor font:font];
	[k.viewController.scene.level addChild:node];
	return node;
}

+ (SKNode *)labelWithText:(NSString *)text pos:(CGPoint)pos color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font
{
	return [self labelWithText:text rect:CGRectMake(pos.x, pos.y, 0, 0) color:color anchor:anchor font:font];
}

+ (SKNode *)labelWithText:(NSString *)text rect:(CGRect)rect color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font
{
	UIImage *image = [Tools labelImageWithText:text rect:rect color:color font:font];

	// New node
	SKTexture *texture = [SKTexture textureWithImage:image];
	SKSpriteNode *node = [[SKSpriteNode alloc] initWithTexture:texture];
	node.position = [k.world convertToScenePoint:rect.origin];
	
	// Anchor location
	if (anchor & ANCHOR_RIGHT) {
		//		node.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
		if (anchor & ANCHOR_TOP) {
			node.anchorPoint = CGPointMake(1, 1);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
		} else if (anchor & ANCHOR_BOTTOM) {
			node.anchorPoint = CGPointMake(1, 0);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
		} else {
			node.anchorPoint = CGPointMake(1, 0.5);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		}
	} else if (anchor & ANCHOR_LEFT) {
		//		node.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
		if (anchor & ANCHOR_TOP) {
			node.anchorPoint = CGPointMake(0, 1);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
		} else if (anchor & ANCHOR_BOTTOM) {
			node.anchorPoint = CGPointMake(0, 0);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
		} else {
			node.anchorPoint = CGPointMake(0, 0.5);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		}
	} else {
		// center
		//		node.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
		if (anchor & ANCHOR_TOP) {
			node.anchorPoint = CGPointMake(0.5, 1);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
		} else if (anchor & ANCHOR_BOTTOM) {
			node.anchorPoint = CGPointMake(0.5, 0);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
		} else {
			node.anchorPoint = CGPointMake(0.5, 0.5);
			//			node.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		}
	}
	
	return node;
}

+ (UIImage *)labelImageWithText:(NSString *)text rect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font
{
	//
	// Determine rect size
	//

	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.lineSpacing = ceil(font.lineHeight) - font.lineHeight;
	style.alignment = NSTextAlignmentNatural;
//	if (anchor & ANCHOR_CENTER) {
//		style.alignment = NSTextAlignmentCenter;
//	}
	NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName: style};

	CGSize myShadowOffset = font == k.largeFont ? CGSizeMake(3, 2) : CGSizeMake(2, 1);
	CGFloat myBlur = 4;
	CGFloat topMargin = fmaxf(myBlur - myShadowOffset.height, 0);
	CGFloat leftMargin = fmaxf(myBlur - myShadowOffset.width, 0);
	CGFloat bottomMargin = fmaxf(myBlur + myShadowOffset.height, 0);
	CGFloat rightMargin = fmaxf(myBlur + myShadowOffset.width, 0);
	
	CGRect textRect = CGRectMake(leftMargin, topMargin, 0, 0);

	if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
		textRect.size = [text sizeWithAttributes:attributes];
	} else {
		textRect.size = [text boundingRectWithSize:CGSizeMake(rect.size.width, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
	}
	textRect = CGRectIntegral(textRect);

	UIColor *gradient = [color verticalGradientColorWithHeight:ceil(font.lineHeight) dimFactor:0.5];

	//
	// Draw text with shadow into image
	//

	CGSize size = CGSizeMake(leftMargin + textRect.size.width + rightMargin, topMargin + textRect.size.height + bottomMargin);

	UIGraphicsBeginImageContextWithOptions(size, NO, 0);

	CGContextRef myContext = UIGraphicsGetCurrentContext();

	// Set shadow
	UIColor *shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
	CGContextSetShadowWithColor(myContext, myShadowOffset, myBlur, shadowColor.CGColor);

	// Draw text, and make sure the gradient starts in the text box
	CGContextSetPatternPhase(myContext, CGSizeMake(leftMargin, topMargin));
	attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: gradient};
	[text drawInRect:textRect withAttributes:attributes];

	// Make texture
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return image;
}

//+ (void)drawText_normal:(NSString *)text pos:(CGPoint)pos anchor:(NSInteger)anchor
//{
//	[k.viewController.gameView addSubview:[Tools labelWithText:text pos:pos color:[UIColor blackColor] anchor:anchor font:k.normalFont]];
//}
//
//+ (void)drawText_large:(NSString *)text pos:(CGPoint)pos
//{
//	[k.viewController.gameView addSubview:[Tools labelWithText:text pos:pos color:[UIColor blackColor] anchor:ANCHOR_TOP font:k.largeFont]];
//}
//

+ (UIImage *)makeLandscapeQuadImage:(UIImage *)sourceImage size:(CGSize)size alpha:(CGFloat)alpha
{
	// alpha is currently ignored

	CGFloat quadWidth = size.width / 2;
	CGFloat quadHeight = size.height / 2;
	CGPoint center = CGPointMake(quadWidth, quadHeight);

	UIGraphicsBeginImageContextWithOptions(size, YES, 0);
	CGContextRef bmContext = UIGraphicsGetCurrentContext();

//	CGInterpolationQuality q = CGContextGetInterpolationQuality(bmContext);
//	DLog(@"interpolation %d", q);

//	CGContextSetAllowsAntialiasing(bmContext, false);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationMedium);
//	CGContextSetAlpha(bmContext, alpha);

	CGContextSaveGState(bmContext);

	// left top image
	[sourceImage drawInRect:CGRectMake(0, 0, quadWidth, quadHeight)];

	// right top image
	CGContextTranslateCTM(bmContext, center.x + quadWidth, 0);
	CGContextScaleCTM(bmContext, -1, 1);
	[sourceImage drawInRect:CGRectMake(0, 0, quadWidth, quadHeight)];

	CGContextRestoreGState(bmContext);

	// left bottom image
	CGContextTranslateCTM(bmContext, 0, center.y + quadHeight);
	CGContextScaleCTM(bmContext, 1, -1);
	[sourceImage drawInRect:CGRectMake(0, 0, quadWidth, quadHeight)];
	
	// right bottom image
	CGContextTranslateCTM(bmContext, center.x + quadWidth, 0);
	CGContextScaleCTM(bmContext, -1, 1);
	[sourceImage drawInRect:CGRectMake(0, 0, quadWidth, quadHeight)];

	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return finalImage;
}

@end
