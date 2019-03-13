//
//  FocusButton.h
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import <UIKit/UIKit.h>

extern const CGFloat FocusScale;

@interface FocusButton : UIButton

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
