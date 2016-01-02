//
//  NSMutableDictionary+XSDic.m
//  
//
//  Created by fx on 14-3-1.
//  Copyright (c) 2014年 Yixue. All rights reserved.
//

#import "NSMutableDictionary+XSDic.h"

#define paramResult @"paramResult"
#define param @"param"
#define actionId @"actionId"
#define cmd @"cmd"
#define errorCodeNumber @"errorCodeNumber"
#define errorString @"errorString"


@implementation NSMutableDictionary(XSDic)

+(NSMutableDictionary*)createParamDic
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:10];
    return dic;
}


-(NSString*)getDicString:(NSString*)strKey;
{
    NSString* strResult=nil;
    
    strResult=[self valueForKey:strKey];
    
    return strResult;
}

-(void)setDicString:(NSString*)strKey
           Value:(NSString*)strValue
{
    [self setObject:strValue forKey:strKey];
}

-(void)setActionID:(NSString*)stractionId
            strcmd:(NSString*)strCmd
{
    [self setDicString:actionId Value:stractionId];
    [self setDicString:cmd Value:strCmd];
}

-(NSString*)getActionID
{
    return [self getDicString:actionId];
}
-(NSString*)getCmd
{
    return [self getDicString:cmd];
}

-(NSString*)getParamAsString
{
    NSString* strResult=nil;
    
    strResult=[self getDicString:param];
    
    return strResult;
}

-(void)setParam:(id)object
{
    [self setObject:object forKey:param];
}

-(id)getParam
{
    return [self valueForKey:param];
}

-(id)getResult
{
    return [self valueForKey:paramResult];
}
-(NSString*)getResultAsString
{
    NSString* strResult=nil;
    
    strResult=[self getDicString:paramResult];
    
    return strResult;
}

@end
