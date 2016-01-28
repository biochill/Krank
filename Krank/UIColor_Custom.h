//
//  UIColor+UIColor_Custom.h
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_Custom)

- (UIColor *)multiply:(CGFloat)f;
- (UIColor *)verticalGradientColorWithHeight:(CGFloat)height dimFactor:(CGFloat)dim;
//- (UIColor *)verticalGlassEdgeColorWithHeight:(CGFloat)height;// dimFactor:(CGFloat)dim;

@end
