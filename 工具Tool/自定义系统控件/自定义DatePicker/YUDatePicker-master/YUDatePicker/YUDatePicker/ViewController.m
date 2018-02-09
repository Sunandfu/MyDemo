//
//  ViewController.m
//  YUDatePicker
//
//  Created by BruceYu on 15/4/12.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "ViewController.h"
#import "YUDatePicker.h"

@interface ViewController ()<UITextFieldDelegate>{
    UITextField *txtField;
    
}
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation ViewController

-(YUDatePicker*)datePicker{
    YUDatePicker *datePicker = [ [ YUDatePicker alloc] init];
    datePicker.datePickerMode = UIYUDatePickerModeDateYYYYMMDDHHmm;
    
    NSDate* minDate = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate* maxDate = [NSDate date];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.date = maxDate;

    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    return datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)dateChanged:(id)sender{
    YUDatePicker* control = (YUDatePicker*)sender;
//    NSDate *_date = control.date;
    /*添加你自己响应代码*/
    //    NSLog(@"date ==%@ ",[XYNSDate dateToString:_date]);
    NSLog(@"date ==%@ ",control.dateStr);
    txtField.text = control.dateStr;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    YUDatePicker *datePicker = self.datePicker;
    datePicker.datePickerMode = (YUUIDatePickerMode)textField.tag;
    textField.inputAccessoryView = datePicker;
    txtField = textField;
}



//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
