

#import "ServiceInspector_WindowHook.h"
#import "ServiceInspector_Border.h"
#import "ServiceInspector_Indicator.h"
#import "BMDefine.h"
#import "BMCmdDefine.h"
#import "NSObject+BMNotification.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface UIWindow(ServiceInspectorPrivate)
- (void)mySendEvent:(UIEvent *)event;
@end

#pragma mark -

@implementation UIWindow(ServiceInspector)

DEF_NOTIFICATION( TOUCH_BEGAN );
DEF_NOTIFICATION( TOUCH_MOVED );
DEF_NOTIFICATION( TOUCH_ENDED );

static BOOL	__blocked = NO;
static void (*__sendEvent)( id, SEL, UIEvent * );

+ (void)hook
{
	static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;

		method = class_getInstanceMethod( [UIWindow class], @selector(sendEvent:) );
		__sendEvent = (void *)method_getImplementation( method );
		
		implement = class_getMethodImplementation( [UIWindow class], @selector(mySendEvent:) );
		method_setImplementation( method, implement );
		
		__swizzled = YES;
	}
}

+ (void)block:(BOOL)flag
{
	__blocked = flag;
}

- (void)mySendEvent:(UIEvent *)event
{	
	UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
	if ( self == keyWindow )
	{
		if ( UIEventTypeTouches == event.type )
		{
			NSSet * allTouches = [event allTouches];
			if ( 1 == [allTouches count] )
			{
				UITouch * touch = [[allTouches allObjects] objectAtIndex:0];
				if ( 1 == [touch tapCount] )
				{
					if ( UITouchPhaseBegan == touch.phase )
					{
						[self postNotification:self.TOUCH_BEGAN withObject:touch];

	//					INFO( @"view '%@', touch began\n%@", [[touch.view class] description], [touch.view description] );
                        NSLog(@"view '%@', touch began\n%@",[[touch.view class] description], [touch.view description] );
						
						ServiceInspector_Border * border = [ServiceInspector_Border new];
						border.frame = touch.view.bounds;
						[touch.view addSubview:border];
						[border startAnimation];

					}
					else if ( UITouchPhaseMoved == touch.phase )
					{
						[self postNotification:self.TOUCH_MOVED withObject:touch];
					}
					else if ( UITouchPhaseEnded == touch.phase || UITouchPhaseCancelled == touch.phase )
					{
						[self postNotification:self.TOUCH_ENDED withObject:touch];
					
                        NSLog(@"view '%@', touch ended\n%@",[[touch.view class] description], [touch.view description] );

						ServiceInspector_Indicator * indicator = [ServiceInspector_Indicator new];
						indicator.frame = CGRectMake( 0, 0, 50.0f, 50.0f );
						indicator.center = [touch locationInView:keyWindow];
						[keyWindow addSubview:indicator];
						[indicator startAnimation];

					}
				}
			}
		}
	}

	if ( NO == __blocked )
	{
		if ( __sendEvent )
		{
			__sendEvent( self, _cmd, event );
		}
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
