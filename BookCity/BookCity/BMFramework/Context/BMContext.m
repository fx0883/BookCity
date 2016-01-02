

#import "BMContext.h"

#define COREBUNDLENAME @"CoreBundle"
#define CORECONFIGNAME @"CoreConfig"
@implementation BMContext

DEF_SINGLETON(BMContext)



-(id)init
{
    self=[super init];
    if (self) {
        [self loadData];
    }
    return self;
}

-(void)loadData
{

    self.dicRefresh=[NSMutableDictionary dictionaryWithCapacity:5];
    [self loadDicContextConfig];
}


-(void)loadDicContextConfig
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:COREBUNDLENAME ofType:@"bundle"];
    _bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *plistPath = [_bundle pathForResource:CORECONFIGNAME ofType:@"plist" inDirectory:CORECONFIGNAME];
    
    if ([plistPath length]>0) {
        self.dicContext = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    
    
}

-(BOOL)getRefreshView:(NSString*)strkey
{
    BOOL flag=NO;
    if (self.dicRefresh ) {
        NSNumber* number=[self.dicRefresh valueForKey:strkey];
        if (number) {
            flag=[number boolValue];
        }
    }
    return flag;
}
-(void)setRefreshView:(NSString*)strkey
         refreshValue:(BOOL)flag
{
    if (self.dicRefresh) {
        [self.dicRefresh setObject:[NSNumber numberWithBool:flag] forKey:strkey];
    }
}

-(void)setContextDic:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (self.dicContext) {
        [self.dicContext setObject:anObject forKey:aKey];
    }
}

-(id)getContextDicForKey:(id)aKey
{
    id obj=nil;
    if (self.dicContext) {
        obj = [self.dicContext objectForKey:aKey];
    }
    return obj;
}

-(void)saveContext
{
    
}


@end
