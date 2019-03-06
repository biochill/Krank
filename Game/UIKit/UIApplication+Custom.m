//
//  UIApplication+Custom.m
//  Krank
//
//  Created by Sven Thoennissen on 06.03.19.
//

#import "UIApplication+Custom.h"

@implementation UIApplication (Custom)

/*
 @discardableResult func openURLSafely(_ urlString: String) -> Bool {
 guard let url = URL(string: urlString) else { return false }
 guard self.canOpenURL(url) else { return false }
 if #available(iOS 10.0, *) {
 self.open(url)
 } else {
 // Fallback on earlier versions
 self.openURL(url)
 }
 return true
 }
 */

- (BOOL)openURLSafely:(NSString *)urlString
{
	NSURL *url = [NSURL URLWithString:urlString];
	if (!url) return NO;
	if (![self canOpenURL:url]) return NO;

	if (@available(iOS 10, *)) {
		// Use iOS 10 APIs.
		[self openURL:url options:@{} completionHandler:nil];
	} else {
		// Alternative code for earlier versions of iOS.
		[self openURL:url];
	}
	return YES;
}

@end
