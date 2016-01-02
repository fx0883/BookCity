/*!
 @header NSNotification(BMNotification)
 @abstract 关于这个源代码文件的一些基本描述
 @author FS (作者信息)
 @version 1.00 2014/10/12 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#pragma mark -

#undef	AS_NOTIFICATION
#define AS_NOTIFICATION( __name ) \
		AS_STATIC_PROPERTY( __name )

#undef	DEF_NOTIFICATION
#define DEF_NOTIFICATION( __name ) \
		DEF_STATIC_PROPERTY3( __name, @"notify", [self description] )

#undef	ON_NOTIFICATION
#define ON_NOTIFICATION( __notification ) \
		- (void)handleNotification:(NSNotification *)__notification

#undef	ON_NOTIFICATION2
#define ON_NOTIFICATION2( __filter, __notification ) \
		- (void)handleNotification_##__filter:(NSNotification *)__notification

#undef	ON_NOTIFICATION3
#define ON_NOTIFICATION3( __class, __name, __notification ) \
		- (void)handleNotification_##__class##_##__name:(NSNotification *)__notification

#pragma mark -
/*!
 @category
 @abstract NSNotification的BMNotification
 */
@interface NSNotification(BMNotification)

/*!
 *  是否是同一notification的name
 *
 *  @param name
 *
 *  @return 判断是否是
 */
- (BOOL)is:(NSString *)name;

/*!
 *  是否是同一notification的prefix
 *
 *  @param prefix
 *
 *  @return 判断是否是
 */
- (BOOL)isKindOf:(NSString *)prefix;

@end

#pragma mark -

/*!
 @category
 @abstract NSObject的BMNotification
 */
@interface NSObject(BMNotification)

/*!
 *  返回NOTIFICATION的description
 *
 *  @return 返回NOTIFICATION的description
 */
+ (NSString *)NOTIFICATION;

/*!
 *  返回NOTIFICATION_TYPE的description
 *
 *  @return 返回NOTIFICATION_TYPE的description
 */
+ (NSString *)NOTIFICATION_TYPE;

/*!
 *  Notification 的调用方法 可以override此方法
 *
 *  @param notification
 */
- (void)handleNotification:(NSNotification *)notification;

/*!
 *  加入一个观察者
 *
 *  @param name 需要观察的notification名字
 */
- (void)observeNotification:(NSString *)name;
- (void)observeAllNotifications;

/*!
 *  取消一个Notification观察
 *
 *  @param name 需要观察的notification名字
 */
- (void)unobserveNotification:(NSString *)name;
/*!
 *  取消所有的观察者名字
 */
- (void)unobserveAllNotifications;

/*!
 *  发送Notification
 *
 *  @param name Notification name
 *
 *  @return 发送是否成功
 */
+ (BOOL)postNotification:(NSString *)name;

/*!
 *  发送Notification
 *
 *  @param name Notification name
 *  @param object Notification 的发送对象
 *
 *  @return 发送是否成功
 */
+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

/*!
 *  发送Notification
 *
 *  @param name Notification name
 *
 *  @return 发送是否成功
 */
- (BOOL)postNotification:(NSString *)name;
/*!
 *  发送Notification
 *
 *  @param name Notification name
 *  @param object Notification 的发送对象
 *
 *  @return 发送是否成功
 */
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end
