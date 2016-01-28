//
//  CockpitButton.m
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import "CockpitButton.h"
#import "CockpitLabel.h"
#import "Globals.h"
#import "UIColor_Custom.h"

@implementation CockpitButton

+ (instancetype)buttonWithText:(NSString *)text
{
	UIImage *normalImage = [CockpitLabel makeFancyTextImage:text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:240 textColor:[UIColor whiteColor]];

	UIColor *orange = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:1];
	UIImage *highlightedImage = [CockpitLabel makeFancyTextImage:text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:240 textColor:orange];

	CockpitButton *button = [CockpitButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:button action:@selector(buttonPressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
	[button setImage:normalImage forState:UIControlStateNormal];
	[button setImage:highlightedImage forState:UIControlStateHighlighted];
	[button sizeToFit];

	return button;
}

- (void)buttonPressed:(id)sender
{
	if (self.handler) {
		self.handler();
	}
}

@end
