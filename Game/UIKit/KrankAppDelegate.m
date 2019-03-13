//
//  KrankAppDelegate.m

#import "KrankAppDelegate.h"
#import "DLog.h"


@implementation KrankAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//	DLog(@"launchOptions = %@", launchOptions);

    return YES;
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//	DLog(@"%s url=%@ options=%@", __PRETTY_FUNCTION__, url, options);
//	return YES;
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//	DLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//	DLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
//	DLog(@"%s", __PRETTY_FUNCTION__);
}

//------------------------------------------------------------------------------------------------------------------------

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
	DLog(@"%s", __PRETTY_FUNCTION__);
}

@end
