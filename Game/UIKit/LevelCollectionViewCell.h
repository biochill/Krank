//
//  LevelCollectionViewCell.h
//  Krank
//
//  Created by Sven Thoennissen on 30.11.15.
//
//

#import <UIKit/UIKit.h>

@interface LevelCollectionViewCell : UICollectionViewCell

@property NSInteger levelNumber;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelNumberView;
@property (weak, nonatomic) IBOutlet UIImageView *lockView;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@property (weak, nonatomic) IBOutlet UIImageView *bestTime3View;
@property (weak, nonatomic) IBOutlet UIImageView *bestTime2View;
@property (weak, nonatomic) IBOutlet UIImageView *bestTime1View;
@property (weak, nonatomic) IBOutlet UIImageView *bestScore3View;
@property (weak, nonatomic) IBOutlet UIImageView *bestScore2View;
@property (weak, nonatomic) IBOutlet UIImageView *bestScore1View;

@property (weak, nonatomic) IBOutlet UIImageView *time3Dot2View;
@property (weak, nonatomic) IBOutlet UIImageView *time3Dot1View;
@property (weak, nonatomic) IBOutlet UIImageView *time2DotView;
@property (weak, nonatomic) IBOutlet UIImageView *score3Dot1View;
@property (weak, nonatomic) IBOutlet UIImageView *score3Dot2View;
@property (weak, nonatomic) IBOutlet UIImageView *score2DotView;

- (void)updateContents;

@end
