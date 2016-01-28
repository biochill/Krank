//
//  SPALSound.m
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

@implementation SPALSound
{
    NSTimeInterval _duration;
#if HAVE_STEREO_PANNING
	NSMutableData *_bufferData[2];
#endif
}

- (instancetype)initWithData:(const void *)data size:(int)size channels:(int)channels frequency:(int)frequency duration:(NSTimeInterval)duration
{
	if ((self = [super init]))
	{
		_duration = duration;
		[SPAudioEngine start];
		
		ALCcontext *const currentContext = alcGetCurrentContext();
		if (!currentContext)
		{
			DLog(@"Could not get current OpenAL context");
			return nil;
		}        

		NSAssert(channels == 2, @"want 2 channels");

		ALenum errorCode;

#if HAVE_STEREO_PANNING

		ALuint bufferIDs[2];
		alGenBuffers(2, bufferIDs);
		errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not allocate OpenAL buffers (%x)", errorCode);
			return nil;
		}
		_leftBufferID = bufferIDs[0];
		_rightBufferID = bufferIDs[1];

		//
		// Split stereo buffer into 2 mono buffers
		//
		NSUInteger monoSize = size/2;
		if (!(_bufferData[0] = [[NSMutableData alloc] initWithCapacity:monoSize])) {
			DLog(@"Could not allocate buffer 0");
			return nil;
		}
		if (!(_bufferData[1] = [[NSMutableData alloc] initWithCapacity:monoSize])) {
			DLog(@"Could not allocate buffer 1");
			return nil;
		}
		SInt16 *buffer0 = _bufferData[0].mutableBytes;
		SInt16 *buffer1 = _bufferData[1].mutableBytes;
		const SInt16 *source = data;
		NSUInteger dataSamples = size/sizeof(SInt16)/2; // 4 bytes per stereo sample
		for (NSUInteger i = 0; i < dataSamples; ++i) {
			buffer0[i] = source[i*2];
			buffer1[i] = source[i*2 + 1];
		}


		//

		alBufferData(_leftBufferID, AL_FORMAT_MONO16, buffer0, monoSize, frequency);
		errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not fill left OpenAL buffer (%x)", errorCode);
			return nil;
		}

		alBufferData(_rightBufferID, AL_FORMAT_MONO16, buffer1, monoSize, frequency);
		errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not fill right OpenAL buffer (%x)", errorCode);
			return nil;
		}

#else

		alGenBuffers(1, &_leftBufferID);
		errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not allocate OpenAL buffer (%x)", errorCode);
			return nil;
		}

		ALenum format = channels > 1 ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
		alBufferData(_leftBufferID, format, data, size, frequency);
		errorCode = alGetError();
		if (errorCode != AL_NO_ERROR)
		{
			DLog(@"Could not fill OpenAL buffer (%x)", errorCode);
			return nil;
		}

#endif

	}
	return self;
}

- (void)dealloc
{
	alDeleteBuffers(1, &_leftBufferID);
#if HAVE_STEREO_PANNING
	alDeleteBuffers(1, &_rightBufferID);
#endif
}

#pragma mark SPSound

- (SPSoundChannel *)createChannel
{
    return [[SPALSoundChannel alloc] initWithSound:self];
}

@end
