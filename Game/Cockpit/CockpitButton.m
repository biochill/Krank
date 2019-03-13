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
	CockpitButton *button = [CockpitButton buttonWithType:UIButtonTypeCustom];

	button.text = text;

	return button;
}

- (void)setText:(NSString *)text
{
	_text = text;
	[self setupButton];
}

- (void)setupButton
{
	UIImage *normalImage = [CockpitLabel makeFancyTextImage:self.text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:240 textColor:[UIColor whiteColor]];

	UIColor *orange = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:1];
	UIImage *highlightedImage = [CockpitLabel makeFancyTextImage:self.text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:240 textColor:orange];

	[self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
	[self setImage:normalImage forState:UIControlStateNormal];
	[self setImage:highlightedImage forState:UIControlStateHighlighted];

	[self sizeToFit];
}

- (void)buttonPressed:(id)sender
{
	if (self.handler) {
		self.handler();
	}
}

@end
