//
//  SignInService.h
//  TCS
//
//  Created by WeibaYeQiang on 16/5/5.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void(^SignInResponse)(BOOL);

@interface SignInService : NSObject


- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(SignInResponse)completeBlock;

@end
