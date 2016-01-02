

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "BMUIApplication.h"

#pragma mark -

//DEF_PACKAGE( BeePackage_UI, BeeUIApplication, application );

#pragma mark -

@interface BMUIApplication()
{
	BOOL		_ready;
	NSUInteger	_device;
	UIWindow *	_window;
}

- (void)initWindow;

@end

#pragma mark -

@implementation BMUIApplication

DEF_NOTIFICATION( LAUNCHED )		// did launched
DEF_NOTIFICATION( TERMINATED )		// will terminate

DEF_NOTIFICATION( STATE_CHANGED )	// state changed
DEF_NOTIFICATION( MEMORY_WARNING )	// memory warning

DEF_NOTIFICATION( LOCAL_NOTIFICATION )
DEF_NOTIFICATION( REMOTE_NOTIFICATION )

DEF_NOTIFICATION( APS_REGISTERED )
DEF_NOTIFICATION( APS_ERROR )

DEF_INT( DEVICE_CURRENT,		0 )
DEF_INT( DEVICE_PHONE_3_INCH,	1 )
DEF_INT( DEVICE_PHONE_4_INCH,	2 )



static BMUIApplication * __sharedApp = nil;

+ (BMUIApplication *)sharedInstance
{
	return __sharedApp;
}

- (void)load
{
	
}

- (void)unload
{
	
}

- (id)init
{
	self = [super init];
	if ( self )
	{
//		[self load];
//		[self performLoad];
	}
	return self;
}

- (void)dealloc
{
//	[self unload];
//	[self performUnload];
	
//	[_window release];
	_window = nil;
	
//    [super dealloc];
}

#pragma mark -

- (BOOL)inForeground
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateActive == state )
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)inBackground
{
	return [self inForeground] ? NO : YES;
}

#pragma mark -

- (void)initWindow
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.alpha = 1.0f;
//	self.window.layer.masksToBounds = YES;
//	self.window.layer.opaque = YES;
    self.window.backgroundColor = [UIColor clearColor];
}

- (void)applySimulation
{
	CGRect phoneFrame = [[UIScreen mainScreen] bounds];

//	if ( [BeeSystemInfo isPadRetina] || [BeeSystemInfo isPad] )
//	{
//		if ( self.DEVICE_PHONE_3_INCH == _device )
//		{
//			phoneFrame.size.width = 640.0f;
//			phoneFrame.size.height = 960.0f;
//		}
//		else if ( self.DEVICE_PHONE_4_INCH == _device )
//		{
//			phoneFrame.size.width = 640.0f;
//			phoneFrame.size.height = 1136.0f;
//		}
//		
//		if ( [BeeSystemInfo isPad] )
//		{
//			phoneFrame.size.width /= 2.0f;
//			phoneFrame.size.height /= 2.0f;
//		}
//	}
//
//	phoneFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - phoneFrame.size.width) / 2.0f;
//	phoneFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - phoneFrame.size.height) / 2.0f;

	self.window.frame = phoneFrame;
}

- (NSUInteger)device
{
	return _device;
}

- (void)setDevice:(NSUInteger)d
{
	if ( d != _device )
	{
		_device = d;
		
		if ( _ready )
		{
			[self applySimulation];
		}
	}
}

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[self application:application didFinishLaunchingWithOptions:nil];
}

/**
 *  先用这个方法初始化当前app
 */
-(void)performLoad
{
    SharedControl;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	__sharedApp = self;

	[self initWindow];
    [self performLoad];
	[self load];

	
	if ( nil == self.window.rootViewController )
	{
//		self.window.rootViewController = [BeeUIRouter sharedInstance];
	}

	if ( self.window.rootViewController )
	{
//		UNUSED( self.window.rootViewController.view );
	}

	[self.window makeKeyAndVisible];
	
//	[self applySimulation];

    if ( nil != launchOptions ) // 从通知启动
	{
		NSURL *		url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		NSString *	bundleID = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];

		if ( url || bundleID )
		{
			NSMutableDictionary * params = [NSMutableDictionary dictionary];
//			params.APPEND( @"url", url );
//			params.APPEND( @"source", bundleID );
            
            [params setObject:url forKey:@"url"];
            [params setObject:bundleID forKey:@"bundleID"];
//
			[self postNotification:BMUIApplication.LAUNCHED withObject:params];
		}
		else
		{
            //发送一个消息
			[self postNotification:BMUIApplication.LAUNCHED];
		}

		UILocalNotification * localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
		if ( localNotification )
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:localNotification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
			[self postNotification:BMUIApplication.LOCAL_NOTIFICATION withObject:dict];
		}

		NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if ( remoteNotification )
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:remoteNotification, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
			[self postNotification:BMUIApplication.REMOTE_NOTIFICATION withObject:dict];
		}
	}
	else
	{
		[self postNotification:BMUIApplication.LAUNCHED];
	}
	
	_ready = YES;
    return YES;
}

// Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return [self application:application openURL:url sourceApplication:nil annotation:nil];
}

// no equiv. notification. return NO if the application can't open for some reason
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if ( url || sourceApplication )
	{
		NSMutableDictionary * params = [NSMutableDictionary dictionary];
//		params.APPEND( @"url", url );
//		params.APPEND( @"source", sourceApplication );
        [params setObject:url forKey:@"url"];
        [params setObject:sourceApplication forKey:@"source"];
		[self postNotification:BMUIApplication.LAUNCHED withObject:params];
	}
	else
	{
		[self postNotification:BMUIApplication.LAUNCHED];
	}

	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//	[self.window.rootViewController viewWillAppear:NO];
//	[self.window.rootViewController viewDidAppear:NO];

	[self postNotification:BMUIApplication.STATE_CHANGED];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//	[self.window.rootViewController viewWillDisappear:NO];
//	[self.window.rootViewController viewDidDisappear:NO];

	[self postNotification:BMUIApplication.STATE_CHANGED];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[self postNotification:BMUIApplication.MEMORY_WARNING];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self postNotification:BMUIApplication.TERMINATED];
}

#pragma mark -

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
	
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
	
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
	
}

#pragma mark -

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString * token = [deviceToken description];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	
//	[self postNotification:BeeUIApplication.APS_REGISTERED withObject:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//	[self postNotification:BeeUIApplication.APS_ERROR withObject:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
		[self postNotification:BMUIApplication.REMOTE_NOTIFICATION withObject:dict];
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
		[self postNotification:BMUIApplication.REMOTE_NOTIFICATION withObject:dict];
	}
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
		[self postNotification:BMUIApplication.LOCAL_NOTIFICATION withObject:dict];
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
		[self postNotification:BMUIApplication.LOCAL_NOTIFICATION withObject:dict];
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self postNotification:BMUIApplication.STATE_CHANGED];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[self postNotification:BMUIApplication.STATE_CHANGED];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
