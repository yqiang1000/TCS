//
//  ViewController.h
//  TCS
//
//  Created by WeibaYeQiang on 16/5/3.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signIn;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

