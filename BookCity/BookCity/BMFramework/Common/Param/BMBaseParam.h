
/*!
 @header BMBaseParam
 @abstract BMBaseParam 的头文件
 @author FS (作者信息)
 @version 1.00 2014/10/12 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>

/*!
 *  定义参数类的block
 *
 *  @param int       错误代码 如果错误代码为 0 就是正确的
 *  @param NSString 提示消息
 */
typedef void (^BaseBlock)(int,NSString*);


/*!
 *  定义参数类的block
 *
 *  @param int       错误代码 如果错误代码为 0 就是正确的
 *  @param NSString 提示消息
 *  @param id
 */
typedef void (^WithResultObjectBlock)(int,NSString*,id);

/*!
 @class
 @abstract 调用Action的传入参数
 */
@interface BMBaseParam : NSObject

/*!
 *  array 参数
 */
@property (nonatomic,strong) NSMutableArray* paramArray;

/*!
 *  dictionary 参数
 */
@property (nonatomic,strong) NSMutableDictionary* paramDic;

/*!
 *  string 参数
 */
@property (nonatomic,strong) NSString* paramString;

/*!
 *  object 参数
 */
@property (nonatomic,strong) NSObject* paramObject;

/*!
 *  int 参数
 */
@property (nonatomic,strong) NSObject* paramInt;

/*!
 *  Bool 参数
 */
@property (readwrite) BOOL paramBool;


/*!
 *  方法调用完成
 */
@property (readwrite) BOOL isFinished;

/*!
 *  block 参数
 */
@property (nonatomic,strong) BaseBlock baseblock;
/*!
 *  block 参数
 */
@property (nonatomic,strong) WithResultObjectBlock withresultobjectblock;



    
    

@end
