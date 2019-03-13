//
//  SPSound.m
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

#import "DLog.h"
#import "SPALSound.h"
#import "SPAVSound.h"
#import "SPSound.h"
#import "SPSoundChannel.h"

NSString *const SPNotificationEvent = @"SPNotificationEvent";
NSString *const SPEventTypeCompleted = @"SPEventTypeCompleted";

@implementation SPSound
{
    NSMutableSet *_playingChannels;
}

#pragma mark Initialization

- (instancetype)initWithContentsOfFile:(NSString *)path
{
    // SPSound is a class factory! We'll return a subclass, thus we don't need 'self' anymore.
//    [self release];
	
//	NSString *fullPath = [SPUtils absolutePathToFile:path withScaleFactor:1.0f];
//    if (!fullPath) [NSException raise:SPExceptionFileNotFound format:@"file %@ not found", path];
	
	NSURL *url = [NSURL fileURLWithPath:path];
	NSString *error;

	ExtAudioFileRef fileID = NULL;
	AudioStreamBasicDescription streamDescription;
	OSStatus result;
	NSTimeInterval soundDuration = 0.0;
	NSMutableData *soundData;
	UInt32 soundSize = 0;

	do {
		//
		// OpenAL requires native endian. Since some files may be AIFF we use the Extended API functions.
		// This way we can load WAVE or AIFF files regardless of endian.
		//

		result = ExtAudioFileOpenURL((__bridge CFURLRef)url, &fileID);
		if (result != noErr)
		{
			error = [NSString stringWithFormat:@"Could not open audio file (%#x): %@", (int)result, url];
			break;
		}

		// Get total number of frames
		UInt32 size = sizeof(SInt64);
		SInt64 totalFrames;
		if(noErr != (result = ExtAudioFileGetProperty(fileID, kExtAudioFileProperty_FileLengthFrames, &size, &totalFrames)))
		{
			error = [NSString stringWithFormat:@"Could not get frame count (%#x): %@", (int)result, url];
			break;
		}

		// Read description
		size = sizeof(AudioStreamBasicDescription);
		if (noErr != (result = ExtAudioFileGetProperty(fileID, kExtAudioFileProperty_FileDataFormat, &size, &streamDescription)))
		{
			error = [NSString stringWithFormat:@"Could not get audio format (%#x): %@", (int)result, url];
			break;
		}

		// We do not want to convert m4a to PCM
		if (streamDescription.mFormatID != kAudioFormatLinearPCM)
		{
			error = @"file is not PCM";
			break;
		}

		// Specify the new audio format (anything not changed remains the same)
		streamDescription.mFormatID = kAudioFormatLinearPCM;
		streamDescription.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
		// Force to 16 bit since iOS doesn't seem to like 8 bit.
		streamDescription.mBitsPerChannel = 16;

		if (streamDescription.mChannelsPerFrame > 2)
		{
			error = @"only two channels supported";
			break;
		}

		// Set the new audio format
		streamDescription.mBytesPerFrame = streamDescription.mChannelsPerFrame * streamDescription.mBitsPerChannel / 8;
		streamDescription.mFramesPerPacket = 1;
		streamDescription.mBytesPerPacket = streamDescription.mBytesPerFrame;
		if (noErr != (result = ExtAudioFileSetProperty(fileID, kExtAudioFileProperty_ClientDataFormat, sizeof(AudioStreamBasicDescription), &streamDescription)))
		{
			error = [NSString stringWithFormat:@"Could not set new audio format (%#x): %@", (int)result, url];
			break;
		}

		soundDuration = totalFrames / streamDescription.mSampleRate;
		soundSize = streamDescription.mBytesPerFrame * (UInt32)totalFrames;
		soundData = [NSMutableData dataWithLength:soundSize];

		// Read the file
		UInt32 numFrames = (UInt32)totalFrames;
		AudioBufferList bufferList;
		bufferList.mNumberBuffers = 1;
		bufferList.mBuffers[0].mNumberChannels = streamDescription.mChannelsPerFrame;
		bufferList.mBuffers[0].mDataByteSize = soundSize;
		bufferList.mBuffers[0].mData = soundData.mutableBytes;
		if (noErr != (result = ExtAudioFileRead(fileID, &numFrames, &bufferList)))
		{
			error = [NSString stringWithFormat:@"Could not read sound data (%#x): %@", (int)result, url];
			break;
		}

	} while (NO);

	if (fileID)
		ExtAudioFileDispose(fileID);

	if (!error)
	{
		self = [[SPALSound alloc] initWithData:soundData.bytes size:soundSize channels:streamDescription.mChannelsPerFrame frequency:streamDescription.mSampleRate duration:soundDuration];
//		DLog(@"Loaded sound '%@' with duration=%.3fs", path.lastPathComponent, soundDuration);
	}
	else
	{
		DLog(@"Sound '%@' will be played with AVAudioPlayer, reason: %@", path.lastPathComponent, error);
		self = [[SPAVSound alloc] initWithURL:url duration:soundDuration];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundEventNotification:) name:SPNotificationEvent object:self];

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Methods

- (void)play
{
	[self playWithVolume:1.0 pan:0];
}

- (void)playWithVolume:(float)volume
{
	[self playWithVolume:volume pan:0];
}

- (void)playWithVolume:(float)volume pan:(float)pan
{
	SPSoundChannel *channel = [self createChannel];

	if (channel)
	{
//        [channel addEventListener:@selector(onSoundCompleted:) atObject:self
//                          forType:SPEventTypeCompleted];
		channel.volume = volume;
		channel.pan = pan;
        [channel play];

        if (!_playingChannels) _playingChannels = [[NSMutableSet alloc] init];
        [_playingChannels addObject:channel];
    }
}

- (SPSoundChannel *)createChannel
{
//    [NSException raise:SPExceptionAbstractMethod format:@"Override 'createChannel' in subclasses."];
	return nil;
}

#pragma mark Events

- (void)soundEventNotification:(NSNotification *)notification
{
	SPSoundChannel *channel = (SPSoundChannel *)notification.userInfo[@"Channel"];
	[channel stop];
	[_playingChannels removeObject:channel];
}

//- (void)onSoundCompleted:(SPEvent *)event
//{
//    SPSoundChannel *channel = (SPSoundChannel *)event.target;
//    [channel stop];
//    [_playingChannels removeObject:channel];
//}

#pragma mark Properties

- (double)duration
{
//    [NSException raise:SPExceptionAbstractMethod format:@"Override 'duration' in subclasses."];
    return 0.0;
}

@end
