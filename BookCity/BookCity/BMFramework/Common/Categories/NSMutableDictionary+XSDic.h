
/*!
 @header NSMutableDictionary
 @abstract NSMutableDictionary的Categories主要提供给BaseParam类解析用
 @author Fengxuan
 @version 1.00
 */
#import <Foundation/Foundation.h>
/*!
 *  @class
 *  @abstract NSMutableDictionary Category
 */
@interface NSMutableDictionary(XSDic)


/*!
 *  @brief 创建一个NSMutableDictionary
 *
 *  @return 创建成功的NSMutableDictionary
 */
+(NSMutableDictionary*)createParamDic;


/*!
 *  @brief 根据key得到Value
 *
 *  @param strKey key
 *
 *  @return value
 */
-(NSString*)getDicString:(NSString*)strKey;

/*!
 *  @brief 设置dic中一项
 *
 *  @param strKey
 *  @param strValue
 */
-(void)setDicString:(NSString*)strKey
              Value:(NSString*)strValue;

/*!
 *  @brief 设置ActionID的命令
 *
 *  @param stractionId
 *  @param strCmd      命令
 */
-(void)setActionID:(NSString*)stractionId
               strcmd:(NSString*)strCmd;

/*!
 *  @brief 设置参数
 *
 *  @param object
 */
-(void)setParam:(id)object;

/**
 *  @brief 获取ActionId
 *
 *  @return 得到ActionId
 */
-(NSString*)getActionID;

/*!
 *  @brief 获取调用Action的命令
 *
 *  @return 命令
 */
-(NSString*)getCmd;
/**
 *  @brief 获取参数得到String
 *
 *  @return 得到参数
 */
-(NSString*)getParamAsString;

/*!
 *  @brief 得到参数
 *
 *  @return 参数
 */
-(id)getParam;
/**
 *  @brief 得到函数调用返回结果
 *
 *  @return 结果
 */
-(id)getResult;
/*!
 *  @brief 得到函数调用返回结果
 *
 *  @return 结果String
 */
-(NSString*)getResultAsString;



@end
