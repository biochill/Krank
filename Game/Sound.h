@import Foundation;
@import CoreGraphics;


extern NSString *SoundFocusIdentifierMenuPart;


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
- (void)playMenuButtonSound;

@property (nonatomic) BOOL musicEnabled;
@property (nonatomic) BOOL soundFXEnabled;
@property (nonatomic, strong) NSString *currentTheme;

@end
