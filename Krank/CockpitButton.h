//
//  CockpitButton.h
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//

@import UIKit;

#import "MenuButton.h"

@interface CockpitButton : MenuButton

@property (nonatomic, copy) ActionHandler handler;

+ (instancetype)buttonWithText:(NSString *)aText;

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
