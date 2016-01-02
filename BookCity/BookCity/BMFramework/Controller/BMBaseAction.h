/*!
 @header BMBaseAction
 @abstract BMBaseAction 基础的Action类，所有的Action都要继承BMBaseAction
 @author FS (作者信息)
 @version 1.00 2014/10/12 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
/*!
 @class
 @abstract 基础的Action类，所有的Action都要继承BMBaseAction
 */
@interface BMBaseAction : NSObject




/*!
 *  Action入口调用函数
 *
 *  @param dicparam 传入传出参数 NSMutableDictionary Action标准参数
 */
-(void)excute:(NSMutableDictionary*)dicparam;

@end
