//
//  Toggle.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Switch.h"

@interface Toggle : Switch

@property (nonatomic, strong) NSString *option;

- (id)initWithText:(NSString *)text anchor:(NSInteger)anchor option:(NSString *)option position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName;

@end
