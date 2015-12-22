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
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

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
//    if ([EUtility isIpad]) {
//        return;
//    }
    if (isPad)
    {
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (deviceOrientation == UIInterfaceOrientationPortrait||deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            
            int width = [EUtility screenWidth];
            int height  =[EUtility screenHeight];
            
            int realwidth = MAX(width, height);
            int realheight = MIN(width, height);

            [mainView setFrame:CGRectMake(0, realwidth-MAIN_HEIGHT, 320, MAIN_HEIGHT)];
            [toolView setFrame:CGRectMake(0, 0,realheight, 40)];
            [toolView.lay setFrame:CGRectMake(0, 0,realheight, 40)];
            [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
           // toolView.backgroundColor = [UIColor grayColor];

            [toolView.confirm setFrame:CGRectMake(realheight-70, 5, 41, 30)];
            [monthPcikerView setFrame:CGRectMake(0, 40, realheight, MAIN_HEIGHT-40)];
        }else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft||deviceOrientation==UIInterfaceOrientationLandscapeRight){
            
            int width = [EUtility screenWidth];
            int height  =[EUtility screenHeight];
            
            int realwidth = MAX(width, height);
            int realheight = MIN(width, height);
            
            [mainView setFrame:CGRectMake(0, realheight-MAIN_HEIGHT, realwidth, MAIN_HEIGHT)];
            [toolView setFrame:CGRectMake(0, 0,realwidth, 40)];
            toolView.backgroundColor = [UIColor clearColor];
            [toolView.lay setFrame:CGRectMake(0, 0, realwidth, 40)];
            [toolView.confirm setFrame:CGRectMake(realwidth - 36, 5, 41, 30)];
           //toolView.confirm.backgroundColor = [UIColor redColor];
            [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
//            toolView.cancle.backgroundColor = [UIColor grayColor];
            [monthPcikerView setFrame:CGRectMake(0, 40, realwidth-MAIN_HEIGHT, MAIN_HEIGHT-40)];
        }
//手机版；
    }else{
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (deviceOrientation == UIInterfaceOrientationPortrait||deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            [mainView setFrame:CGRectMake(0, [EUtility screenHeight]-MAIN_HEIGHT, 320, MAIN_HEIGHT)];
            [toolView setFrame:CGRectMake(0, 0, 320, 40)];
            [toolView.lay setFrame:CGRectMake(0, 0, 320, 40)];
            [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
            [toolView.confirm setFrame:CGRectMake(320 - 46, 5, 41, 30)];
            [monthPcikerView setFrame:CGRectMake(0, 40, 320, MAIN_HEIGHT-40)];
        }else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft||deviceOrientation==UIInterfaceOrientationLandscapeRight){
            [mainView setFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height)-MAIN_HEIGHT, [UIScreen mainScreen].bounds.size.width, MAIN_HEIGHT)];
            [toolView setFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)];
            [toolView.lay setFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)];
            [toolView.confirm setFrame:CGRectMake([EUtility screenWidth] - 46, 5, 41, 30)];
            
            [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
            toolView.backgroundColor = [UIColor grayColor];
            [monthPcikerView setFrame:CGRectMake(0, 40, [EUtility screenWidth], MAIN_HEIGHT-40)];
        }

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
    if ( deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        int width = [EUtility screenWidth];
        int height  =[EUtility screenHeight];
        
        int realwidth = MAX(width, height);
        int realheight = MIN(width, height);
        if (isPad)
        {
              self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0,realwidth, realheight, MAIN_HEIGHT)] autorelease];
        }else{
        
              self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0,[EUtility screenHeight]-MAIN_HEIGHT, realheight, MAIN_HEIGHT)] autorelease];
        }
        self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0,realwidth-MAIN_HEIGHT, realheight, MAIN_HEIGHT)] autorelease];
        self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, realheight, 40)] autorelease];
        self.toolView.confirm.frame = CGRectMake(realheight-65, 5, 41, 30);
        self.monthPcikerView = [[[CDatePickerViewEx alloc] init] autorelease];
        [monthPcikerView setFrame:CGRectMake(0, 40,realheight, MAIN_HEIGHT-40)];
    }else {
        
        int width = [EUtility screenWidth];
        int height  =[EUtility screenHeight];
        
        int realwidth = MAX(width, height);
        int realheight = MIN(width, height);
        if (isPad)
        {
             self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, realheight, MAIN_HEIGHT)] autorelease];
        }else{
        
             self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, realheight, MAIN_HEIGHT)] autorelease];
        }
       
        self.mainView.backgroundColor = [UIColor yellowColor];
        self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0,realheight, 40)] autorelease];
         self.toolView.confirm.frame = CGRectMake(realheight-55, 5, 41, 30);
        self.monthPcikerView = [[[CDatePickerViewEx alloc] init] autorelease];
        [monthPcikerView setFrame:CGRectMake(0, 40,realheight, MAIN_HEIGHT-40)];
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
                    int width = [EUtility screenWidth];
                    int height  =[EUtility screenHeight];
                    
                    int realwidth = MAX(width, height);
                    int realheight = MIN(width, height);
                    [mainView setFrame:CGRectMake(0, realheight-MAIN_HEIGHT, realheight, MAIN_HEIGHT)];
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
        int width = [EUtility screenWidth];
        int height  =[EUtility screenHeight];
        
        int realwidth = MAX(width, height);
        int realheight = MIN(width, height);
        [popController setPopoverContentSize:CGSizeMake(realheight, MAIN_HEIGHT)];
        [popController setDelegate:self];
        //让pop窗口的位置在中间
        int x = SCREEN_WIDTH/2;
        int y = (SCREEN_HEIGHT-20)/2;
        [EUtility brwView:euexObj.meBrwView presentPopover:popController FromRect:CGRectMake(x, y, 10, 10) permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    if (isPad)
    {
        
        
    }else{
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    }
    
    
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
