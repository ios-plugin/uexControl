//
//  MonthPicker.m
//  AppCanPlugin
//
//  Created by zhijian du on 15/1/27.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "MonthPicker.h"
#import "EUtility.h"
#import "JSON.h"
#import "EUExBaseDefine.h"
#import "EUExControl.h"
#define MAIN_HEIGHT   202
#define HEAD_HEIGHT   40
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation MonthPicker
@synthesize pickerType;
@synthesize mainView;
@synthesize euexObj;
@synthesize toolView;
@synthesize selectValue;
@synthesize monthPcikerView;
@synthesize popController;

-(id)initWithEuex:(EUExControl *)euexObj_{
    self.euexObj = euexObj_;
    return self;
}
-(void)setResultFormat:(NSDate *)inDate{
    NSLog(@"DatePicker setResultFormat start");
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:inDate];
    
    int year = [comps year];
    int month = [comps month];

    [calendar release];
    
    [selectValue setObject:[NSNumber numberWithInt:year] forKey:UEX_JKYEAR];
    [selectValue setObject:[NSNumber numberWithInt:month] forKey:UEX_JKMONTH];

    NSLog(@"DatePicker setResultFormat end");
}
- (void)changeDate:(id)sender{
    NSDate *checkDate = monthPcikerView.resultDate;
    [self setResultFormat:checkDate];
}
-(void)doRotate{
    if ([EUtility isIpad]) {
        return;
    }
    UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (deviceOrientation == UIInterfaceOrientationPortrait||deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [mainView setFrame:CGRectMake(0, [EUtility screenHeight]-MAIN_HEIGHT,SCREEN_WIDTH, MAIN_HEIGHT)];
        [toolView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [toolView.lay setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
        [toolView.confirm setFrame:CGRectMake(SCREEN_WIDTH - 46, 5, 41, 30)];
        [monthPcikerView setFrame:CGRectMake(0, 40, SCREEN_WIDTH, MAIN_HEIGHT-40)];
    }else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft||deviceOrientation==UIInterfaceOrientationLandscapeRight){
        [mainView setFrame:CGRectMake(0, 300-MAIN_HEIGHT, [EUtility screenHeight], MAIN_HEIGHT)];
        [toolView setFrame:CGRectMake(0, 0, [EUtility screenHeight], 40)];
        [toolView.lay setFrame:CGRectMake(0, 0, [EUtility screenHeight], 40)];
        [toolView.confirm setFrame:CGRectMake([EUtility screenHeight] - 46, 5, 41, 30)];
        [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
        [monthPcikerView setFrame:CGRectMake(0, 40, [EUtility screenHeight], MAIN_HEIGHT-40)];
    }
}

-(void)showMonthPickerWithType:(int)type date:(NSDate *)inDate{
    NSLog(@"DatePicker showMonthPickerWithType start");
    if (mainView) {
        return;
    }
    self.pickerType = [NSNumber numberWithInt:type];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    self.selectValue = dict;
    [dict release];
    
    [self setResultFormat:inDate];
    
    UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([EUtility isIpad] || deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, [EUtility screenHeight], SCREEN_WIDTH, MAIN_HEIGHT)] autorelease];
        self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)] autorelease];
        self.monthPcikerView = [[[CDatePickerViewEx alloc] init] autorelease];
        [monthPcikerView setFrame:CGRectMake(0, 40, SCREEN_WIDTH, MAIN_HEIGHT-40)];
    }else {
        self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, 300-MAIN_HEIGHT, [EUtility screenHeight], MAIN_HEIGHT)] autorelease];
        self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0,[EUtility screenHeight], 40)] autorelease];
        self.monthPcikerView = [[[CDatePickerViewEx alloc] init] autorelease];
        [monthPcikerView setFrame:CGRectMake(0, 40, [EUtility screenHeight], MAIN_HEIGHT-40)];
    }
    toolView.delegate = self;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:inDate];
    [calendar release];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
 
    [monthPcikerView selectTodayWithYear:year  andMonth:month];

    [mainView addSubview:toolView];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [mainView addSubview:monthPcikerView];
    if (![EUtility isIpad] || SCREEN_WIDTH == 320) {
        [EUtility brwView:euexObj.meBrwView addSubview:mainView];
        if (euexObj.meBrwView) {
            if (![EUtility isIpad] || deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                [UIView animateWithDuration:0.3 animations:^{
                    [mainView setFrame:CGRectMake(0, [EUtility screenHeight]-MAIN_HEIGHT, SCREEN_WIDTH, MAIN_HEIGHT)];
                }];
            }
            [(UIView*)euexObj.meBrwView setUserInteractionEnabled:NO];
        }
    }else {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view = mainView;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [controller release];
        self.popController = popover;
        [popover release];
        
        [popController setPopoverContentSize:CGSizeMake(SCREEN_WIDTH, MAIN_HEIGHT)];
        [popController setDelegate:self];
        //让pop窗口的位置在中间
        int x = SCREEN_WIDTH/2;
        int y = (SCREEN_HEIGHT-20)/2;
        [EUtility brwView:euexObj.meBrwView presentPopover:popController FromRect:CGRectMake(x, y, 10, 10) permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    if (mainView) {
        [mainView removeFromSuperview];
    }
    return YES;
}

- (void)cancled:(id)headerView{
    if (euexObj.meBrwView) {
        [(UIView*)euexObj.meBrwView setUserInteractionEnabled:YES];
    }
    
    if (![EUtility isIpad] || SCREEN_WIDTH == 320) {
        [UIView animateWithDuration:0.3 animations:^{
            [mainView setFrame:CGRectMake(0, [EUtility screenHeight], 320, MAIN_HEIGHT)];
        } completion:^(BOOL finish){
            if (finish) {
                [mainView removeFromSuperview];
            }
        }];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    if (popController) {
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    }
}

- (void)confirm:(id)headerView{
    if (euexObj.meBrwView) {
        [(UIView*)euexObj.meBrwView setUserInteractionEnabled:YES];
    }
    
    NSDate *checkDate = monthPcikerView.resultDate;
    [self setResultFormat:checkDate];
    
    //	NSLog(@"selectValue = %@",[selectValue description]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//    if ([pickerType intValue]==0) {
//        [euexObj uexOpenDatePickerWithOpId:0 dataType:UEX_CALLBACK_DATATYPE_JSON data:[selectValue JSONFragment]];
//    }else if ([pickerType intValue]==1) {
//        [euexObj uexOpenTimerPickerWithOpId:0 dataType:UEX_CALLBACK_DATATYPE_JSON data:[selectValue JSONFragment]];
//    }else{
    [euexObj uexOpenMonthPickerWithOpId:0 dataType:UEX_CALLBACK_DATATYPE_JSON data:[selectValue JSONFragment]];
//    }
    
    if (![EUtility isIpad] || SCREEN_WIDTH == 320) {
        [UIView animateWithDuration:0.3 animations:^{
            [mainView setFrame:CGRectMake(0, [EUtility screenHeight], 320, MAIN_HEIGHT)];
        } completion:^(BOOL finish){
            if (finish) {
                [mainView removeFromSuperview];
            }
        }];
    }
    if (popController) {
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    }
}

-(void)dealloc{
    NSLog(@"hui--->DatePicker dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    if (popController) {
        NSLog(@"hui--->DatePicker dealloc self.popController retaincount is %d",[self.popController retainCount]);
        self.popController = nil;
    }
    if (monthPcikerView) {
        NSLog(@"hui--->DatePicker dealloc pickerView");
        self.monthPcikerView = nil;
    }
    if (toolView) {
        NSLog(@"hui--->DatePicker dealloc toolView");
        self.toolView.delegate = nil;
        self.toolView = nil;
    }
    if (mainView) {
        NSLog(@"hui--->DatePicker dealloc mainView");
        self.mainView = nil;
    }
    if (selectValue) {
        NSLog(@"hui--->DatePicker dealloc selectValue");
        self.selectValue = nil;
    }
    [super dealloc];
}
@end
