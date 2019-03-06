//
//  UIApplication+Custom.h
//  Krank
//
//  Created by Sven Thoennissen on 06.03.19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Custom)

- (BOOL)openURLSafely:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
