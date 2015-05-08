//
//  MonthPicker.h
//  AppCanPlugin
//
//  Created by zhijian du on 15/1/27.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderView.h"
#import "CDatePickerViewEx.h"
@class EUExControl;

@interface MonthPicker : NSObject<HeaderViewDelegate,UIPickerViewDelegate,UIPopoverControllerDelegate>{
    UIView *mainView;
    EUExControl *euexObj;
    HeaderView *toolView;
    NSNumber *pickerType;
    CDatePickerViewEx *monthPcikerView;
    NSMutableDictionary *selectValue;
    UIPopoverController *popcontroller;
}

@property(nonatomic, retain)UIView *mainView;
@property(nonatomic, assign)EUExControl *euexObj;
@property(nonatomic, retain)HeaderView *toolView;
@property(nonatomic, assign)NSNumber *pickerType;
@property(nonatomic, retain)CDatePickerViewEx *monthPcikerView;
@property(nonatomic, retain)NSMutableDictionary *selectValue;
@property(nonatomic, retain)UIPopoverController *popController;

-(id)initWithEuex:(EUExControl *)euexObj_;
-(void)showMonthPickerWithType:(int)type date:(NSDate *)inDate;
@end
