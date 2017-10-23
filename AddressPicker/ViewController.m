//
//  ViewController.m
//  AddressPicker
//
//  Created by tenghu on 2017/10/23.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "ViewController.h"
#import "AddressSelector.h"

@interface ViewController ()

@property (nonatomic ,strong)UIButton *addressBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择地址" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width-100, 50);
    [button addTarget:self action:@selector(choseAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.addressBtn = button;
    
    
}
- (void)choseAddress{
    
    [AddressSelector showSelectorwithComplete3:^(NSString *str1, NSString *str2, NSString *str3) {
        
        NSString *changestring = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        [self.addressBtn setTitle:changestring forState:UIControlStateNormal];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
