//
//  MenuButton.h
//  Krank
//
//  Created by Sven Thoennissen on 04.12.15.
//
//

#import <UIKit/UIKit.h>

@interface MenuButton : UIButton

@property (nonatomic) CGFloat focusScale;
@property (nonatomic, strong) NSString *option;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
