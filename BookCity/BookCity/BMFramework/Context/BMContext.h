/*!
 @header BMContext
 @abstract BMContext
 @author FS (作者信息)
 @version 1.00 2014/10/12 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "BMDefine.h"



/*!
 @class
 @abstract 当前程序的上下文类
 */
@interface BMContext : NSObject
/*!
 *  单例宏的调用
 */
AS_SINGLETON(BMContext)

/*!
 *  @brief 刷新页面的存储
 */
@property (nonatomic,strong) NSMutableDictionary *dicRefresh;


/*!
 *  @brief 根据所给的key得到要刷新的界面
 *
 *  @param strkey
 *
 *  @return 是否需要刷新
 */
-(BOOL)getRefreshView:(NSString*)strkey;

/*!
 *  @brief 设置需要刷新的界面
 *
 *  @param strkey 刷新的界面的key
 *  @param flag   是否需要刷新
 */
-(void)setRefreshView:(NSString*)strkey
         refreshValue:(BOOL)flag;


/*!
 *  用NSMutableDictionary的方式存储部分上下文
 */
@property (nonatomic,strong) NSMutableDictionary *dicContext;

/*!
 *  设置配置数据
 *
 *  @param anObject value
 *  @param aKey     key
 */
-(void)setContextDic:(id)anObject forKey:(id <NSCopying>)aKey;

/*!
 *  根据key获取核心配置数据
 *
 *  @param aKey key
 *
 *  @return value
 */
-(id)getContextDicForKey:(id)aKey;

/*!
 *  保存配置数据，暂时没有实现
 */
-(void)saveContext;

/*!
 @property
 @abstract bundle
 */
@property (strong,nonatomic)NSBundle * bundle;
@end
/*!
 *  BMContext单例
 */
#define SharedBMContext  ([BMContext sharedInstance])