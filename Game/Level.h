#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, strong) NSString *currentLevelName;
@property (nonatomic) NSInteger currentLevelNumber; // 0 if not a game level
@property (nonatomic, readonly) NSTimeInterval time;
@property (nonatomic, readonly) BOOL paused;
@property (nonatomic) BOOL inTransition;
@property (nonatomic, strong) NSString *nextMusicName;
@property (nonatomic) BOOL musicContinues;

+ (NSString *)timeString:(NSTimeInterval)interval compact:(BOOL)compact;
- (NSString *)timeString;
- (void)menu;
- (void)menuExit:(NSString *)menu_level;
- (void)reset;
- (void)next;
- (void)prev;
- (void)back;
- (void)onFrame:(NSTimeInterval)delta;
- (BOOL)checkExit;
- (void)startLevel:(NSString *)levelName;
- (void)command:(NSString *)cmd;
- (void)togglePause;

@end
