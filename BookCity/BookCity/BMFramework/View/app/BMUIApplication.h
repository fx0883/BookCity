
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "NSObjectHead.h"

//#pragma mark -

//AS_PACKAGE( BeePackage_UI, BeeUIApplication, application );

//#pragma mark -

@class BMUIApplication;
//@compatibility_alias BeeSkeleton BMUIApplication;

#pragma mark -

@interface BMUIApplication : UIResponder<UIApplicationDelegate>

AS_NOTIFICATION( LAUNCHED )		// did launched
AS_NOTIFICATION( TERMINATED )	// will terminate

AS_NOTIFICATION( STATE_CHANGED )	// state changed
AS_NOTIFICATION( MEMORY_WARNING )	// memory warning

AS_NOTIFICATION( LOCAL_NOTIFICATION )
AS_NOTIFICATION( REMOTE_NOTIFICATION )

AS_NOTIFICATION( APS_REGISTERED )
AS_NOTIFICATION( APS_ERROR )

AS_INT( DEVICE_CURRENT )
AS_INT( DEVICE_PHONE_3_INCH )
AS_INT( DEVICE_PHONE_4_INCH )

@property (nonatomic, readonly) BOOL		ready;

@property (nonatomic, retain) UIWindow *	window;
@property (nonatomic, assign) NSUInteger	device;
@property (nonatomic, readonly) BOOL		inForeground;
@property (nonatomic, readonly) BOOL		inBackground;

+ (BMUIApplication *)sharedInstance;

- (void)load;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
