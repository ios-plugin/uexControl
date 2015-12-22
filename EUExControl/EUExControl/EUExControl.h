//
//  EUExControl.h
//  AppCan
//
//  Created by AppCan on 11-11-23.
//  Copyright 2011 AppCan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUExBase.h"
#import "DatePicker.h"
#import "InputDialog.h"
#import "MonthPicker.h"
#define UEX_JKYEAR  @"year"
#define UEX_JKMONTH  @"month"
#define UEX_JKDAY    @"day"
#define UEX_JKHOUR   @"hour"
#define UEX_JKMUNUTE  @"minute"
#define UEX_JKSECOND  @"second"
#define UEX_JKWEEK    @"week"


@interface EUExControl : EUExBase <InputDialogDelegate,UITextViewDelegate>{
    DatePicker *dateObj;
    MonthPicker *monthObj;
	InputDialog *inputObj;
    BOOL inputHasDisplay;
    UIView *containView;
    UITextView *tv;
}

@property (nonatomic, retain) DatePicker * dateObj;
@property (nonatomic, retain)MonthPicker *monthObj;
@property (nonatomic, retain) InputDialog * inputObj;
@property (nonatomic, assign) BOOL isDataPickerDidOpen;
@property(nonatomic,strong)NSString  * diaLogColor;
@property(nonatomic,strong)NSString  * dialogButBg;
@property(nonatomic,strong)NSString  * dialogETBg;


-(void)uexOpenDatePickerWithOpId:(int)inOpId dataType:(int)inDataType data:(NSString*)inData;
-(void)uexOpenMonthPickerWithOpId:(int)inOpId dataType:(int)inDataType data:(NSString*)inData;
-(void)uexOpenTimerPickerWithOpId:(int)inOpId dataType:(int)inDataType data:(NSString*)inData;
@end
