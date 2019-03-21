//
//  PauseViewController.h
//  Krank
//
//  Created by Sven Thoennissen on 10.03.19.
//

@import UIKit;

#import "DLog.h"

@class CockpitButton;

NS_ASSUME_NONNULL_BEGIN

@interface PauseViewController : UIViewController

@property (weak, nonatomic) IBOutlet CockpitButton *exitButton;
@property (weak, nonatomic) IBOutlet CockpitButton *resetButton;
@property (weak, nonatomic) IBOutlet CockpitButton *continueButton;
@property (weak, nonatomic) IBOutlet UIImageView *currentLevelView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

+ (UIImage *)makeCurrentLevelImage;
+ (NSString *)currentLevelText;

- (void)animateIn:(ActionHandler _Nullable)completion;
- (void)animateOut:(ActionHandler _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
