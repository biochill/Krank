//
//  SPALSound.h
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

@import OpenAL;
#import <Foundation/Foundation.h>
#import "SPSound.h"

/** ------------------------------------------------------------------------------------------------ 

 The SPALSound class is a concrete implementation of SPSound that uses OpenAL internally. 
 
 Don't create instances of this class manually. Use `[SPSound initWithContentsOfFile:]` instead.
 
------------------------------------------------------------------------------------------------- */

@interface SPALSound : SPSound

/// --------------------
/// @name Initialization
/// --------------------

/// Initializes a sound with its known properties.
- (instancetype)initWithData:(const void *)data size:(int)size channels:(int)channels frequency:(int)frequency duration:(NSTimeInterval)duration;

/// ----------------
/// @name Properties
/// ----------------

/// The OpenAL buffer ID of the sound.
@property (nonatomic, readonly) ALuint leftBufferID;
#if HAVE_STEREO_PANNING
@property (nonatomic, readonly) ALuint rightBufferID;
#endif

@end
