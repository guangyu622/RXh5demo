//
//  HfNetworkRequest.h
//  shengshibaye
//
//  Created by kafi on 2017/2/20.
//  Copyright © 2017年 tanwansh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HfNetworkRequest : NSObject

//获取实例
+ (HfNetworkRequest *)getInstance;

/****************************************************
 *  函数名:  installActivateStatistics
 *  功  能:  安装激活统计
 *  入  参:  无
 *  出  参:  无
 *  说  明:  无
 ****************************************************/
- (void)installActivateStatistics;

/****************************************************
 *  函数名:  getUpdateFlagWith
 *  功  能:  获取更新标志
 *  入  参:
 *			(NSString *)   currenVersion   当前版本号
 *			(NSString *)   clientid        客户端id
 *          (NSString *)   agentid         渠道id
 *          (NSString *)   os              操作平台
 *  出  参:  无
 *  说  明:  无
 ****************************************************/
- (void)getUpdateFlagWith:(NSString *)currentVersion
                 clientID:(NSString *)clientid
                  agentID:(NSString *)agentid
          operatingSystem:(NSString *)os;

@end
