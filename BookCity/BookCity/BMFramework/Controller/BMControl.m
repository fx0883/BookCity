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

-(void)excute:(NSMutableDictionary*)dicparam
{
    NSNumber *numberType = [SharedBMContext getContextDicForKey:DEFACTIONINVOKETYPE];
    NSInteger intType = [numberType integerValue];
    
    switch (intType) {
        case 0:
        {
            NSString* aId =   [dicparam getActionID];
            BMBaseAction* baseaction=[[BMActionManager sharedInstance] getAction:aId];
            [baseaction excute:dicparam];
        }
            break;
        case 1:
        {
            [SharedActionManager excute:dicparam];
        }
            
            break;
        default:
            break;
    }
    
  
    
}




@end
