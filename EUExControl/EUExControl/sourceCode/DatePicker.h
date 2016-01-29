//
//  DatePicker.h
//  AppCan
//
//  Created by AppCan on 11-11-23.
//  Copyright 2011 AppCan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderView.h"
@class EUExControl;

@interface DatePicker : NSObject <HeaderViewDelegate,UIPickerViewDelegate,UIPopoverControllerDelegate>{
	UIView *mainView;
	EUExControl *euexObj;
	HeaderView *toolView;
	NSNumber *pickerType;
	UIDatePicker *pickerView;
	NSMutableDictionary *selectValue;
	UIPopoverController *popController;
}

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, assign) EUExControl *euexObj;
@property (nonatomic, retain) HeaderView *toolView;
@property (nonatomic, assign) NSNumber *pickerType;
@property (nonatomic, retain) UIDatePicker *pickerView;
@property (nonatomic, retain) NSMutableDictionary *selectValue;
@property (nonatomic, retain) UIPopoverController *popController;
@property float tagID;

-(id)initWithEuex:(EUExControl *)euexObj_;
-(void)showDatePickerWithType:(int)type date:(NSDate *)inDate;
-(void)showDatePickerWithType:(int)type date:(NSDate *)inDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate tag:(float)tag;
@end
