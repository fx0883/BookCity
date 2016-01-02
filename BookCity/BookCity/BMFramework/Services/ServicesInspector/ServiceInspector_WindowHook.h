
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "BMDefine.h"
#import "BMCmdDefine.h"
#import "NSObject+BMproperty.h"
#import "NSObject+BMNotification.h"
#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -


@interface UIWindow(ServiceInspector)

AS_NOTIFICATION( TOUCH_BEGAN );
AS_NOTIFICATION( TOUCH_MOVED );
AS_NOTIFICATION( TOUCH_ENDED );

+ (void)hook;
+ (void)block:(BOOL)flag;

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
