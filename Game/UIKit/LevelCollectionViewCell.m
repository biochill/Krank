//
//  LevelCollectionViewCell.m
//  Krank
//
//  Created by Sven Thoennissen on 30.11.15.
//
//

#import "LevelCollectionViewCell.h"
#import "Tools.h"
#import "Globals.h"
#import "UIColor_Custom.h"
#import "CockpitLabel.h"

@interface LevelCollectionViewCell ()
@property (nonatomic) NSInteger currentLevelNumber, currentStage;
@property (nonatomic) NSInteger currentScore1, currentScore2, currentScore3;
@property (nonatomic) NSTimeInterval currentTime1, currentTime2, currentTime3;
@end

@implementation LevelCollectionViewCell

- (void)updateContents
{
	NSInteger myLevel = self.levelNumber;
	NSInteger stage = k.config.stage;

	if (_currentLevelNumber != myLevel || _currentStage != stage) {

		// invalidate
		_currentScore1 = -1;
		_currentScore2 = -1;
		_currentScore3 = -1;
		_currentTime1 = -1;
		_currentTime2 = -1;
		_currentTime3 = -1;


		// Load images in background queue
		self.imageView.image = nil;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			if (myLevel == self.levelNumber) {
				UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"level%03d-%d", (int)myLevel, (int)stage]];
				dispatch_async(dispatch_get_main_queue(), ^{
					// Verify level number, because it may happen that this cell is reused, and we want to prevent that the old image is used over the new one.
					if (myLevel == self.levelNumber) {
						self.imageView.image = image;
					}
				});
			}
		});

#if !TARGET_OS_TV
		self.imageView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
		self.imageView.layer.shadowOffset = CGSizeMake(4, 4);
		self.imageView.layer.shadowRadius = 8;
		self.imageView.layer.shadowOpacity = 1.0;
#endif

		// Level number
		NSString *text = [NSString stringWithFormat:@"%d", (int)myLevel];
		self.levelNumberView.image = [CockpitLabel makeFancyTextButtonImage:text font:k.hugeCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:[UIColor whiteColor]];

		_currentLevelNumber = myLevel;
		_currentStage = stage;
	}

	if (myLevel <= [k.config highestAvailableLevel]) {

		UIColor *orange = [UIColor colorWithRed:1 green:0.7 blue:0 alpha:1];
		UIColor *white = [UIColor whiteColor];

		//
		// Best times
		//
		NSTimeInterval bestTime1 = [k.config bestTime:myLevel stage:1];
		NSTimeInterval bestTime2 = [k.config bestTime:myLevel stage:2];
		NSTimeInterval bestTime3 = [k.config bestTime:myLevel stage:3];

		if (_currentTime1 != bestTime1) {
			_currentTime1 = bestTime1;
			if (bestTime1 != 0) {
				NSString *text = [Level timeString:bestTime1 compact:YES];
				self.bestTime1View.image = [CockpitLabel makeFancyTextButtonImage:text font:k.smallCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:k.config.stage == 1 ? orange : white];
				self.bestTime1View.superview.hidden = NO;
			} else {
				self.bestTime1View.superview.hidden = YES;
			}
		}

		if (_currentTime2 != bestTime2) {
			_currentTime2 = bestTime2;
			if (bestTime2 != 0) {
				NSString *text = [Level timeString:bestTime2 compact:YES];
				self.bestTime2View.image = [CockpitLabel makeFancyTextButtonImage:text font:k.smallCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:k.config.stage == 2 ? orange : white];
				self.bestTime2View.superview.hidden = NO;
				self.time2DotView.image = [UIImage imageNamed:k.config.stage == 2 ? @"dot20_d_orange" : @"dot20_d_white"];
			} else {
				self.bestTime2View.superview.hidden = YES;
			}
		}

		if (_currentTime3 != bestTime3) {
			_currentTime3 = bestTime3;
			if (bestTime3 != 0) {
				NSString *text = [Level timeString:bestTime3 compact:YES];
				self.bestTime3View.image = [CockpitLabel makeFancyTextButtonImage:text font:k.smallCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:k.config.stage == 3 ? orange : white];
				self.bestTime3View.superview.hidden = NO;
				self.time3Dot1View.image = [UIImage imageNamed:k.config.stage == 3 ? @"dot20_d_orange" : @"dot20_d_white"];
				self.time3Dot2View.image = self.time3Dot1View.image;
			} else {
				self.bestTime3View.superview.hidden = YES;
			}
		}

		//
		// Best scores
		//
		NSInteger bestScore1 = [k.config bestScore:myLevel stage:1];
		NSInteger bestScore2 = [k.config bestScore:myLevel stage:2];
		NSInteger bestScore3 = [k.config bestScore:myLevel stage:3];

		if (_currentScore1 != bestScore1) {
			_currentScore1 = bestScore1;
			if (bestScore1 != 0) {
				NSString *text = [NSString stringWithFormat:@"%d", (int)bestScore1];
				self.bestScore1View.image = [CockpitLabel makeFancyTextButtonImage:text font:k.smallCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:k.config.stage == 1 ? orange : white];
				self.bestScore1View.superview.hidden = NO;
			} else {
				self.bestScore1View.superview.hidden = YES;
			}
		}

		if (_currentScore2 != bestScore2) {
			_currentScore2 = bestScore2;
			if (bestScore2 != 0) {
				NSString *text = [NSString stringWithFormat:@"%d", (int)bestScore2];
				self.bestScore2View.image = [CockpitLabel makeFancyTextButtonImage:text font:k.smallCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:k.config.stage == 2 ? orange : white];
				self.bestScore2View.superview.hidden = NO;
				self.score2DotView.image = [UIImage imageNamed:k.config.stage == 2 ? @"dot20_d_orange" : @"dot20_d_white"];
			} else {
				self.bestScore2View.superview.hidden = YES;
			}
		}

		if (_currentScore3 != bestScore3) {
			_currentScore3 = bestScore3;
			if (bestScore3 != 0) {
				NSString *text = [NSString stringWithFormat:@"%d", (int)bestScore3];
				self.bestScore3View.image = [CockpitLabel makeFancyTextButtonImage:text font:k.smallCockpitFont alignment:NSTextAlignmentCenter textWidth:0 textColor:k.config.stage == 3 ? orange : white];
				self.bestScore3View.superview.hidden = NO;
				self.score3Dot1View.image = [UIImage imageNamed:k.config.stage == 3 ? @"dot20_d_orange" : @"dot20_d_white"];
				self.score3Dot2View.image = self.score3Dot1View.image;
			} else {
				self.bestScore3View.superview.hidden = YES;
			}
		}

		self.dimView.hidden = YES;

	} else {

		self.dimView.hidden = NO;

		self.bestTime1View.superview.hidden = YES;
		self.bestTime2View.superview.hidden = YES;
		self.bestTime3View.superview.hidden = YES;
		self.bestScore1View.superview.hidden = YES;
		self.bestScore2View.superview.hidden = YES;
		self.bestScore3View.superview.hidden = YES;
	}
}

- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments
{
	return @[self.contentView];
}

@end
