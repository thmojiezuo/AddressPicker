//
//  AddressSelector.m
//  AddressPicker
//
//  Created by tenghu on 2017/10/23.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "AddressSelector.h"

@interface AddressSelector ()<UIPickerViewDataSource,UIPickerViewDelegate>

{
    CGFloat h ; //弹出视图的高度
}
//当前选择的地址
@property (strong, nonatomic) NSString *currentSelected;
@property (strong, nonatomic) NSString *currentSubSelected;
@property (strong, nonatomic) NSString *currentthirdSelected;
//背景view
@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) void(^RENSelectorBlock)(NSString *,NSString *,NSString *);
//数据源
@property(nonatomic,retain)NSDictionary* dict;
@property(nonatomic,retain)NSArray* pickerArray;
@property(nonatomic,retain)NSArray* subPickerArray;
@property(nonatomic,retain)NSArray* thirdPickerArray;
@property(nonatomic,retain)NSArray* selectArray;

@end

@implementation AddressSelector

- (instancetype)init {
    if (self = [super init])
    {
        self.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        h  = 260;
        _blackView = [[UIView alloc] initWithFrame:self.frame];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0;
        [self addSubview:_blackView];
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), h)];
        _bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgView];
        
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(determineAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(CGRectGetWidth(self.frame)-60, 0, 50, 44);
        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_bgView addSubview:button];
        
        
        NSString* plistPath=[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
        _dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSArray *proArr  = @[@"北京市",@"天津市",@"上海市",@"重庆市",@"澳门",@"安徽省",@"福建省",@"广东省",@"广西省",@"贵州省",@"甘肃省",@"海南省",@"河北省",@"河南省",@"湖南省",@"湖北省",@"黑龙江省",@"吉林省",@"江西省",@"江苏省",@"辽宁省",@"内蒙古",@"宁夏",@"青海省",@"四川省",@"山西省",@"陕西省",@"山东省",@"台湾省",@"西藏",@"新疆",@"香港",@"云南省",@"浙江省"];
        // self.pickerArray=_dict.allKeys;
        self.pickerArray = proArr;
        //  self.selectArray=[_dict objectForKey:[[_dict allKeys] objectAtIndex:0]];
        self.selectArray=[_dict objectForKey:[proArr objectAtIndex:0]];
        if ([_selectArray count]>0) {
            self.subPickerArray= [[self.selectArray objectAtIndex:0] allKeys];
        }
        if ([_subPickerArray count]>0) {
            self.thirdPickerArray=[[self.selectArray objectAtIndex:0] objectForKey:[self.subPickerArray objectAtIndex:0]];
        }
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.frame), h-44)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_bgView addSubview:_pickerView];
        
    }
    return self;
}
#pragma mark--UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.pickerArray count];
    }else if (component == 1) {
        return [self.subPickerArray count];
    }else if (component == 2) {
        return [self.thirdPickerArray count];
    }
    return 0;
}

#pragma mark--UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row is %ld,Component is %ld",(long)row,(long)component);
    if (component == 0) {
        
        self.currentSelected =[self.pickerArray objectAtIndex:row];
        self.selectArray=[_dict objectForKey:[self.pickerArray objectAtIndex:row]];
        if ([self.selectArray count]>0) {
            self.subPickerArray= [[self.selectArray objectAtIndex:0] allKeys];
        }else{
            self.subPickerArray=nil;
        }
        if ([self.subPickerArray count]>0) {
            self.thirdPickerArray=[[self.selectArray objectAtIndex:0] objectForKey:[self.subPickerArray objectAtIndex:0]];
        }else{
            self.thirdPickerArray=nil;
        }
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:2];
        
        
    }
    if (component == 1) {
        self.currentSubSelected =[self.subPickerArray objectAtIndex:row];
        if ([_selectArray count]>0&&[_subPickerArray count]>0) {
            self.thirdPickerArray=[[self.selectArray objectAtIndex:0] objectForKey:[self.subPickerArray objectAtIndex:row]];
        }else{
            self.thirdPickerArray = nil;
        }
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];
    
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    if (component == 0) {
        self.currentSelected =[self.pickerArray objectAtIndex:row];
        
        NSDictionary * attrDic = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[self.pickerArray objectAtIndex:row] attributes:attrDic];
        return attrString;
        
    }else if (component == 1) {
        self.currentSubSelected =[self.subPickerArray objectAtIndex:row];
        
        NSDictionary * attrDic = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[self.subPickerArray objectAtIndex:row] attributes:attrDic];
        return attrString;
        
    }else if (component ==  2) {
        self.currentthirdSelected =[self.thirdPickerArray objectAtIndex:row];
        NSDictionary * attrDic = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[self.thirdPickerArray objectAtIndex:row] attributes:attrDic];
        return attrString;
        
    }
    return nil;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    NSAttributedString * attrString = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    pickerLabel.attributedText = attrString;
    return pickerLabel;
}
#pragma mark - 点击确定
- (void)determineAction {
    
    self.RENSelectorBlock(self.currentSelected,self.currentSubSelected,self.currentthirdSelected);
    [self disappear];
}
#pragma mark - 视图出现
- (void)show {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _blackView.alpha = 0.4;
        _bgView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-h-20, CGRectGetWidth(self.frame), h);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            _bgView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-h, CGRectGetWidth(self.frame), h);
        }];
    }];
    
    [_pickerView reloadAllComponents];
}
#pragma mark - 视图消失
- (void)disappear {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _blackView.alpha = 0;
        _bgView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), h);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *t = [touches anyObject];
    
    CGPoint point = [t locationInView:self];
    
    if (!CGRectContainsPoint(_bgView.frame,point)) {
        [self disappear];
    }
}

+ (void)showSelectorwithComplete3:(void(^)(NSString *,NSString *,NSString *))results{
    AddressSelector *selector = [[AddressSelector alloc] init];
    selector.RENSelectorBlock = results;
    selector.tag = 600;
    [selector show];
    [[UIApplication sharedApplication].keyWindow addSubview:selector];
    
}

@end
