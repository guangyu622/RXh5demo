//
//  HfNetworkRequest.m
//  shengshibaye
//
//  Created by kafi on 2017/2/20.
//  Copyright © 2017年 tanwansh. All rights reserved.
//

#import "HfNetworkRequest.h"
#import "HfKeyDefine.h"
#import "HfMd5.h"
#import <AdSupport/AdSupport.h>
#import "HfCommon.h"

static HfNetworkRequest *_HfNetworkRequest = nil;

@interface HfNetworkRequest ()
@property (nonatomic,strong) NSDictionary *dictData;
@end

@implementation HfNetworkRequest

#pragma mark - 初始化
+ (HfNetworkRequest *)getInstance{
    @synchronized (self) {
        if (_HfNetworkRequest == nil) {
            _HfNetworkRequest = [[HfNetworkRequest alloc] init];
        }
    }
    return _HfNetworkRequest;
}

-(id)init{
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark - 公用方法
-(NSArray*)attributeWithKey:(NSString*)strKey strValue:(NSString*)strValue
{
    if ([strKey length] > 0)
    {
        return [NSArray arrayWithObjects:strKey, (strValue != nil ? strValue : @""), nil];
    }
    else
    {
        return [NSArray array];
    }
}

-(NSArray*)attributeWithKey:(NSString*)strKey intValue:(NSInteger)iValue
{
    if ([strKey length] > 0)
    {
        NSString* strVal = [NSString stringWithFormat:@"%ld", (long)iValue];
        return [NSArray arrayWithObjects:strKey, strVal, nil];
    }
    else
    {
        return [NSArray array];
    }
}

-(NSArray*)attributeWithKey:(NSString*)strKey floatValue:(double)fValue
{
    if ([strKey length] > 0)
    {
        NSString* strVal = [NSString stringWithFormat:@"%.00f", fValue];
        return [NSArray arrayWithObjects:strKey, strVal, nil];
    }
    else
    {
        return [NSArray array];
    }
}

-(NSArray*)attributeWithKey:(NSString*)strKey longValue:(long)lValue
{
    if ([strKey length] > 0)
    {
        NSString* strVal = [NSString stringWithFormat:@"%ld", lValue];
        return [NSArray arrayWithObjects:strKey, strVal, nil];
    }
    else
    {
        return [NSArray array];
    }
}

-(NSString *)connectString:(NSMutableArray *)array{
    NSString *strParameter = [NSString new];
    
    NSString *strCom = [NSString new];
    
    NSArray *arrNV = [NSArray array];
    
    NSString *strKey = [NSString new];
    
    NSString *strValue = [NSString new];
    
    for (int i = 0; i < array.count; i ++) {
        
        arrNV = [array objectAtIndex:i];
        strKey = [arrNV objectAtIndex:0];
        strValue = [arrNV objectAtIndex:1];
        
        if (i == array.count - 1) {
            strCom = [NSString stringWithFormat:@"%@=%@",strKey,strValue];
        } else {
            strCom = [NSString stringWithFormat:@"%@=%@&",strKey,strValue];
        }
        
        strParameter = [strParameter stringByAppendingString:strCom];
    }
    
    return strParameter;
}

#pragma mark - get请求
- (void)getDataWithUrlStr:(NSString *)urlStr successNotif:(NSString *)successnotif failNotif:(NSString *)failnotif{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:urlStr];
        
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
        
    //4.根据会话对象创建一个Task(发送请求）
    /*
        第一个参数：请求对象
        第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
        data：响应体信息（期望的数据）
        response：响应头信息，主要是对服务器端的描述
        error：错误信息，如果请求失败，则error有值
    */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if (failnotif != nil || failnotif != NULL || failnotif.length != 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:failnotif object:nil];
            }
            
            return ;
        }
        
        //用于调试时直接查看后台返回的数据，请勿删除
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"htResult:%@",result);
        
        //6.解析服务器返回的数据
        //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (successnotif != nil || successnotif != NULL || successnotif.length != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:successnotif object:nil userInfo:dict];
        }
        
    }];
    
    //5.执行任务
    [dataTask resume];
}

#pragma mark - 安装激活统计
- (void)installActivateStatistics
{
    NSString *strKey = [NSString stringWithFormat:@"%@%@", HF_INSTALLACTIVEFLAG, APPID];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDef objectForKey:strKey];
    if ([value isEqualToString:@"1"]) {
        return;
    }
    
    NSMutableArray *arrLoadData = [NSMutableArray array];
    [arrLoadData addObject:[self attributeWithKey:@"appid" strValue:APPID]];
    
    NSString *flag = [NSString stringWithFormat:@"%@%@",APPID,KEY];
    [arrLoadData addObject:[self attributeWithKey:@"flag" strValue:[HfMd5 md5:flag]]];
    
    [arrLoadData addObject:[self attributeWithKey:@"imei" strValue:[HfCommon getSaveAdIDFromKeyChain]]];
    [arrLoadData addObject:[self attributeWithKey:@"model" strValue:[HfCommon GetDevideModel]]];
    
    [arrLoadData addObject:[self attributeWithKey:@"agent_id" strValue:@"100000"]];
    [arrLoadData addObject:[self attributeWithKey:@"site_id" strValue:@"100000"]];
    [arrLoadData addObject:[self attributeWithKey:@"ip" strValue:@""]];
    [arrLoadData addObject:[self attributeWithKey:@"tw_game_id" strValue:APPID]];
    
    NSString *parameterStr = [self connectString:arrLoadData];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&%@",HF_INSTALLSTATISTIC_SERVER_URL,parameterStr];
    
     urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self getDataWithUrlStr:urlStr successNotif:HF_NOTIF_INSTALLACTIVATESTATISTICS_SUCCESS failNotif:nil];
}

#pragma mark - 获取更新标志
- (void)getUpdateFlagWith:(NSString *)currentVersion
                 clientID:(NSString *)clientid
                  agentID:(NSString *)agentid
          operatingSystem:(NSString *)os
{
    NSMutableArray *arrLoadData = [NSMutableArray array];
    [arrLoadData addObject:[self attributeWithKey:@"currentversion" strValue:currentVersion]];
    [arrLoadData addObject:[self attributeWithKey:@"client_id" strValue:clientid]];
    [arrLoadData addObject:[self attributeWithKey:@"agent_id" strValue:agentid]];
    [arrLoadData addObject:[self attributeWithKey:@"os" strValue:os]];
    [arrLoadData addObject:[self attributeWithKey:@"tw_game_id" strValue:APPID]];
    
    NSString *parameterStr = [self connectString:arrLoadData];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&%@",HF_UPDATEFLAG_SERVER_URL,parameterStr];
    
    [self getDataWithUrlStr:urlStr successNotif:HF_NOTIF_UPDATEREQUEST_SUCCESS failNotif:nil];
}

@end
