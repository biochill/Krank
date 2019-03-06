#import "Config.h"
#import "Globals.h"


NSString *const KrankBestStatChangedNotification = @"KrankBestStatChangedNotification";


NSString *const kConfigMusicEnabled = @"music";
NSString *const kConfigSoundFXEnabled = @"soundfx";
NSString *const kConfigMotionEnabled = @"input_accel";
NSString *const kConfigTargetEnabled = @"input_target";
NSString *const kConfigFingerOffsetEnabled = @"input_offset";
NSString *const kConfigStage = @"stage";
NSString *const kConfigCurrentLevelNumber = @"current_level";


@interface Config ()
@property (nonatomic, readonly) NSInteger extraLevelsAvailable;
@end


@implementation Config

- (id)init
{
	if ((self = [super init])) {

		[[NSUserDefaults standardUserDefaults] registerDefaults:@{
			kConfigMusicEnabled: @YES,
			kConfigSoundFXEnabled: @YES,
#if !TARGET_OS_TV
			kConfigMotionEnabled: @NO,
			kConfigFingerOffsetEnabled: @YES,
#endif
			kConfigTargetEnabled: @NO,
			kConfigStage: @1,
			kConfigCurrentLevelNumber: @1
		}];

		_stage = [[NSUserDefaults standardUserDefaults] integerForKey:kConfigStage];
		_extraLevelsAvailable = 2;

		//
		// Load scores from iCloud
		//
		[self loadiCloudScores];

		//
		// Notifications
		//
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedKeyValueChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - iCloud

- (void)loadiCloudScores
{
	// Synchronize iCloud scores with local scores

	[[NSUbiquitousKeyValueStore defaultStore] synchronize];

	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

	for (int stage = 1; stage <= 3; ++stage) {
		for (int level = 1; level <= k.maxLevel; ++level) {

			NSString *key = [NSString stringWithFormat:@"levelscore_%d_%d", stage, level];
			NSNumber *serverObject = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
			if (serverObject) {
				[def setObject:serverObject forKey:key];
//				DLog(@"\t%@ = %@", key, serverObject);
			} else {
				[def removeObjectForKey:key];
			}

			key = [NSString stringWithFormat:@"leveltime_%d_%d", stage, level];
			serverObject = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
			if (serverObject) {
				[def setObject:serverObject forKey:key];
//				DLog(@"\t%@ = %@", key, serverObject);
			} else {
				[def removeObjectForKey:key];
			}

		}
	}

	[def synchronize];
}

- (void)receivedKeyValueChange:(NSNotification *)notification
{
	NSDictionary *userInfo = notification.userInfo;
	if (userInfo) {

		NSNumber *reason = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey];
		if (reason) {
			DLog(@"%s reason=%d", __PRETTY_FUNCTION__, reason.intValue);
		}

		NSArray *keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey];
		if (keys) {

			if (reason && reason.intValue == NSUbiquitousKeyValueStoreAccountChange) {
				// Changed iCloud account! -> overwrite local kvs

				for (NSString *key in keys) {

					NSNumber *serverObject = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
					DLog(@"iCloud key changed (account change): %@ = %@", key, serverObject);

					if (serverObject) {
						[[NSUserDefaults standardUserDefaults] setObject:serverObject forKey:key];
					} else {
						[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
					}
				}

				// Post notification to tell observers that everything has changed (with a nil object)
				[[NSNotificationCenter defaultCenter] postNotificationName:KrankBestStatChangedNotification object:nil];

			} else {
				// Use better score and time, keep local kvs

				for (NSString *key in keys) {

					NSNumber *serverObject = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
					NSNumber *localObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];

					DLog(@"iCloud key changed: %@ = %@", key, serverObject);

					if ([key hasPrefix:@"levelscore"]) {

						NSInteger serverValue = serverObject.integerValue;
						NSInteger localValue = localObject.integerValue;
						if (serverObject && localObject && serverValue < localValue) {
							// Correct server value
							[[NSUbiquitousKeyValueStore defaultStore] setObject:localObject forKey:key];
						} else {
							if (serverObject) {
								[[NSUserDefaults standardUserDefaults] setObject:serverObject forKey:key];
							} else {
								[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
							}

							NSArray *parts = [key componentsSeparatedByString:@"_"];
							if (parts.count == 3) {
								NSDictionary *dict = @{@"stage":@([parts[1] intValue]), @"level":@([parts[2] intValue])};
								[[NSNotificationCenter defaultCenter] postNotificationName:KrankBestStatChangedNotification object:@"score" userInfo:dict];
							}
						}

					} else if ([key hasPrefix:@"leveltime"]) {

						NSTimeInterval serverValue = serverObject.doubleValue;
						NSTimeInterval localValue = localObject.doubleValue;
						if (serverObject && localObject && localValue < serverValue) {
							// Correct server value
							[[NSUbiquitousKeyValueStore defaultStore] setObject:localObject forKey:key];
						} else {
							if (serverObject) {
								[[NSUserDefaults standardUserDefaults] setObject:serverObject forKey:key];
							} else {
								[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
							}

							NSArray *parts = [key componentsSeparatedByString:@"_"];
							if (parts.count == 3) {
								NSDictionary *dict = @{@"stage":@([parts[1] intValue]), @"level":@([parts[2] intValue])};
								[[NSNotificationCenter defaultCenter] postNotificationName:KrankBestStatChangedNotification object:@"time" userInfo:dict];
							}
						}
					}

				} // for keys

			} // reason

			[[NSUserDefaults standardUserDefaults] synchronize];

		} // have keys
	} // userInfo
}

- (void)command:(NSString *)cmd
{
	if ([cmd hasPrefix:kConfigSoundFXEnabled]) {
		k.sound.soundFXEnabled = [[[cmd componentsSeparatedByString:@" "] objectAtIndex:1] boolValue];
	} else if ([cmd hasPrefix:kConfigMusicEnabled]) {
		k.sound.musicEnabled = [[[cmd componentsSeparatedByString:@" "] objectAtIndex:1] boolValue];
	} else if ([cmd hasPrefix:kConfigTargetEnabled]) {
		k.input.targetDisplayEnabled = [[[cmd componentsSeparatedByString:@" "] objectAtIndex:1] boolValue];
#if !TARGET_OS_TV
	} else if ([cmd hasPrefix:kConfigMotionEnabled]) {
		k.input.accelerometerEnabled = [[[cmd componentsSeparatedByString:@" "] objectAtIndex:1] boolValue];
	} else if ([cmd hasPrefix:kConfigFingerOffsetEnabled]) {
		k.input.fingerOffsetEnabled = [[[cmd componentsSeparatedByString:@" "] objectAtIndex:1] boolValue];
#endif
	}
}

//------------------------------------------------------------------------------------------------------------------------

- (void)score:(NSInteger)level
{
	NSTimeInterval secs = k.level.time;

	//DLog(@"Config score: level %d score: %d time: %f", level, k.score, secs);

	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

//	double totaltime = [def doubleForKey:@"totaltime"];
//	[def setDouble:totaltime + secs forKey:@"totaltime"];

//	NSTimeInterval stagetime = [def doubleForKey:[NSString stringWithFormat:@"stagetime%ld", (long)_stage]];
//	[def setDouble:stagetime + secs forKey:[NSString stringWithFormat:@"stagetime%ld", (long)_stage]];

//	NSInteger stagesolved = [def integerForKey:[NSString stringWithFormat:@"stagesolved%ld", (long)_stage]];
//	[def setInteger:++stagesolved forKey:[NSString stringWithFormat:@"stagesolved%ld", (long)_stage]];

	NSString *timeKey = [NSString stringWithFormat:@"leveltime_%d_%d", (int)_stage, (int)level];
	NSTimeInterval leveltime = [def doubleForKey:timeKey];
	if (leveltime == 0 || secs < leveltime)
	{
		//DLog(@"Config score: setting new time score: %f", secs);
		[def setDouble:secs forKey:timeKey];
		[[NSUbiquitousKeyValueStore defaultStore] setDouble:secs forKey:timeKey];
	}
	else
	{
		//DLog(@"Config score: time score not reached: %f", leveltime);
	}

	NSString *scoreKey = [NSString stringWithFormat:@"levelscore_%d_%d", (int)_stage, (int)level];
	NSInteger levelscore = [def integerForKey:scoreKey];
	if (levelscore == 0 || k.score > levelscore)
	{
		//DLog(@"Config score: setting new level score: %d", k.score);
		[def setInteger:k.score forKey:scoreKey];
		[[NSUbiquitousKeyValueStore defaultStore] setLongLong:k.score forKey:scoreKey];
	}
	else
	{
		//DLog(@"Config score: level score not reached: %d", levelscore);
	}

	[def synchronize];
}

//------------------------------------------------------------------------------------------------------------------------

//- (double)totalTime
//{
//    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"totaltime"];
//}
//
//- (double)stageTime:(NSInteger)stageValue
//{
//    return [[NSUserDefaults standardUserDefaults] doubleForKey:[NSString stringWithFormat:@"stagetime%ld", (long)stageValue]];
//}
//
//- (NSInteger)stageSolved:(NSInteger)stageValue
//{
//    DLog(@"Config stageSolved: %ld", (long)stageValue);
//    return [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"stagesolved%ld", (long)stageValue]];
//}

- (NSInteger)bestScore:(NSInteger)level
{
	return [self bestScore:level stage:_stage];
}

- (NSInteger)bestScore:(NSInteger)level stage:(NSInteger)stage
{
	NSString *scoreKey = [NSString stringWithFormat:@"levelscore_%d_%d", (int)stage, (int)level];
	return [[NSUserDefaults standardUserDefaults] integerForKey:scoreKey];
}

- (NSTimeInterval)bestTime:(NSInteger)level
{
	return [self bestTime:level stage:_stage];
}

- (NSTimeInterval)bestTime:(NSInteger)level stage:(NSInteger)stage
{
	NSString *timeKey = [NSString stringWithFormat:@"leveltime_%d_%d", (int)stage, (int)level];
	return [[NSUserDefaults standardUserDefaults] doubleForKey:timeKey];
}

//------------------------------------------------------------------------------------------------------------------------

- (void)setStage:(NSInteger)stage
{
	if (_stage != stage)
    {
		_stage = stage;
		[[NSUserDefaults standardUserDefaults] setInteger:_stage forKey:kConfigStage];
//		[k.level menuExit:@"menu_levels"];
	}
}

//------------------------------------------------------------------------------------------------------------------------

- (NSInteger)highestSolvedLevelForStage:(NSInteger)stage
{
#if HAVE_ALL_LEVELS
	return k.maxLevel;
#else
	for (NSInteger level = k.maxLevel; level >= 1; --level) {
		NSString *scoreKey = [NSString stringWithFormat:@"levelscore_%d_%d", (int)stage, (int)level];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:scoreKey]) {
			return level;
		}
	}
	return 0;
#endif
}

- (NSInteger)highestAvailableLevel
{
	if (self.stage == 1) {
		NSInteger highest = [self highestSolvedLevelForStage:1] + self.extraLevelsAvailable;
		return minl(highest, k.maxLevel);
	}
	if (self.stage == 2) {
		return [self highestSolvedLevelForStage:1];
	}
	if (self.stage == 3) {
		return [self highestSolvedLevelForStage:2];
	}
	return 0;
}

@end
