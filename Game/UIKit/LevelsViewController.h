//
//  LevelsViewController.h
//  Krank
//
//  Created by Sven Thoennissen on 30.11.15.
//
//

#import <UIKit/UIKit.h>

@class MenuButton;

@interface LevelsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MenuButton *easyButton;
@property (weak, nonatomic) IBOutlet MenuButton *hardButton;
@property (weak, nonatomic) IBOutlet MenuButton *extremeButton;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet MenuButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UIImageView *easyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *extremeImageView;
@property (weak, nonatomic) IBOutlet UILabel *easyLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardLabel;
@property (weak, nonatomic) IBOutlet UILabel *extremeLabel;

@end
