//
//  ShadowLabel.h
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import <UIKit/UIKit.h>

// This class creates a blurred shadow below the UILabel.
// UILabel itself only supports shadows with hard edges.


@interface ShadowLabel : UILabel

// Add this property to the frame of the label when using -sizeToFit.
@property (nonatomic, readonly) UIEdgeInsets shadowMargin;

@property (nonatomic) CGSize myShadowOffset;
@property (nonatomic) CGFloat myBlur;

@end
