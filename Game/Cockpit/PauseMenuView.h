//
//  PauseMenuView.h
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//
//

#import <UIKit/UIKit.h>
#import "CockpitButton.h"

@interface PauseMenuView : UIView

@property (nonatomic, strong) CockpitButton *continueButton;
@property (nonatomic, strong) CockpitButton *resetButton;
@property (nonatomic, strong) CockpitButton *exitButton;
@property (nonatomic, strong) UIImageView *currentLevelView;

- (void)presentWithCompletion:(ActionHandler)completion;
- (void)dismissAnimated:(BOOL)animated completion:(ActionHandler)completion;
- (void)setupCurrentLevelView;

@end
