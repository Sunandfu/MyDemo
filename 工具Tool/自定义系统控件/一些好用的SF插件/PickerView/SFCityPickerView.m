//
//  SFCityPickerView.m
//  城市选择
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "SFCityPickerView.h"
#import "SFTool.h"

@interface SFCityPickerView ()

@property (nonatomic, strong) UIView        *showView;
@property (nonatomic, strong) UIView        *maskView;
@property (nonatomic, strong) UIWindow      *window;
@property (nonatomic, strong) UIPickerView  *pickerView;

@end

@implementation SFCityPickerView {
    
    NSArray *provinceArray;//省的数组
    NSArray *cityArray;//市的数组
    NSArray *districtArray;//区的数组
    
    
    NSString *provinceStr;//省的名字
    NSString *cityStr;//市的名字
    NSString *districtStr;//区的名字
    
    
    NSMutableDictionary *cityDic ;
    NSMutableDictionary *districtDic;
}

- (void)createAllViews{
    
    //从plist中获取数组和字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"xml"];
    NSString *str = [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    provinceArray = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    //所有省对应的城市和区
    cityDic = [[NSMutableDictionary alloc]init];
    districtDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<provinceArray.count; i++) {
        NSDictionary *proviceDic = [provinceArray objectAtIndex:i];
        provinceStr = [proviceDic objectForKey:@"name"];//省
        //因为xml文件中存在直辖市等的city类型是字典 而正常的省会是数组 所以加以区分
        if ([[proviceDic objectForKey:@"values"] isKindOfClass:[NSArray class]]) {
            cityArray = [proviceDic objectForKey:@"values"];//城市
            for (int i = 0; i<cityArray.count; i++) {
                NSDictionary *cityADic = [cityArray objectAtIndex:i];
                cityStr = [cityADic objectForKey:@"name"];//城市
                districtArray = [cityADic objectForKey:@"values"];
                if (districtArray.count != 0) {
                    //存入字典 城市 对应 区县
                    [districtDic setObject:districtArray forKey:cityStr];
                }
                
            }
            //存入字典 省对应城市
            [cityDic setObject:cityArray forKey:provinceStr];
        }
    }
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    self.window = window;
    
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [window addSubview:self.maskView];
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, window.bounds.size.height, window.bounds.size.width, 260)];
    [window addSubview:showView];
    self.showView = showView;
    self.showView.backgroundColor = [UIColor whiteColor];
    
    //添加点击手势
    UITapGestureRecognizer *maskGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskView addGestureRecognizer:maskGesture];
    
    UIEdgeInsets safeEdge = [SFTool getWindowSafeAreaInsets];
    //picker
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(safeEdge.left, 44, [SFTool getDeviceSafeAreaWidth], 260-44)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent:0 animated: YES];
    [picker reloadAllComponents];
    NSInteger rowProvince = [picker selectedRowInComponent:0];
    NSString *provinceName = provinceArray[rowProvince][@"name"];
    cityArray = cityDic[provinceName];
    NSInteger rowCity = [picker selectedRowInComponent:1];
    NSString *cityName =cityArray[rowCity][@"name"];
    districtArray = districtDic[cityName];
    //    _componentWithThreeNum=country.count;
    //    _componentWithThreeArr=country;
    //    cityId =citys[0][@"id"];
    //    districtId = _str3[0][@"id"];
    [showView addSubview:picker];
    self.pickerView = picker;
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, 44)];
    toolBar.backgroundColor = [UIColor whiteColor];
    [showView addSubview:toolBar];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(window.bounds.size.width-100-safeEdge.right, 7, 100, 30);
    finishBtn.tag = 1;
    [toolBar addSubview:finishBtn];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor colorWithRed:34/255.0 green:159/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishChoose) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(safeEdge.left, 7, 100, 30);
    cancelBtn.tag = 2;
    [toolBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:114/255.0 blue:120/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelOperate) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(safeEdge.left + 100, 0, [SFTool getDeviceSafeAreaWidth] - 200, CGRectGetHeight(toolBar.frame))];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    titleLbl.textColor = [UIColor colorWithRed:109/255.0 green:114/255.0 blue:120/255.0 alpha:1.0];
    titleLbl.tag = 3;
    [toolBar addSubview:titleLbl];
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0  ) {
        return provinceArray.count;
    }
    else if (component==1 ) {
        return cityArray.count;
    }
    else {
        return districtArray.count;
    }
}
#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {
        provinceStr =provinceArray[row][@"name"];
        return provinceStr;
    }
    if(1 == component){
        cityStr = cityArray[row][@"name"];
        return cityStr;
    }
    else{
        districtStr = districtArray[row];
        return districtStr;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.frame = CGRectMake(0, 0, ([SFTool getDeviceSafeAreaWidth])/3.0, 25);
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.numberOfLines = 0;
        pickerLabel.textAlignment=NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;{
    return ([SFTool getDeviceSafeAreaWidth])/3.0;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component){
        NSInteger rowProvince = [self.pickerView selectedRowInComponent:0];
        NSString *provinceName = provinceArray[rowProvince][@"name"];
        cityArray = cityDic[provinceName];
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        NSInteger rowCity = [self.pickerView selectedRowInComponent:1];
        //防止pickerView某列还在滑动中  而选择另一行时 引起崩溃
        if (cityArray.count-1<rowCity) {
            
        }else{
            NSString *cityName =cityArray[rowCity][@"name"];
            districtArray = districtDic[cityName];
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }
    }
    else if(1 == component)
    {
        NSInteger rowProvince = [self.pickerView selectedRowInComponent:0];
        NSString *provinceName = provinceArray[rowProvince][@"name"];
        cityArray = cityDic[provinceName];
        NSInteger rowCity = [self.pickerView selectedRowInComponent:1];
        if (cityArray.count-1<rowCity) {
            
        }else{
            NSString *cityName =cityArray[rowCity][@"name"];
            districtArray= districtDic[cityName];
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }
    }else
    {
        [pickerView reloadAllComponents];
    }
    
}


#pragma mark -UIButton action
- (void)show
{
    [self createAllViews];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        self.showView.frame = CGRectMake(0, self.window.bounds.size.height-260, self.window.bounds.size.width, 260);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, self.window.bounds.size.height, self.window.bounds.size.width, 260);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.showView removeFromSuperview];
    }];
}
//完成按钮事件
- (void)finishChoose
{
    [self dismiss];
    if (self.finishBlock != nil) {
        self.finishBlock(provinceStr,cityStr,districtStr);
    }
}

//取消按钮事件
- (void)cancelOperate
{
    [self dismiss];
}

@end
