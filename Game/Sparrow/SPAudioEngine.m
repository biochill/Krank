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

@import OpenAL;
@import AVFoundation;
@import UIKit;

#import "SPAudioEngine.h"

static SPAudioEngine *globalAudioEngine;

// --- notifications -------------------------------------------------------------------------------

//NSString *const SPNotificationMasterVolumeChanged       = @"SPNotificationMasterVolumeChanged";
NSString *const SPNotificationAudioInteruptionBegan     = @"SPNotificationAudioInteruptionBegan";
NSString *const SPNotificationAudioInteruptionEnded     = @"SPNotificationAudioInteruptionEnded";

// --- private interaface --------------------------------------------------------------------------

@interface SPAudioEngine ()
{
	ALCdevice *_device;
	ALCcontext *_context;
//	float masterVolume;
}
@property (nonatomic) BOOL sessionInitialized;
@property (nonatomic) BOOL interrupted;
@end


// --- class implementation ------------------------------------------------------------------------

@implementation SPAudioEngine

//static void interruptionCallback (void *inUserData, UInt32 interruptionState)
//{   
//    if (interruptionState == kAudioSessionBeginInterruption)  
//        [SPAudioEngine beginInterruption]; 
//    else if (interruptionState == kAudioSessionEndInterruption)
//        [SPAudioEngine endInterruption];
//} 

#pragma mark Initialization

- (BOOL)initAudioSession
{
    if (!_sessionInitialized)
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

        _sessionInitialized = YES;

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

	_device = alcOpenDevice(NULL);
	if (!_device)
	{
		NSLog(@"Could not open default OpenAL device");
		return NO;
	}

	_context = alcCreateContext(_device, 0);
	if (!_context)
	{
		NSLog(@"Could not create OpenAL context for default device");
		return NO;
	}

	BOOL success = alcMakeContextCurrent(_context);
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

		_device  = NULL;
		_context = NULL;
//		masterVolume = 1.0f;
		_interrupted = NO;
		_sessionInitialized = NO;

		if ([self initAudioSession]) {

			if ([self initOpenAL]) {

				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppActivated:) name:UIApplicationDidBecomeActiveNotification object:nil];

				_sessionInitialized = YES;
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
	alcDestroyContext(_context);
	alcCloseDevice(_device);
	
	[[AVAudioSession sharedInstance] setActive:NO error:NULL];
	//    AudioSessionSetActive(NO);
	
	_device = NULL;
	_context = NULL;
	_interrupted = NO;
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
    _interrupted = YES;
}

- (void)endInterruption
{
    _interrupted = NO;
	[[AVAudioSession sharedInstance] setActive:YES error:NULL];
//    AudioSessionSetActive(YES);
    alcMakeContextCurrent(_context);
    alcProcessContext(_context);
    [SPAudioEngine postNotification:SPNotificationAudioInteruptionEnded object:nil];
}

- (void)onAppActivated:(NSNotification *)notification
{
	if (_interrupted) {
		[self endInterruption];
	}
}

+ (void)postNotification:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotification:
     [NSNotification notificationWithName:name object:object]];
}

@end
