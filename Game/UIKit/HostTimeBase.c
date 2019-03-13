//
//  HostTimeBase.c
//  TurboPack
//
//  Created by Sven Thoennissen on 23.04.17.
//
//

#import <mach/mach_time.h>
#import "HostTimeBase.h"

typedef struct HostTimeBase {
	Boolean initialized;
	Float64			sFrequency;
	Float64			sInverseFrequency;
	UInt32			sMinDelta;
	UInt32			sToNanosNumerator;
	UInt32			sToNanosDenominator;
} HostTimeBase;


static HostTimeBase hostTimeBase = { false, 0, 0, 0, 0, 0 };

static UInt64 MultiplyByRatio(UInt64 inMuliplicand, UInt32 inNumerator, UInt32 inDenominator);


static void CAHostTimeBase_Initialize()
{
	if (hostTimeBase.initialized) return;

	//	get the info about Absolute time

	struct mach_timebase_info theTimeBaseInfo;
	mach_timebase_info(&theTimeBaseInfo);
	hostTimeBase.sMinDelta = 1;
	hostTimeBase.sToNanosNumerator = theTimeBaseInfo.numer;
	hostTimeBase.sToNanosDenominator = theTimeBaseInfo.denom;
	
	//	the frequency of that clock is: (sToNanosDenominator / sToNanosNumerator) * 10^9
	hostTimeBase.sFrequency = (Float64)(hostTimeBase.sToNanosDenominator) / (Float64)(hostTimeBase.sToNanosNumerator);
	hostTimeBase.sFrequency *= 1000000000.0;

	hostTimeBase.sInverseFrequency = 1.0 / hostTimeBase.sFrequency;

	hostTimeBase.initialized = true;
}

UInt64 GetTheCurrentTime()
{
	UInt64 theTime = 0;
	
	theTime = mach_absolute_time();
	
	return theTime;
}

UInt64 ConvertToNanos(UInt64 inHostTime)
{
	CAHostTimeBase_Initialize();
	
	UInt64 theAnswer = MultiplyByRatio(inHostTime, hostTimeBase.sToNanosNumerator, hostTimeBase.sToNanosDenominator);
	
	return theAnswer;
}

UInt64 ConvertFromNanos(UInt64 inNanos)
{
	CAHostTimeBase_Initialize();
	
	UInt64 theAnswer = MultiplyByRatio(inNanos, hostTimeBase.sToNanosDenominator, hostTimeBase.sToNanosNumerator);
	
	return theAnswer;
}

UInt64 GetCurrentTimeInNanos()
{
	return ConvertToNanos(GetTheCurrentTime());
}

UInt64 AbsoluteHostDeltaToNanos(UInt64 inStartTime, UInt64 inEndTime)
{
	UInt64 theAnswer;
	
	if(inStartTime <= inEndTime)
	{
		theAnswer = inEndTime - inStartTime;
	}
	else
	{
		theAnswer = inStartTime - inEndTime;
	}
	
	return ConvertToNanos(theAnswer);
}

SInt64 HostDeltaToNanos(UInt64 inStartTime, UInt64 inEndTime)
{
	SInt64 theAnswer;
	SInt64 theSign = 1;
	
	if(inStartTime <= inEndTime)
	{
		theAnswer = (SInt64)(inEndTime - inStartTime);
	}
	else
	{
		theAnswer = (SInt64)(inStartTime - inEndTime);
		theSign = -1;
	}
	
	return theSign * (SInt64)(ConvertToNanos((UInt64)(theAnswer)));
}

static UInt64 MultiplyByRatio(UInt64 inMuliplicand, UInt32 inNumerator, UInt32 inDenominator)
{
#if TARGET_OS_MAC && TARGET_RT_64_BIT
	__uint128_t theAnswer = inMuliplicand;
#else
	long double theAnswer = inMuliplicand;
#endif
	if(inNumerator != inDenominator)
	{
		theAnswer *= inNumerator;
		theAnswer /= inDenominator;
	}
	return (UInt64)(theAnswer);
}
