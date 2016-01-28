//
//  SPALSoundChannel.m
//  Sparrow
//
//  Created by Daniel Sperl on 28.05.10.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

//
// 17.12.2015 Modified by Sven Thoennissen
// Support for tvOS 9.0 and ARC, separated audio classes, support for AIFF.
//

#import "SPALSound.h"
#import "SPALSoundChannel.h"
#import "SPAudioEngine.h"

//#import <QuartzCore/QuartzCore.h> // for CACurrentMediaTime
//#import <OpenAL/al.h>
//#import <OpenAL/alc.h>
//
// --- private interface ---------------------------------------------------------------------------

//@interface SPALSoundChannel ()
//
//- (void)scheduleSoundCompletedEvent;
//- (void)revokeSoundCompletedEvent;
//
//@end


// --- class implementation ------------------------------------------------------------------------

@implementation SPALSoundChannel
{
	SPALSound *_sound;
	ALuint _leftSourceID;
#if HAVE_STEREO_PANNING
	ALuint _rightSourceID;
#endif
//	float _volume;
//	float _pan;
//	BOOL _loop;

	CFTimeInterval _startMoment;
	CFTimeInterval _pauseMoment;
	BOOL _interrupted;
}

- (instancetype)initWithSound:(SPALSound *)sound
{
	if ((self = [super init]))
	{
		_sound = sound;
//		_volume = 1.0f;
//		_loop = NO;
		_interrupted = NO;
		_startMoment = 0.0;
		_pauseMoment = 0.0;

		alGenSources(1, &_leftSourceID);
		alSourcei(_leftSourceID, AL_BUFFER, sound.leftBufferID);
		ALenum errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not create OpenAL left source (%x)", errorCode);
			return nil;
		}

#if HAVE_STEREO_PANNING

		alGenSources(1, &_rightSourceID);
		alSourcei(_rightSourceID, AL_BUFFER, sound.rightBufferID);
		errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not create OpenAL right source (%x)", errorCode);
			return nil;
		}

		self.pan = 0;
#endif

		// Notifications
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(onInterruptionBegan:) 
			name:SPNotificationAudioInteruptionBegan object:nil];
		[nc addObserver:self selector:@selector(onInterruptionEnded:) 
			name:SPNotificationAudioInteruptionEnded object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	alSourceStop(_leftSourceID);
	alSourcei(_leftSourceID, AL_BUFFER, 0);
	alDeleteSources(1, &_leftSourceID);
#if HAVE_STEREO_PANNING
	alSourceStop(_rightSourceID);
	alSourcei(_rightSourceID, AL_BUFFER, 0);
	alDeleteSources(1, &_rightSourceID);
#endif
}

#pragma mark SPSoundChannel

- (void)play
{
	if (!self.isPlaying)
	{
		CFTimeInterval now = CACurrentMediaTime();
		
		if (_pauseMoment != 0.0) // paused
		{
			_startMoment += now - _pauseMoment;
			_pauseMoment = 0.0;
		}
		else // stopped 
		{
			_startMoment = now;
		}
		
		[self scheduleSoundCompletedEvent];

		alSourcePlay(_leftSourceID);
#if HAVE_STEREO_PANNING
		alSourcePlay(_rightSourceID);
#endif
	}
}

- (void)pause
{
	if (self.isPlaying)
	{    
		[self revokeSoundCompletedEvent];
		_pauseMoment = CACurrentMediaTime();
		alSourcePause(_leftSourceID);
		alSourcePause(_leftSourceID);
	}
}

- (void)stop
{
    [self revokeSoundCompletedEvent];
    _startMoment = _pauseMoment = 0.0;
    alSourceStop(_leftSourceID);
	alSourceStop(_leftSourceID);
}

- (BOOL)isPlaying
{
	ALint state;
	alGetSourcei(_leftSourceID, AL_SOURCE_STATE, &state);
	return state == AL_PLAYING;
}

- (BOOL)isPaused
{
	ALint state;
	alGetSourcei(_leftSourceID, AL_SOURCE_STATE, &state);
	return state == AL_PAUSED;
}

- (BOOL)isStopped
{
	ALint state;
	alGetSourcei(_leftSourceID, AL_SOURCE_STATE, &state);
	return state == AL_STOPPED;
}

//- (void)setLoop:(BOOL)value
//{
//	if (value != _loop)
//	{
//		_loop = value;
//	alSourcei(_leftSourceID, AL_LOOPING, value);
//	alSourcei(_rightSourceID, AL_LOOPING, value);
//	}
//}

- (void)setVolume:(float)value
{
//	_volume = value;
	alSourcef(_leftSourceID, AL_GAIN, value);
#if HAVE_STEREO_PANNING
	alSourcef(_rightSourceID, AL_GAIN, value);
#endif
}

#if HAVE_STEREO_PANNING
- (void)setPan:(float)pan
{
// -1 = far left, 1 = far right
//	_pan = pan;

	ALfloat leftZ  = pan <= 0 ? 0 : pan;
	ALfloat rightZ = pan >= 0 ? 0 : fabsf(pan);

	alSource3f(_leftSourceID, AL_POSITION, -1, 0, leftZ*10);
	alSource3f(_rightSourceID, AL_POSITION, 1, 0, rightZ*10);
}
#endif

- (NSTimeInterval)duration
{
    return [_sound duration];
}

#pragma mark Events

- (void)scheduleSoundCompletedEvent
{
    if (_startMoment != 0.0)
    {
        double remainingTime = _sound.duration - (CACurrentMediaTime() - _startMoment);
        [self revokeSoundCompletedEvent];
        if (remainingTime >= 0.0)
        {
            [self performSelector:@selector(dispatchCompletedEvent) withObject:nil
                       afterDelay:remainingTime];
        }
    }
}

- (void)revokeSoundCompletedEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dispatchCompletedEvent) object:nil];
}

- (void)dispatchCompletedEvent
{
//	if (!_loop) {
//		[self dispatchEventWithType:SPEventTypeCompleted];
		[[NSNotificationCenter defaultCenter] postNotificationName:SPNotificationEvent object:_sound userInfo:@{@"Event":SPEventTypeCompleted, @"Channel":self}];
//	}
}

#pragma mark Notifications

- (void)onInterruptionBegan:(NSNotification *)notification
{
    if (self.isPlaying)
    {
        [self revokeSoundCompletedEvent];
        _interrupted = YES;
        _pauseMoment = CACurrentMediaTime();
    }
}

- (void)onInterruptionEnded:(NSNotification *)notification
{
    if (_interrupted)
    {
        _startMoment += CACurrentMediaTime() - _pauseMoment;
        _pauseMoment = 0.0;
        _interrupted = NO;
        [self scheduleSoundCompletedEvent];
    }
}

@end
