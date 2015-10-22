//
//  ViewController.m
//  CDPDatePicker
//
//  Created by 周文超 on 15/7/8.
//  Copyright (c) 2015年 com.xyre.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol XYDatePickerDelegate <NSObject>

-(void)CDPDatePickerDidConfirm:(NSString *)confirmString;

@end

@interface XYDatePicker : NSObject{
    UIView *_datePickerView;//datePicker背景
    UIDatePicker *_datePicker;//datePicker
    UILabel *_dateLabel;//标题title
    UIView *_view;//delegateView
    UIButton *_cancelButton;
    UIButton *_dateConfirmButton;//确定Button
    
}

@property (nonatomic,weak) id <XYDatePickerDelegate> delegate;

//是否可选择今天以前的时间,默认为YES
@property (nonatomic,assign) BOOL isBeforeTime;

//datePicker显示类别,分别为1=只显示时间,2=只显示日期，3=显示日期和时间(默认为3)
@property (nonatomic,assign) int theTypeOfDatePicker;

-(id)initWithSelectTitle:(NSString *)title viewOfDelegate:(UIView *)view delegate:(id<XYDatePickerDelegate>)delegate;

//出现
-(void)pushDatePicker;
//消失
-(void)popDatePicker;

@end
