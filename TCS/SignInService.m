//
//  SignInService.m
//  TCS
//
//  Created by WeibaYeQiang on 16/5/5.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import "SignInService.h"

@implementation SignInService

//08 登录函数
- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock {

    NSLog(@"hellowr");
    BOOL success = NO;
    if (username.length > 0 && password.length > 0) {
        success = YES;
    }
    completeBlock(success);
    
}

- (void)setBlock:(SignInResponse)block {
    
}


@end
