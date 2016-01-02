/*!
 @header BMControl
 @abstract BMControl 主要控制器类
 @author FS (作者信息)
 @version 1.00 2014/10/12 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
#import "BMDefine.h"

typedef enum
{
    INVOKEACTIONTYPE0,
    INVOKEACTIONTYPE1,
    INVOKEACTIONTYPE2,
    INVOKEACTIONTYPE3
} INVOKEACTIONTYPE;





@interface BMControl : NSObject

/*!
 *  @brief 单例宏的调用
 */
AS_SINGLETON(BMControl)


/*!
 *  @brief 调用Action的入口方法
 *
 *  @param dicparam dic封装参数
 */
-(void)excute:(NSMutableDictionary*)dicparam;

@end

/*!
 *  定义单例
 */
#define SharedControl  ([BMControl sharedInstance])