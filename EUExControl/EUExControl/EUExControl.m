//
//  EUExControl.m
//  AppCan
//
//  Created by AppCan on 11-11-23.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "EUExControl.h"
#import "EUtility.h"
#import "EUExBaseDefine.h"
#import "JSON.h"
@implementation EUExControl
@synthesize dateObj;
@synthesize monthObj;
@synthesize inputObj;

-(id)initWithBrwView:(EBrowserView *) eInBrwView {
	if (self = [super initWithBrwView:eInBrwView]) {
        _isDataPickerDidOpen = NO;
	}
	return self;
}

-(void)clean{
	if (dateObj) {
        self.dateObj = nil;
	}
    if(monthObj){
        self.monthObj = nil;
    }
	if (inputObj) {
        self.inputObj = nil;
	}
}

-(void)dealloc{
	if (dateObj) {
        self.dateObj = nil;
	}
    if(monthObj){
        self.monthObj = nil;
    }
	if (inputObj) {
        self.inputObj = nil;
	}
	[super dealloc];
}

-(void)openInputDialog:(NSMutableArray *)inArguments{
    if (inputHasDisplay) {
        return;
    }
    int inType = [[inArguments objectAtIndex:0] intValue];
    NSString * inHint = [inArguments objectAtIndex:1];
    
    NSString * btnTitle = [inArguments objectAtIndex:2];
	[inputObj release];
	inputObj = nil;
    
    CGRect frameOfInputObj = CGRectZero;
    float heightOfInputObj = 40;
    UIInterfaceOrientation cOrientation = [UIApplication sharedApplication].statusBarOrientation;
	if ((cOrientation == UIInterfaceOrientationLandscapeLeft) || (cOrientation == UIInterfaceOrientationLandscapeRight)) {
        frameOfInputObj = CGRectMake(0, [EUtility screenWidth] - heightOfInputObj, [EUtility screenHeight], heightOfInputObj);
    } else {
        frameOfInputObj = CGRectMake(0, [EUtility screenHeight] - heightOfInputObj, [EUtility screenWidth], heightOfInputObj);
    }
    inputObj = [[InputDialog alloc] initWithFrame:frameOfInputObj];
    [inputObj openInputWithText:inHint btnText:btnTitle KeyBoardType:inType];
    [inputObj setDelegate:self];
    [EUtility brwView:meBrwView addSubview:inputObj];
    [EUtility brwView:meBrwView forbidRotate:YES];
    inputHasDisplay = YES;
}

-(void)inputFinish:(NSString *)inputResult{
     [EUtility brwView:meBrwView forbidRotate:NO];
    inputHasDisplay = NO;
   // [self jsSuccessWithName:@"uexControl.cbInputCompleted" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:inputResult];
    [self jsSuccessWithName:@"uexControl.cbOpenInputDialog" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:inputResult];
}

-(void)inputDialogClose{
    inputHasDisplay = NO;
}

-(void)openDatePicker:(NSMutableArray *)inArguments{
    
    if (_isDataPickerDidOpen) {
        return;
    }
    
    DatePicker *tempObj = [[DatePicker alloc] initWithEuex:self];
    self.dateObj = tempObj;
    [tempObj release];
    inputHasDisplay = NO;
    _isDataPickerDidOpen = YES;
    if (![inArguments isKindOfClass:[NSMutableArray class]] || [inArguments count] < 3) {
        return;
    }
   	NSString *inYear = [inArguments objectAtIndex:0];
	NSString *inMonth = [inArguments objectAtIndex:1];
	NSString *inDay = [inArguments objectAtIndex:2];
    NSDate *inDate;
	if ([inYear isEqualToString:@""]||[inMonth isEqualToString:@""]||[inDay isEqualToString:@""]) {
		inDate = [NSDate date];
	}else {
		NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",inYear,inMonth,inDay];
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd"];
		inDate = [df dateFromString:dateStr];
		[df release];
	}
    if (inDate == nil) {
		inDate = [NSDate date];
	}
	[dateObj showDatePickerWithType:0 date:inDate];
}


-(void)openDatePickerWithoutDay:(NSMutableArray *)inArguments{
    MonthPicker *tempObj = [[MonthPicker alloc] initWithEuex:self];
    self.monthObj = tempObj;
    [tempObj release];
    
    inputHasDisplay = NO;
    NSString *inYear = [inArguments objectAtIndex:0];
    NSString *inMonth = [inArguments objectAtIndex:1];
    if ([inYear intValue]>9999||[inMonth intValue]>12) {
        [self jsFailedWithOpId:0 errorCode:1050101 errorDes:UEX_ERROR_DESCRIBE_ARGS];
        return;
    }
    NSDate *inDate;
    if ([inYear isEqualToString:@""]||[inMonth isEqualToString:@""]) {
        inDate = [NSDate date];
    }else {
        //		NSLog(@"[control opendatePicker");
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@",inYear,inMonth];
        //		 NSLog(@"datestr = %@",dateStr);
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM"];
        inDate = [df dateFromString:dateStr];
        //		 NSLog(@"inldate = %@",inDate);
        [df release];
    }
    if (inDate == nil) {
        inDate = [NSDate date];
    }
    [monthObj showMonthPickerWithType:0 date:inDate];
    
}


-(void)openTimePicker:(NSMutableArray *)inArguments{
    
    if (_isDataPickerDidOpen) {
        return;
    }
    
    DatePicker * tempObj = [[DatePicker alloc] initWithEuex:self];
    self.dateObj = tempObj;
    [tempObj release];
    inputHasDisplay = NO;
    _isDataPickerDidOpen = YES;
    NSString * inHours=nil;
    NSString * inMin=nil;
    if ([inArguments count]<2)
    {
        return;
    }
    else {
        inHours = [inArguments objectAtIndex:0];
        inMin = [inArguments objectAtIndex:1];
        int h = [inHours intValue];
        int m = [inMin intValue];
        if ((inHours.length==0)||(inMin.length==0)||(h > 24)||(h < 0)||(m > 60)||(m < 0)) {
            NSDate *today = [NSDate date];
            [dateObj showDatePickerWithType:1 date:today];
        }
        else{
            NSString *dateStr = [NSString stringWithFormat:@"%@:%@",inHours,inMin];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"HH:mm"];
            NSDate *inDate = [df dateFromString:dateStr];
            [df release];
            [dateObj showDatePickerWithType:1 date:inDate];
        }
    }
    
}

-(void)uexOpenDatePickerWithOpId:(int)inOpId dataType:(int)inDataType data:(NSString*)inData{
	inData =[inData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[self jsSuccessWithName:@"uexControl.cbOpenDatePicker" opId:inOpId dataType:inDataType strData:inData];
}
-(void)uexOpenMonthPickerWithOpId:(int)inOpId dataType:(int)inDataType data:(NSString*)inData{
    inData =[inData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self jsSuccessWithName:@"uexControl.cbOpenDatePickerWithoutDay" opId:inOpId dataType:inDataType strData:inData];
    NSLog(@"%@",inData);
}
-(void)uexOpenTimerPickerWithOpId:(int)inOpId dataType:(int)inDataType data:(NSString*)inData{
	inData =[inData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[self jsSuccessWithName:@"uexControl.cbOpenTimePicker" opId:inOpId dataType:inDataType strData:inData];
}

-(void)containViewTap:(UITapGestureRecognizer *)gest{
    if (tv) {
        [tv resignFirstResponder];
        [tv removeFromSuperview];
        if (tv.text) {
            [self jsSuccessWithName:@"uexControl.cbEditCompleted" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:tv.text];
        }
    }
    [containView removeFromSuperview];
}

-(void)openEditDialog:(NSMutableArray *)inArguments{
    float ex = [[inArguments objectAtIndex:0] floatValue];
    float ey = [[inArguments objectAtIndex:1] floatValue];
    float ew = [[inArguments objectAtIndex:2] floatValue];
    float eh = [[inArguments objectAtIndex:3] floatValue];
    int eType = [[inArguments objectAtIndex:4] intValue];
    NSString *eHintString = [inArguments objectAtIndex:5];
    NSString *eDefString = [inArguments objectAtIndex:6];
     tv = [[UITextView alloc] initWithFrame:CGRectMake(ex, ey, ew, eh)];
    tv.font =[UIFont systemFontOfSize:16.0f];
    [tv setDelegate:self];
    [tv.layer setCornerRadius:5.0];
    [tv.layer setBorderWidth:1.0];
    [tv.layer setBorderColor:[[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0] CGColor]];
    if (eType == 0) {
        [tv setKeyboardType:UIKeyboardTypeDefault];
    }else {
        [tv setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
    if(eDefString&&eDefString.length>0){
        [tv setText:eDefString];
    }else {
        if(eHintString&&eHintString.length>0)
        {
            UILabel *hintLab = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, ew-6, 20)];
            hintLab.text = eHintString;
            hintLab.font =[UIFont systemFontOfSize:16.0f];
            hintLab.textAlignment = UITextAlignmentLeft;
            hintLab.textColor = [UIColor grayColor];
            [tv addSubview:hintLab];
            [hintLab release];
        }
    }
 
    [EUtility brwView:meBrwView addSubview:tv];
//    [EUtility brwView:meBrwView forbidRotate:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return  YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]-216)];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [containView setAlpha:0.1];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containViewTap:)];
    [containView addGestureRecognizer:tapG];
    [EUtility brwView:meBrwView addSubview:containView];
    [tapG release];
}

- (void)textViewDidEndEditing:(UITextView *)textView{

}

- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

}
@end
