//
//  FocusButton.h
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import <UIKit/UIKit.h>

@interface FocusButton : UIButton

@property (nonatomic) CGFloat focusScale;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
