//
//  HostTimeBase.h
//  TurboPack
//
//  Created by Sven Thoennissen on 23.04.17.
//
//

#import <TargetConditionals.h>
#import <MacTypes.h>

UInt64 GetTheCurrentTime(void);
UInt64 ConvertToNanos(UInt64 inHostTime);
UInt64 ConvertFromNanos(UInt64 inNanos);
UInt64 GetCurrentTimeInNanos(void);
UInt64 AbsoluteHostDeltaToNanos(UInt64 inStartTime, UInt64 inEndTime);
SInt64 HostDeltaToNanos(UInt64 inStartTime, UInt64 inEndTime);
