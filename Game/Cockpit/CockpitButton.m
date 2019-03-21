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

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ text='%@'>", NSStringFromClass(self.class), self.text];
}

- (void)setupButton
{
	UIImage *normalImage = [CockpitLabel makeFancyTextButtonImage:self.text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:240 textColor:[UIColor whiteColor]];

	UIColor *orange = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:1];
	UIImage *highlightedImage = [CockpitLabel makeFancyTextButtonImage:self.text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:240 textColor:orange];

	[self setImage:normalImage forState:UIControlStateNormal];
	[self setImage:highlightedImage forState:UIControlStateHighlighted];
	[self setImage:highlightedImage forState:UIControlStateFocused];

	[self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventPrimaryActionTriggered];

	[self sizeToFit];
}

- (void)buttonPressed:(id)sender
{
	if (self.handler) {
		self.handler();
	}
}

@end
