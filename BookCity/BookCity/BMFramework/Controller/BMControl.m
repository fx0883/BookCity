#import "BMDefine.h"
#import "BMCmdDefine.h"
#import "BMControl.h"
#import "BMBaseAction.h"
#import "BMActionManager.h"
#import "NSMutableDictionary+XSDic.h"
#import "BMContext.h"
#import "ServiceInspector_WindowHook.h"
@implementation BMControl
DEF_SINGLETON(BMControl)


-(id)init
{
    self = [super init];
    if (self)
    {
        [self loadData];
    }
    return self;
}

-(void)loadData
{
    SharedBMContext;
    

    NSNumber *numberType = [SharedBMContext getContextDicForKey:DEFSHOWTOUCHEVENTUI];
    BOOL bIsDebug = [numberType boolValue];
    if (bIsDebug) {
        [UIWindow hook];
    }
}

-(void)loadConfig
{
    
}

-(void)excute:(NSMutableDictionary*)dicparam {
    [SharedActionManager excute:dicparam];
}




@end
