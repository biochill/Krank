#import "Sound.h"
#import "Globals.h"
#import "Tools.h"
#import "Config.h"
#import "Level.h"
#import "World.h"

#import "SPAudioEngine.h"
#import "SPSoundChannel.h"

//#import "SoundFile.h"
//#import "SoundChannel.h"
//
//typedef SoundFile SPSound;
//typedef SoundChannel SPSoundChannel;
//
//NSString *const SPNotificationAudioInteruptionBegan     = @"SPNotificationAudioInteruptionBegan";
//NSString *const SPNotificationAudioInteruptionEnded     = @"SPNotificationAudioInteruptionEnded";
//static BOOL interrupted = NO;
//
//static void interruptionCallback (void *inUserData, UInt32 interruptionState)
//{
//	if (interruptionState == kAudioSessionBeginInterruption) {
//		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SPNotificationAudioInteruptionBegan object:nil]];
//		alcMakeContextCurrent(NULL);
//		AudioSessionSetActive(NO);
//		interrupted = YES;
//	}
//	else if (interruptionState == kAudioSessionEndInterruption) {
//		[SPAudioEngine endInterruption];
//	}
//}
//

@interface Sound ()
{
//	ALCdevice *_device;
//	ALCcontext *_context;

	NSMutableDictionary *audioData;
	NSMutableSet *soundChannels;
	SPSoundChannel *musicChannel;

	NSTimeInterval fadeDuration;
	float startVolume;
	NSDate *fadeStartTime;
//	SoundEventID eventAtStop;
	id eventChannel;
}
@end

@implementation Sound

- (id)init
{
	if ((self = [super init]))
	{
		audioData = [[NSMutableDictionary alloc] initWithCapacity:10];
		soundChannels = [[NSMutableSet alloc] initWithCapacity:10];
		_currentTheme = @"";
		fadeDuration = -1;
//		eventAtStop = 0;

//		[self setupOpenAL];
		[SPAudioEngine start];//:SPAudioSessionCategory_AmbientSound];
	}
	return self;
}

- (void)dealloc
{
	[SPAudioEngine stop];

	[[NSNotificationCenter defaultCenter] removeObserver:self];

//	alcMakeContextCurrent(NULL);
//	alcDestroyContext(_context);
//	alcCloseDevice(_device);
//	AudioSessionSetActive(NO);
}

- (void)reset
{
//	[self flushChannels];
}

//- (BOOL)setupOpenAL
//{
//	_device = alcOpenDevice(NULL);
//	if (!_device)
//	{
//		DLog(@"Could not open default OpenAL device");
//		return NO;
//	}
//	
//	_context = alcCreateContext(_device, 0);
//	if (!_context)
//	{
//		DLog(@"Could not create OpenAL context for default device");
//		return NO;
//	}
//	
//	BOOL success = alcMakeContextCurrent(_context);
//	if (!success)
//	{
//		DLog(@"Could not set current OpenAL context");
//		return NO;
//	}
//
//
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppActivated:)
//												 name:UIApplicationDidBecomeActiveNotification
//											   object:nil];
//
//
//	return YES;
//}

//------------------------------------------------------------------------------------------------------------------------

- (void)loadTheme:(NSString *)theme
{
	if ([theme isEqualToString:_currentTheme])
		return;

	_currentTheme = theme;

	[audioData removeAllObjects];

	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *path = [resourcePath stringByAppendingPathComponent:@"sounds"];
	path = [path stringByAppendingPathComponent:theme];
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	//DLog(@"Loading theme '%s', have %d files", [theme UTF8String], [files count]);

	for (NSString *file in files) {
		if ([[file pathExtension] compare:@"m4a" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			//DLog(@".. %@ (not loaded)", file);
			continue;
		}

		NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:file]];

		//DLog(@".. %@", file);
        SPSound *snd = [[SPSound alloc] initWithContentsOfFile:url.path];

		NSString *key = [[file lastPathComponent] stringByDeletingPathExtension];
		[audioData setObject:snd forKey:key];
	}
}

- (void)togglePause
{
	if (musicChannel) {
		if (musicChannel.isPlaying)
			[musicChannel pause];
		else
			[musicChannel play];
	}
}

- (void)music:(NSString *)musicName
{
	[musicChannel stop];
	musicChannel = nil;

	if (!self.musicEnabled || !musicName) return;

	fadeDuration = -1; // stop fading if any

	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *path = [resourcePath stringByAppendingPathComponent:@"sounds"];
	path = [path stringByAppendingPathComponent:_currentTheme];
	NSString *fullfile = [path stringByAppendingPathComponent:[musicName stringByAppendingPathExtension:@"m4a"]];
	SPSound *snd = [[SPSound alloc] initWithContentsOfFile:fullfile];
	musicChannel = [snd createChannel];
	musicChannel.loop = YES;
	[musicChannel play];
}

//------------------------------------------------------------------------------------------------------------------------

- (void)fadeMusic:(NSTimeInterval)duration
{
	if (musicChannel) {
		fadeDuration = duration;
		startVolume = musicChannel.volume;
		fadeStartTime = [NSDate date];
		//DLog(@"fading music with duration %f starting at volume %f", duration, startVolume);
	}
}

//------------------------------------------------------------------------------------------------------------------------

- (void)onFrame:(NSTimeInterval)delta
{
	if (musicChannel && (fadeDuration >= 0)) {
		if (musicChannel.volume > 0) {
			NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:fadeStartTime];
			//DLog(@"fading music: delta %f", diff);
			if (fadeDuration < 0.001) {
				[musicChannel stop];
				musicChannel = nil;
				//DLog(@"finished fading music");
			} else {
				musicChannel.volume = fclampf(startVolume * (1.0 - diff / fadeDuration), 0, startVolume);
			}
		} else {
			fadeDuration = -1;
		}
	}
}

//------------------------------------------------------------------------------------------------------------------------
/*
- (void)flushChannels
{
    // Remove all channels that have finished playing their sound

	NSMutableSet *removeChannels = [NSMutableSet setWithCapacity:10];
	for (SPSoundChannel *ch in soundChannels) {
		if (!ch.isPlaying) {
			[removeChannels addObject:ch];
		}
	}
//	if ([removeChannels count]) {
//		DLog(@"flushed %d of %d channels, %d left",
//			[removeChannels count], [soundChannels count], [soundChannels count] - [removeChannels count]);
//	}
	[soundChannels minusSet:removeChannels];
}
*/
//------------------------------------------------------------------------------------------------------------------------
// Sparrow sound callback
/*
- (void)onSoundCompleted:(SPEvent *)event
{
	//DLog(@"sound completed, target %p currentTarget %p", event.target, event.currentTarget);

	id channel = event.target;
    
	//DLog(@"sound completed, target %p currentTarget %p channel %@", event.target, event.currentTarget, channel);
   
	[soundChannels removeObject:channel];

	if (eventChannel && (eventChannel == channel)) {
		//DLog(@"processing sound completed event %d", eventAtStop);
		eventChannel = nil;
		switch (eventAtStop) {
		case SoundEventIDNextLevel:
			[k.level next];
			break;
		}
		eventAtStop = 0;
	}
}
*/
//------------------------------------------------------------------------------------------------------------------------

- (void)play:(NSString *)sound volume:(float)vol pos:(CGFloat)pos //event:(SoundEventID)event
{
	if (!self.soundFXEnabled) {
//		switch (eventAtStop) {
//			case SoundEventIDNextLevel:
//				[k.level next];
//				break;
//		}
//		eventAtStop = 0;
		return;
	}

	if (vol < 0.001) return; // prevent flooding the sound engine when particles touch very softly

	SPSound *snd = [audioData valueForKey:sound];
	if (!snd) {
		DLog(@"Could not find sound data: %@", sound);
		return;
	}

	// limit channels
//	if ([soundChannels count] > 8)
//		[self flushChannels];

	float pan = (pos / (k.world.rect.size.width/2)) - 1.0; // -1..+1
	[snd playWithVolume:vol pan:pan];

//	SPSoundChannel *ch = [snd createChannel];
//	if (ch) {
		//PrintLog(@"playing sound '%s' vol %f", [sound UTF8String], vol);

//		if (!eventAtStop && event) {
//			eventAtStop = event;
//			eventChannel = ch;
//			[ch addEventListener:@selector(onSoundCompleted:) atObject:self forType:SPEventTypeCompleted];
//		}

//		[soundChannels addObject:ch];

//		ch.volume = vol;// * _effectsVolume;
//		ch.pan = (pos / (k.world.rect.size.width/2)) - 1.0; // -1..+1
//		[ch play];

//	} else {
//		DLog(@"Could not create sound channel for sound '%@'", sound);
//	}
}

//- (void)play:(NSString *)sound volume:(float)vol pos:(CGFloat)pos
//{
//	[self play:sound volume:vol pos:pos event:0];
//}

- (void)play:(NSString *)sound volume:(float)vol
{
	[self play:sound volume:vol pos:k.world.center.x];
}

- (void)play:(NSString *)sound
{
	[self play:sound volume:1 pos:k.world.center.x];
}

//- (void)play:(NSString *)sound event:(int)event
//{
//	[self play:sound volume:1 pos:k.world.center.x event:event];
//}

//------------------------------------------------------------------------------------------------------------------------

- (void)setMusicEnabled:(BOOL)musicEnabled
{
	[[NSUserDefaults standardUserDefaults] setBool:musicEnabled forKey:kConfigMusicEnabled];

	if (musicEnabled) {
		[self music:@"industry"]; // play music from options menu
	} else {
		[musicChannel stop];
		musicChannel = nil;
	}
}

- (BOOL)musicEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kConfigMusicEnabled];
}

- (void)setSoundFXEnabled:(BOOL)soundFXEnabled
{
	[[NSUserDefaults standardUserDefaults] setBool:soundFXEnabled forKey:kConfigSoundFXEnabled];
}

- (BOOL)soundFXEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kConfigSoundFXEnabled];
}


/*
- (NSInteger)musicVolumeIndex
{
	return _musicVolume * 5;
}

- (void)setMusicVolumeIndex:(NSInteger)volumeIndex
{
	if (_musicVolume == 0 && volumeIndex > 0)
	{
		// start sound screen music if it was disabled
		_musicVolume = volumeIndex * 0.2f;
		[self music:@"industry"];
	} else {
		_musicVolume = volumeIndex * 0.2f;
	}

	musicChannel.volume = _musicVolume;
	[k.config setDouble:_musicVolume forKey:@"music_volume"];
	[k.sound play:@"part"];
}
*/
//------------------------------------------------------------------------------------------------------------------------
/*
- (NSInteger)effectsVolumeIndex
{
	return _effectsVolume * 5;
}

- (void)setEffectsVolumeIndex:(NSInteger)volumeIndex
{
	_effectsVolume = volumeIndex*0.2f;
	[k.config setDouble:_effectsVolume forKey:@"effects_volume"];
	[k.sound play:@"part"];
}
*/
@end
