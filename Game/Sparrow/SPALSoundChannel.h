//
//  SPALSoundChannel.h
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

#import <Foundation/Foundation.h>
#import "SPSoundChannel.h"

@class SPALSound;

/** ------------------------------------------------------------------------------------------------

 The SPALSoundChannel class is a concrete implementation of SPSoundChannel that uses 
 OpenAL internally. 
 
 Don't create instances of this class manually. Use `[SPSound createChannel]` instead.
 
------------------------------------------------------------------------------------------------- */

@interface SPALSoundChannel : SPSoundChannel

/// --------------------
/// @name Initialization
/// --------------------

/// Initializes a sound channel from an SPALSound object.
- (instancetype)initWithSound:(SPALSound *)sound;

@end
