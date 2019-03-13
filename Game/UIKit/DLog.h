//
//  DLog.h
//  Krank
//
//  Created by Sven Thoennissen on 10.03.19.
//

#ifndef DLog_h
#define DLog_h

// This type is used throughout the app.
typedef void (^ActionHandler)(void);

#if DEBUG
#define DLog NSLog
#else
#define DLog(...)
#endif

#endif /* DLog_h */
