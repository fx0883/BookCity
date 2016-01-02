#import "BMBaseParam.h"
#import "BMActionManager.h"

#import "NSMutableDictionary+XSDic.h"
#import "BMContext.h"
#import "BMCmdDefine.h"


@implementation BMActionManager
DEF_SINGLETON(BMActionManager)



-(id)init
{
    self=[super init];
    if (self)
    {
        [self loadData];
    }
    return self;
}


-(void)loadData
{
    self.actionDic=[NSMutableDictionary dictionaryWithCapacity:10];
//    [self registerAllAction];
}

-(void)excute:(NSMutableDictionary*)dicparam
{
    NSString *strClassName = [dicparam getActionID];
    NSString *strFunctionName = [dicparam getCmd];
    
    //判断Action是否被注册过，如果被注册过则直接使用
    NSObject *idObject=nil;
    idObject = [self.actionDic objectForKey:strClassName];
    if (!idObject) {
        idObject =  [[NSClassFromString(strClassName) alloc]init];

        
        if (!idObject) {
            NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
            NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
            NSString*appName =[infoDict objectForKey:@"CFBundleName"];
            
            
            
            
            NSString*text =[NSString stringWithFormat:@"%@ %@",appName,versionNum];
            
            
            strClassName = [NSString stringWithFormat:@"%@.%@",appName,strClassName ];
             idObject =  [[NSClassFromString(strClassName) alloc]init];
            
            if (!idObject) {
                return;
            }
        }
        

        [self.actionDic setObject:idObject forKey:strClassName];
        idObject =  [[NSClassFromString(strClassName) alloc]init];
    }
    
    //将一个字符串方法转换成为SEL对象
    SEL sel = NSSelectorFromString(strFunctionName);
    //SEL sel = @selector(excute:);
    //判断该对象是否有相应的方法
    if ([idObject respondsToSelector:sel])
    {
        id obj = [dicparam getParam];
        if ([obj isKindOfClass:[BMBaseParam class]])
        {
            //这里可以打印出log，可以根据配置来决定是否要打印log
            
            NSNumber *numberType = [SharedBMContext getContextDicForKey:DEFSHOWACTIONLOG];
            BOOL bIsShow = [numberType boolValue];
            if (bIsShow)
            {
                NSLog(@"Invoke Action ===> Date:%@ - Class:%@ - Function:%@",[NSDate date],strClassName,strFunctionName);
            }
            
            SuppressPerformSelectorLeakWarning([idObject performSelector:sel withObject:obj]);//调用选择器方法
        }
    }
}

/**
 *  注册所有Action 新的调用Action机制中已经不需要了
 */
-(void)registerAllAction
{
    
}



-(BMBaseAction*)getAction:(NSString*)strActionId
{
    return [self.actionDic valueForKey:strActionId];
}

-(void)registAction:(NSString*)strActionId
             action:(BMBaseAction*)baseAction
{
    [self.actionDic setObject:baseAction forKey:strActionId];
}

-(void)unRegistAction:(NSString*)strActionId
{
    [self.actionDic removeObjectForKey:strActionId];
}

@end
