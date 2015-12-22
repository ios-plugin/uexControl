//
//  DatePicker.m
//  AppCan
//
//  Created by AppCan on 11-11-23.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "DatePicker.h"
#import "EUtility.h"
#import "JSON.h"
#import "EUExBaseDefine.h"
#import "EUExControl.h"

#define MAIN_HEIGHT   202
#define HEAD_HEIGHT   40
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation DatePicker
@synthesize pickerType;
@synthesize mainView;
@synthesize euexObj;
@synthesize toolView;
@synthesize selectValue;
@synthesize pickerView;
@synthesize popController;

-(id)initWithEuex:(EUExControl *)euexObj_{
    self.euexObj = euexObj_;
	return self;
}

-(void)setResultFormat:(NSDate *)inDate{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit|NSCalendarUnitWeekday;
	
	NSDateComponents *comps  = [calendar components:unitFlags fromDate:inDate];
	
	int year = [comps year];
	int month = [comps month];
	int day = [comps day];
	int hour = [comps hour];
	int min = [comps minute];
	int sec = [comps second];
    int week = [comps week];
	[calendar release];
    
	[selectValue setObject:[NSNumber numberWithInt:year] forKey:UEX_JKYEAR];
	[selectValue setObject:[NSNumber numberWithInt:month] forKey:UEX_JKMONTH];
	[selectValue setObject:[NSNumber numberWithInt:day] forKey:UEX_JKDAY];
	[selectValue setObject:[NSNumber numberWithInt:hour] forKey:UEX_JKHOUR];
	[selectValue setObject:[NSNumber numberWithInt:min] forKey:UEX_JKMUNUTE];
	[selectValue setObject:[NSNumber numberWithInt:sec] forKey:UEX_JKSECOND];
    [selectValue setObject:[NSNumber numberWithInt:week] forKey:UEX_JKWEEK];
}

- (void)changeDate:(id)sender{
	NSDate * checkDate = pickerView.date;
    [self setResultFormat:checkDate];
}
//------------------>>>>>>>>>>>>>>>监听翻转<<<<<<<<<<<<<<<<<<----------------------------;
-(void)doRotate{
//	if ([EUtility isIpad]) {
//		return;
//	}{
    if(isPad)
    {
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (deviceOrientation == UIInterfaceOrientationPortrait||deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[mainView setFrame:CGRectMake(0, [EUtility screenHeight] - MAIN_HEIGHT, 320*APP_DEVICERATIO, MAIN_HEIGHT)];
		[toolView setFrame:CGRectMake(0, 0, 320*APP_DEVICERATIO, 40)];
		[toolView.lay setFrame:CGRectMake(0, 0, 320*APP_DEVICERATIO, 40)];
		[toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
		[toolView.confirm setFrame:CGRectMake(320*APP_DEVICERATIO - 46, 5, 41, 30)];
		[pickerView setFrame:CGRectMake(0, 40, 320*APP_DEVICERATIO, MAIN_HEIGHT-40)];
            
           
            
    }
    else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft||deviceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        int width = [EUtility screenWidth];
        int height  =[EUtility screenHeight];
        
        int realwidth = MAX(width, height);
        int realheight = MIN(width, height);

        
		[mainView setFrame:CGRectMake(0, realheight - MAIN_HEIGHT, realwidth, MAIN_HEIGHT)];
		[toolView setFrame:CGRectMake(0, 0, realwidth, 40)];
		[toolView.lay setFrame:CGRectMake(0, 0, realwidth, 40)];
		[toolView.confirm setFrame:CGRectMake(realwidth - 46, 5, 41, 30)];
		[toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
		[pickerView setFrame:CGRectMake(0, 40, realwidth, MAIN_HEIGHT - 40)];
       
	}
    
    }
    //手机版；
    else
    {
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (deviceOrientation == UIInterfaceOrientationPortrait||deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            [mainView setFrame:CGRectMake(0, [EUtility screenHeight] - MAIN_HEIGHT, 320*APP_DEVICERATIO, MAIN_HEIGHT)];
            [toolView setFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)];
            [toolView.lay setFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)];
            [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
            [toolView.confirm setFrame:CGRectMake([EUtility screenWidth] - 46, 5, 41, 30)];
            [pickerView setFrame:CGRectMake(0, 40, [EUtility screenWidth], MAIN_HEIGHT-40)];
        }else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft||deviceOrientation == UIInterfaceOrientationLandscapeRight){
            
            [mainView setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-MAIN_HEIGHT,[UIScreen mainScreen].bounds.size.width, MAIN_HEIGHT)];
            [toolView setFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)];
            [toolView.lay setFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)];
            [toolView.confirm setFrame:CGRectMake([EUtility screenWidth] - 46, 5, 41, 30)];
            [toolView.cancle setFrame:CGRectMake(5, 5, 41, 30)];
            [pickerView setFrame:CGRectMake(0, 40,[ UIScreen mainScreen].bounds.size.width, MAIN_HEIGHT - 40)];
            
        }
    
    }
}

-(void)showDatePickerWithType:(int)type date:(NSDate *)inDate{
	if (mainView) {
		return;
	}
	self.pickerType = [NSNumber numberWithInt:type];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:10];
	self.selectValue = dict;
    [dict release];
    
	[self setResultFormat:inDate];
    
    if (isPad)
    {
        
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            
            self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, [EUtility screenHeight], 320*APP_DEVICERATIO, MAIN_HEIGHT)] autorelease];
            self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DEVICERATIO, 40)] autorelease];
            self.pickerView = [[[UIDatePicker alloc] init] autorelease];
            [pickerView setFrame:CGRectMake(0, 40, 320*APP_DEVICERATIO, MAIN_HEIGHT-40)];
        
            
        }else {
            
            int width = [EUtility screenWidth];
            int height  =[EUtility screenHeight];
            
            int realwidth = MAX(width, height);
            int realheight = MIN(width, height);
            
            self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, realheight-MAIN_HEIGHT, realheight, MAIN_HEIGHT)] autorelease];
            self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, realwidth, 40)] autorelease];
            self.pickerView = [[[UIDatePicker alloc] init] autorelease];
            [pickerView setFrame:CGRectMake(0, 40,realheight, MAIN_HEIGHT-40)];
            NSLog(@"%@",NSStringFromCGRect(pickerView.frame));
            
        }
        toolView.delegate = self;
        if (type == 0) {
            pickerView.datePickerMode = UIDatePickerModeDate;
        }else {
            pickerView.datePickerMode = UIDatePickerModeTime;
        }
        
        pickerView.date = inDate;
        [pickerView addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        [mainView addSubview:toolView];
        [mainView setBackgroundColor:[UIColor whiteColor]];
        [mainView addSubview:pickerView];
        if (![EUtility isIpad] || SCREEN_WIDTH == 320*APP_DEVICERATIO) {
            [EUtility brwView:euexObj.meBrwView addSubview:mainView];
            if (euexObj.meBrwView) {
                if (![EUtility isIpad] || deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [mainView setFrame:CGRectMake(0, [EUtility screenHeight]-MAIN_HEIGHT, 320*APP_DEVICERATIO, MAIN_HEIGHT)];
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
            
            [popController setPopoverContentSize:CGSizeMake(320*APP_DEVICERATIO, MAIN_HEIGHT)];
            [popController setDelegate:self];
            //让pop窗口的位置在中间
            int x = SCREEN_WIDTH/2;
            int y = (SCREEN_HEIGHT-20)/2;
            [EUtility brwView:euexObj.meBrwView presentPopover:popController FromRect:CGRectMake(x, y, 10, 10) permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotate) name:UIDeviceOrientationDidChangeNotification object:nil];

    }
    
    //手机版；
    else{
    
        UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, [EUtility screenHeight], 320*APP_DEVICERATIO, MAIN_HEIGHT)] autorelease];
            self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DEVICERATIO, 40)] autorelease];
            self.pickerView = [[[UIDatePicker alloc] init] autorelease];
            
            [pickerView setFrame:CGRectMake(0, 40, 320*APP_DEVICERATIO, MAIN_HEIGHT-40)];
        }else {
            self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, [EUtility screenWidth]-MAIN_HEIGHT, [UIScreen mainScreen].bounds.size.height, MAIN_HEIGHT)] autorelease];
            self.toolView = [[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, [EUtility screenWidth], 40)] autorelease];
            
            self.pickerView = [[[UIDatePicker alloc] init] autorelease];

            [pickerView setFrame:CGRectMake(0, 40,[EUtility screenWidth], MAIN_HEIGHT-40)];
            NSLog(@"%@",NSStringFromCGRect(pickerView.frame));
            [self.toolView.confirm setFrame:CGRectMake([EUtility screenWidth] - 46, 5, 41, 30)];

        }

        toolView.delegate = self;
        if (type == 0) {
            pickerView.datePickerMode = UIDatePickerModeDate;
        }else {
            pickerView.datePickerMode = UIDatePickerModeTime;
        }
        
        pickerView.date = inDate;
        [pickerView addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        [mainView addSubview:toolView];
        [mainView setBackgroundColor:[UIColor whiteColor]];
        [mainView addSubview:pickerView];
        if (![EUtility isIpad] || SCREEN_WIDTH == 320*APP_DEVICERATIO) {
            [EUtility brwView:euexObj.meBrwView addSubview:mainView];
            if (euexObj.meBrwView) {
                if (![EUtility isIpad] || deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [mainView setFrame:CGRectMake(0, [EUtility screenHeight]-MAIN_HEIGHT, 320*APP_DEVICERATIO, MAIN_HEIGHT)];
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
            
            [popController setPopoverContentSize:CGSizeMake(320*APP_DEVICERATIO, MAIN_HEIGHT)];
            [popController setDelegate:self];
            //让pop窗口的位置在中间
            int x = SCREEN_WIDTH/2;
            int y = (SCREEN_HEIGHT-20)/2;
            [EUtility brwView:euexObj.meBrwView presentPopover:popController FromRect:CGRectMake(x, y, 10, 10) permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	if (mainView) {
		[mainView removeFromSuperview];
    }
    euexObj.isDataPickerDidOpen = NO;
	return YES;
}

- (void)cancled:(id)headerView{
    if (euexObj.meBrwView) {
        [(UIView*)euexObj.meBrwView setUserInteractionEnabled:YES];
    }
    
    if (![EUtility isIpad] || SCREEN_WIDTH == 320*APP_DEVICERATIO) {
        [UIView animateWithDuration:0.3 animations:^{
            [mainView setFrame:CGRectMake(0, [EUtility screenHeight], 320*APP_DEVICERATIO, MAIN_HEIGHT)];
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
    euexObj.isDataPickerDidOpen = NO;
}

- (void)confirm:(id)headerView{
    if (euexObj.meBrwView) {
        [(UIView*)euexObj.meBrwView setUserInteractionEnabled:YES];
    }
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	if ([pickerType intValue] == 0) {
		[euexObj uexOpenDatePickerWithOpId:0 dataType:UEX_CALLBACK_DATATYPE_JSON data:[selectValue JSONFragment]];
        
	}else {
		[euexObj uexOpenTimerPickerWithOpId:0 dataType:UEX_CALLBACK_DATATYPE_JSON data:[selectValue JSONFragment]];
	}
    
    if (![EUtility isIpad] || SCREEN_WIDTH == 320*APP_DEVICERATIO) {
        [UIView animateWithDuration:0.3 animations:^{
            [mainView setFrame:CGRectMake(0, [EUtility screenHeight], 320*APP_DEVICERATIO, MAIN_HEIGHT)];
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
    euexObj.isDataPickerDidOpen = NO;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	if (popController) {
        self.popController = nil;
	}
    if (pickerView) {
        self.pickerView = nil;
    }
	if (toolView) {
        self.toolView.delegate = nil;
        self.toolView = nil;
	}
	if (mainView) {
        self.mainView = nil;
	}
	if (selectValue) {
        self.selectValue = nil;
	}
	[super dealloc];
}
@end
