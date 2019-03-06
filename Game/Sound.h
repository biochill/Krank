#import <Foundation/Foundation.h>

//enum {
//	SoundEventIDNextLevel = 1
//};
//typedef NSInteger SoundEventID;


@interface Sound : NSObject

- (void)reset;
- (void)onFrame:(NSTimeInterval)delta;
- (void)loadTheme:(NSString *)theme;
- (void)music:(NSString *)musicName;
- (void)togglePause;
- (void)pause;
- (void)resume;
- (void)fadeMusic:(NSTimeInterval)duration;
- (void)play:(NSString *)sound volume:(float)vol pos:(CGFloat)pos;
- (void)play:(NSString *)sound volume:(float)vol;
- (void)play:(NSString *)sound;

@property (nonatomic) BOOL musicEnabled;
@property (nonatomic) BOOL soundFXEnabled;
@property (nonatomic, strong) NSString *currentTheme;

@end
