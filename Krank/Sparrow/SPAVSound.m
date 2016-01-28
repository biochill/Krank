//
//  SPAVSound.m
//  Sparrow
//
//  Created by Daniel Sperl on 29.05.10.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

//
// 17.12.2015 Modified by Sven Thoennissen
// Support for tvOS 9.0 and ARC, separated audio classes, support for AIFF.
//

#import "SPAVSound.h"
#import "SPAVSoundChannel.h"

@implementation SPAVSound
{
//    NSData *_soundData;
	NSURL *_soundURL;
    NSTimeInterval _duration;
}

@synthesize duration = _duration;

#pragma mark Initialization

//- (instancetype)initWithContentsOfFile:(NSString *)path duration:(double)duration
//{
//    if ((self = [super init]))
//    {
//        NSString *fullPath = [SPUtils absolutePathToFile:path];
//        _soundData = [[NSData alloc] initWithContentsOfFile:fullPath];
//        _duration = duration;
//    }
//    return self;
//}

- (instancetype)initWithURL:(NSURL *)url duration:(NSTimeInterval)duration
{
	if ((self = [super init]))
	{
//		NSString *fullPath = [SPUtils absolutePathToFile:path];
//		_soundData = [[NSData alloc] initWithContentsOfFile:fullPath];
		_soundURL = url;
		_duration = duration;
	}
	return self;
}

#pragma mark Methods

- (AVAudioPlayer *)createPlayer
{
    NSError *error = nil;    
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:_soundData error:&error];
	NSAssert([_soundURL.pathExtension isEqualToString:@"m4a"], @"Music must be m4a");
	AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:_soundURL fileTypeHint:AVFileTypeAppleM4A error:&error];
    if (error) DLog(@"Could not create AVAudioPlayer: %@", [error description]);
    return player;	
}

#pragma mark SPSound

- (SPSoundChannel *)createChannel
{
	return [[SPAVSoundChannel alloc] initWithSound:self];
}

@end
