//
//  AddressSelector.h
//  AddressPicker
//
//  Created by tenghu on 2017/10/23.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressSelector : UIView

+ (void)showSelectorwithComplete3:(void(^)(NSString *,NSString *,NSString *))results;

@end
