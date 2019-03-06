#import <Foundation/Foundation.h>


extern NSString *const KrankBestStatChangedNotification;

extern NSString *const kConfigMusicEnabled;
extern NSString *const kConfigSoundFXEnabled;
extern NSString *const kConfigMotionEnabled;
extern NSString *const kConfigTargetEnabled;
extern NSString *const kConfigFingerOffsetEnabled;
extern NSString *const kConfigStage;
extern NSString *const kConfigCurrentLevelNumber;


@interface Config : NSObject

@property (nonatomic) NSInteger stage;

//- (NSTimeInterval)stageTime:(NSInteger)stage;
//- (NSInteger)stageSolved:(NSInteger)stage;
- (void)score:(NSInteger)level;

- (NSInteger)bestScore:(NSInteger)level;
- (NSInteger)bestScore:(NSInteger)level stage:(NSInteger)stage;

- (NSTimeInterval)bestTime:(NSInteger)level;
- (NSTimeInterval)bestTime:(NSInteger)level stage:(NSInteger)stage;

- (NSInteger)highestAvailableLevel;

- (void)command:(NSString *)cmd;

@end
