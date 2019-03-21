//
//  CockpitLabel.h
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//

#import <UIKit/UIKit.h>
#import "Sprite.h"

@interface CockpitLabel : SKSpriteNode

@property (nonatomic, strong) NSString *text;
//@property (nonatomic) double dim;

- (id)initWithColor:(UIColor *)color font:(UIFont *)font textWidth:(CGFloat)textWidth alignment:(NSTextAlignment)alignment;

//+ (UIImage *)makeFancyText:(NSString *)text font:(UIFont *)font;
//+ (UIImage *)makeFancyText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;

+ (UIImage *)makeFancyTextButtonImage:(NSString *)text font:(UIFont *)font alignment:(NSTextAlignment)alignment textWidth:(CGFloat)textWidth textColor:(UIColor *)textColor;

@end
