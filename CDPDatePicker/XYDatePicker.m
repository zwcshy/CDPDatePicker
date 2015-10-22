//
//  ViewController.m
//  CDPDatePicker
//
//  Created by 周文超 on 15/7/8.
//  Copyright (c) 2015年 com.xyre.com. All rights reserved.
//

#import "XYDatePicker.h"

#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss")
#define kDEFAULT_DATE_FORMAT (@"yyyy-MM-dd")
#define kDEFAULT_TIME_FORMAT (@"HH:mm")
#define kDEFAULT_DATE_TIME_FORMAT2 (@"yyyyMMddHHmmss")
#define kDEFAULT_DATE_TIME_FORMAT3 (@"yyyy-MM-dd HH:mm")

//请求业务类型定义
typedef enum {
    DateFormatterDateAndTime,
    DateFormatterDate,
    DateFormatterTime,
    DateFormatterDateAndTime2,
    DateFormatterDateAndTime3
} DateFormatterStyle;

@implementation XYDatePicker

-(id)initWithSelectTitle:(NSString *)title viewOfDelegate:(UIView *)view delegate:(id<XYDatePickerDelegate>)delegate{
    if (self=[super init]) {
        _view=view;
        _delegate=delegate;

        //生成日期选择器
        _datePickerView=[[UIView alloc] initWithFrame:CGRectMake(0,_view.bounds.size.height,_view.bounds.size.width,_view.bounds.size.height*0.40243)];
        _datePickerView.backgroundColor=[UIColor whiteColor];
        [_view addSubview:_datePickerView];
        
        _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,_view.bounds.size.height*0.06042,_view.bounds.size.width,0)];

        NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;

        [_datePickerView addSubview:_datePicker];
        
        _dateLabel=[[UILabel alloc] initWithFrame:CGRectMake((_view.bounds.size.width - 140) / 2,5,_view.bounds.size.width/2,_view.bounds.size.height*0.07042)];
        if (title) {
            _dateLabel.text=title;
        }
        else{
            _dateLabel.text=@"请选择日期";
        }
        _dateLabel.textAlignment=NSTextAlignmentCenter;
        _dateLabel.textColor=[UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:16];
        _dateLabel.backgroundColor=[UIColor whiteColor];
        [_datePickerView addSubview:_dateLabel];

        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10,10,60,_view.bounds.size.height*0.05042)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor grayColor]];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(popDatePicker) forControlEvents:UIControlEventTouchUpInside];
//        _cancelButton.layer.cornerRadius = 5;
//        _cancelButton.layer.masksToBounds = YES;
        [_datePickerView addSubview:_cancelButton];

        _dateConfirmButton=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width- 70  ,10,60,_view.bounds.size.height*0.05042)];
        [_dateConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _dateConfirmButton.userInteractionEnabled=YES;
        [_dateConfirmButton addTarget:self action:@selector(dateConfirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_dateConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dateConfirmButton.backgroundColor=[UIColor orangeColor];
        _dateConfirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        _dateConfirmButton.layer.cornerRadius = 5;
//        _dateConfirmButton.layer.masksToBounds = YES;
        [_datePickerView addSubview:_dateConfirmButton];

    }
    return self;
}

//确定选择
-(void)dateConfirmClick{
    NSString *string= [self stringFromDate:_datePicker.date forDateFormatterStyle:_theTypeOfDatePicker];
    [self.delegate CDPDatePickerDidConfirm:string];
    [self popDatePicker];
    _datePicker.date =[NSDate date];
}

//是否可选择以前的时间
-(void)setIsBeforeTime:(BOOL)isBeforeTime{
    if (isBeforeTime==NO) {
        [_datePicker setMinimumDate:[NSDate date]];
    }
    else{
        [_datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
    }
}

//datePicker显示类别
-(void)setTheTypeOfDatePicker:(int)theTypeOfDatePicker{
    if (theTypeOfDatePicker==1) {
        //只显示时间
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if(theTypeOfDatePicker==2){
        //只显示日期
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if(theTypeOfDatePicker==3){
        //时间与日期都显示
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else{
        NSLog(@"时间类别选择错误");
    }
}
#pragma mark pickerView动画效果
//出现
-(void)pushDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.frame=CGRectMake(0,_view.bounds.size.height-_view.bounds.size.height*0.42243,_view.bounds.size.width,_view.bounds.size.height*0.42243);
    }];
}
//消失
-(void)popDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.frame=CGRectMake(0,_view.bounds.size.height,_view.bounds.size.width,_view.bounds.size.height*0.42243);
    }];
}

// 设置日期格式
- (NSString *)stringFromDate:(NSDate *)date  forDateFormatterStyle:(DateFormatterStyle)dateFormatterStyle
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];

    if (dateFormatterStyle == DateFormatterDateAndTime) {
        [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    }
    else if (dateFormatterStyle == DateFormatterDate){
        [formatter setDateFormat:kDEFAULT_DATE_FORMAT];
    }
    else if (dateFormatterStyle == DateFormatterTime){
        [formatter setDateFormat:kDEFAULT_TIME_FORMAT];
    }
    else if (dateFormatterStyle == DateFormatterDateAndTime2){
        [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT2];
    }
    else if (dateFormatterStyle == DateFormatterDateAndTime3){
        [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT3];
    }
    else {
        [formatter setDateFormat:kDEFAULT_DATE_FORMAT];
    }
    return [formatter stringFromDate:date];
}

-(void)dealloc{
    self.delegate=nil;
}

@end
