//
//  ViewController.m
//  TCS
//
//  Created by WeibaYeQiang on 16/5/3.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import "ViewController.h"
#import "SignInService.h"

@interface ViewController ()

@property (nonatomic, strong) SignInService *signInServie;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.title = @"Reactive Sign In";
    [self signInSignal_2];
}

//01 监听textField输入变化
- (void)function1 {
    
    [self.userName.rac_textSignal subscribeNext:^(NSString *text) {
        NSLog(@"%@",text);
    }];
    
}

//02 监听输入字符串长度
- (void)function2 {
    
    //第一次进来是string类型
    [[self.password.rac_textSignal map:^id(NSString *text) {
        
        return @(text.length);
    }] subscribeNext:^(NSNumber *num) { //通过map转换后的是number类型数据
        NSLog(@"%@",num);
    }];
    
}

//03 监听输入字符串是否满足一定长度要求（输出字符）
- (void)function3 {
    
    //第一次传递的是string类型
    [[self.userName.rac_textSignal
      //filter 主要用于判断条件，不影响下一级的传递参数
      filter:^BOOL(NSString *text) {
        
        return text.length > 3;
    }] subscribeNext:^(NSString *text) {
        NSLog(@"%@",text);
    }];
    
}

//04 监听输入字符串是否满足一定长度要求（输出长度）
- (void)function4_1 {
    //01 判断长度条件
    //02 返回字符串长度
    //03 输出长度
    [[[self.userName.rac_textSignal filter:^BOOL(NSString *text) {
        return text.length > 3;
    }] map:^id(NSString *text) {
        return @(text.length);
    }] subscribeNext:^(NSNumber *num) {
        NSLog(@"userName >>> %@",num);
    }];
    
}

- (void)function4_2 {
    //01 返回字符串长度
    //02 判断返回的长度条件
    //03 输出长度
    [[[self.password.rac_textSignal map:^id(NSString *text) {
        return @(text.length);
    }]
      filter:^BOOL(NSNumber *num) {
        return [num floatValue] > 3;
    }]
     subscribeNext:^(NSNumber *num) {
        NSLog(@"password >>> %@",num);
    }];
    
}

//05 判断输入框的内容是否有效
- (void)function5 {
    
    [[self.userName.rac_textSignal
      map:^id(NSString *text) {
        return [self isValidUsername:text];
    }]
     subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

- (NSString *)isValidUsername:(NSString *)text {
    if (text.length > 0) {
        return @"输入有效";
    }
    return @"输入无效";
}

//06 转换信号，按输入长度改变输入框的颜色
- (void)function6_1 {
    
    [[self.userName.rac_textSignal map:^id(NSString *text) {
        return (text.length > 3)?[UIColor redColor]:[UIColor yellowColor];
    }] subscribeNext:^(UIColor *color) {
        self.userName.backgroundColor = color;
    }];
    
}

//更简洁的改变颜色方法
- (void)function6_2 {
    
    RAC(self.password, backgroundColor) = [[self.password.rac_textSignal map:^id(NSString *text) {
        return @(text.length);
    }] map:^id(NSNumber *num) {
        NSInteger i =
        [num floatValue]/3;
        switch (i) {
            case 0:
                return [UIColor clearColor];
                break;
            case 1:
                return [UIColor yellowColor];
                break;
            case 2:
                return [UIColor blueColor];
                break;
                
            default:
                return [UIColor redColor];
                break;
        }
    }];
}

//07 聚合方法（只有username,password都有效时，按钮才有效）
- (void)function7 {
    
    RACSignal *userNameSignal = [self.userName.rac_textSignal map:^id(NSString *text) {
        return @([self aboutUserName:text]);
    }];
    
    RACSignal *passwordSignal = [self.password.rac_textSignal map:^id(NSString *text) {
        return @([self aboutPassWord:text]);
    }];
    
    RACSignal *signInActiveSignal =
    [[RACSignal combineLatest:@[userNameSignal, passwordSignal] reduce:^id(NSNumber *usernameNum,NSNumber *passwordNum) {
        return @([usernameNum boolValue] && [passwordNum boolValue]);
    }]
     subscribeNext:^(NSNumber *num) {
        self.signIn.enabled = [num boolValue];
    }];
    
    
//    [[self.signIn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"denglu");
//    }];
    
}

- (BOOL)aboutUserName:(NSString *)text {
    if (text.length > 0) {
        return YES;
    }return NO;
}

- (BOOL)aboutPassWord:(NSString *)text {
    if (text.length > 0) {
        return YES;
    }return NO;
}

//08 登录函数
- (RACSignal *)signInSignal_1 {
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInServie signInWithUsername:self.userName.text password:self.password.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
}

//通过封装登陆API实现登陆
- (void)signInSignal_2 {
    [[[self.signIn rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^RACStream *(id value) {
          return [self signInSignal_3];
      }] subscribeNext:^(NSNumber *value) {
          BOOL success = [value boolValue];
          self.timeLabel.text = success?@"success !":@"failed !";
      }];
}

- (RACSignal *)signInSignal_3 {
    
    //一定要创建对象！！！
    if (self.signInServie == nil) {
        self.signInServie = [[SignInService alloc] init];
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [self.signInServie signInWithUsername:self.userName.text
                                     password:self.password.text
                                     complete:^(BOOL success) {
                                         
                                         
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

//设置开关信号
- (void)switchFunction {
    
    //创建自定义的信号
    RACSubject *baidu = [RACSubject subject];
    RACSubject *google = [RACSubject subject];
    RACSubject *sougou = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    //开关信号
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    //对通过开关的信号进行批量操作
    [[switchSignal map:^id(NSString *value) {
        return [@"http://www." stringByAppendingString:value];
    }] subscribeNext:^(NSString *url) {
        NSLog(@"%@",url);
    }];
    
    
    
    
    
    [signalOfSignal sendNext:baidu];
    //按顺序执行一次
    [baidu sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
}


//组合信号
- (void)combiningLatest {
    
    RACSubject *numbers = [RACSubject subject];
    RACSubject *letters = [RACSubject subject];
    
    //要有输入信号才能触发信号流
    [[RACSignal  combineLatest:@[numbers,letters]reduce:^id(NSString *number, NSString *letter){
        return [number stringByAppendingString:letter];
    }] subscribeNext:^(NSString *newStr) {
        NSLog(@"newStr >>> %@",newStr);
    }];
    
    [numbers sendNext:@"1"];
    [numbers sendNext:@"2"];
    [letters sendNext:@"A"];
    [numbers sendNext:@"3"];
    [letters sendNext:@"B"];
    [letters sendNext:@"C"];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
