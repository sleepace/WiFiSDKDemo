//
//  SLPApWifiConfig.h
//  SDK
//
//  Created by Martin on 2018/1/24.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SLPTCP/SLPTCP.h>

@interface SLPApWifiConfig : NSObject

- (void)configDevice:(SLPDeviceTypes)deviceType
       serverAddress:(NSString *)address port:(NSInteger)port
            wifiName:(NSString *)name
            password:(NSString *)password
          completion:(void(^)(BOOL succeed, id data))completion;

@end
