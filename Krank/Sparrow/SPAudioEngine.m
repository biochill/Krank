//
//  SPAudioEngine.m
//  Sparrow
//
//  Created by Daniel Sperl on 14.11.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

//
// 17.12.2015 Modified by Sven Thoennissen
// Support for tvOS 9.0 and ARC, separated audio classes, support for AIFF.
//

#import "SPAudioEngine.h"

static SPAudioEngine *globalAudioEngine;

// --- notifications -------------------------------------------------------------------------------

//NSString *const SPNotificationMasterVolumeChanged       = @"SPNotificationMasterVolumeChanged";
NSString *const SPNotificationAudioInteruptionBegan     = @"SPNotificationAudioInteruptionBegan";
NSString *const SPNotificationAudioInteruptionEnded     = @"SPNotificationAudioInteruptionEnded";

// --- private interaface --------------------------------------------------------------------------

@interface SPAudioEngine ()
{
	ALCdevice *device;
	ALCcontext *context;
//	float masterVolume;
	BOOL interrupted;
	BOOL sessionInitialized;
}
//+ (BOOL)initAudioSession:(SPAudioSessionCategory)category;
//+ (BOOL)initOpenAL;
//
//+ (void)beginInterruption;
//+ (void)endInterruption;
//+ (void)onAppActivated:(NSNotification *)notification;
//+ (void)postNotification:(NSString *)name object:(id)object;

@end


// --- class implementation ------------------------------------------------------------------------

@implementation SPAudioEngine

// --- C functions ---

//static void interruptionCallback (void *inUserData, UInt32 interruptionState) 
//{   
//    if (interruptionState == kAudioSessionBeginInterruption)  
//        [SPAudioEngine beginInterruption]; 
//    else if (interruptionState == kAudioSessionEndInterruption)
//        [SPAudioEngine endInterruption];
//} 

// --- static members ---

#pragma mark Initialization

- (BOOL)initAudioSession
{
    if (!sessionInitialized)
    {
		NSError *error;

		// Allow background music to continue - maybe the user wants to listen to his own music?
		if ([[[AVAudioSession sharedInstance] availableCategories] containsObject:AVAudioSessionCategoryAmbient]) {
			if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error]) {
				DLog(@"Could not set audio category: %@", error);
			}
		}

		if (![[AVAudioSession sharedInstance] setActive:YES error:&error]) {
			DLog(@"Could not activate audio session: %@", error);
			return NO;
        }

        sessionInitialized = YES;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterruptedNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    }

    return YES;
}

- (void)audioInterruptedNotification:(NSNotification *)notification
{
	NSNumber *typeValue = notification.userInfo[AVAudioSessionInterruptionTypeKey];
	if (typeValue) {
		NSUInteger type = [typeValue unsignedIntegerValue];
		if (type == AVAudioSessionInterruptionTypeBegan)
			[self beginInterruption];
		else if (type == AVAudioSessionInterruptionTypeEnded)
			[self endInterruption];
	}
}

- (BOOL)initOpenAL
{
    alGetError(); // reset any errors

    device = alcOpenDevice(NULL);
    if (!device)
    {
        NSLog(@"Could not open default OpenAL device");
        return NO;
    }

    context = alcCreateContext(device, 0);
    if (!context)
    {
        NSLog(@"Could not create OpenAL context for default device");
        return NO;
    }

    BOOL success = alcMakeContextCurrent(context);
    if (!success)
    {
        NSLog(@"Could not set current OpenAL context");
        return NO;
    }

	//
	alDistanceModel(AL_NONE);

    return YES;
}

#pragma mark Methods

//+ (void)start//:(SPAudioSessionCategory)category
- (instancetype)init
{
	if ((self = [super init])) {

		device  = NULL;
		context = NULL;
//		masterVolume = 1.0f;
		interrupted = NO;
		sessionInitialized = NO;

		if ([self initAudioSession]) {

			if ([self initOpenAL]) {

				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppActivated:) name:UIApplicationDidBecomeActiveNotification object:nil];

				sessionInitialized = YES;
			}

		// A bug introduced in iOS 4 may lead to 'endInterruption' NOT being called in some
		// situations. Thus, we're resuming the audio session manually via the 'DidBecomeActive'
		// notification. Find more information here: http://goo.gl/mr9KS

		}
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	alcMakeContextCurrent(NULL);
	alcDestroyContext(context);
	alcCloseDevice(device);
	
	[[AVAudioSession sharedInstance] setActive:NO error:NULL];
	//    AudioSessionSetActive(NO);
	
	device = NULL;
	context = NULL;
	interrupted = NO;
}

+ (void)start
{
	if (!globalAudioEngine) {
		globalAudioEngine = [[SPAudioEngine alloc] init];
	}
//	[SPAudioEngine start];//:SPAudioSessionCategory_SoloAmbientSound];
}

+ (void)stop
{
	globalAudioEngine = nil;
}

//+ (float)masterVolume
//{
//    return masterVolume;
//}
//
//+ (void)setMasterVolume:(float)volume
//{       
//    masterVolume = volume;
//    alListenerf(AL_GAIN, volume);
//    [SPAudioEngine postNotification:SPNotificationMasterVolumeChanged object:nil];
//}

#pragma mark Notifications

- (void)beginInterruption
{
    [SPAudioEngine postNotification:SPNotificationAudioInteruptionBegan object:nil];
    alcMakeContextCurrent(NULL);
	[[AVAudioSession sharedInstance] setActive:NO error:NULL];
//    AudioSessionSetActive(NO);
    interrupted = YES;
}

- (void)endInterruption
{
    interrupted = NO;
	[[AVAudioSession sharedInstance] setActive:YES error:NULL];
//    AudioSessionSetActive(YES);
    alcMakeContextCurrent(context);
    alcProcessContext(context);
    [SPAudioEngine postNotification:SPNotificationAudioInteruptionEnded object:nil];
}

- (void)onAppActivated:(NSNotification *)notification
{
    if (interrupted) [self endInterruption];
}

+ (void)postNotification:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotification:
     [NSNotification notificationWithName:name object:object]];
}

@end
