//
//  InputDialog.m
//  AppCan
//
//  Created by AppCan on 12-6-6.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import "InputDialog.h"
#import "EUtility.h"
#import <QuartzCore/CALayer.h>

@implementation InputDialog
@synthesize delegate = _delegate;

#define HEIGHT_STATUS 20


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        }
    return self;
}
- (void) registerForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];		

    
}
-(void)removeKeyboardNotifucations {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)openInputWithText:(NSString*)placeholderText btnText:(NSString*)btnString KeyBoardType:(int)keyBoardType{
    //键盘高度，iphone5以前是216，5以后对中英文做不同处理,中文键盘高252，英文键盘高216。ipad键盘，横屏264。shu屏是352
    //注册通知
    [self registerForKeyboardNotifications];
    UIInterfaceOrientation   cOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (cOrientation == UIInterfaceOrientationLandscapeRight || cOrientation == UIInterfaceOrientationLandscapeLeft) {
        mainWidth = [EUtility screenHeight];
        mainHeight = [EUtility screenWidth];
        isLandspace = YES;
    } else {
        mainWidth = [EUtility screenWidth];
        mainHeight = [EUtility screenHeight];
        isLandspace = NO;
    }
    NSNumber * statusBarStyleIOS7 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"StatusBarStyleIOS7"];
    if (![statusBarStyleIOS7 boolValue]) {
        mainHeight -= HEIGHT_STATUS;
    }
    textView = [[PLGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, mainWidth - 80, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
    if (isLandspace) {
        textView.maxNumberOfLines = 4;
    } else {
        textView.maxNumberOfLines = 6;
    }
    
    switch (keyBoardType) {
        case StandardKB:
            break;
        case NumberKB:
            [textView.internalTextView setKeyboardType:UIKeyboardTypeNumberPad];
            break;
        case EmailKB:
            [textView.internalTextView setKeyboardType:UIKeyboardTypeEmailAddress];
            break;
        case URLKB:
            [textView.internalTextView setKeyboardType:UIKeyboardTypeURL];
            break;
        case PassWordKB:
           textView.internalTextView.secureTextEntry = YES;
            break;
        /*case 5:
            [textView.internalTextView setKeyboardType:UIKeyboardTypeASCIICapable];
            break;
        case 6:
             [textView.internalTextView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
        case 7:
             [textView.internalTextView setKeyboardType:UIKeyboardTypePhonePad];
            break;
        case 8:
             [textView.internalTextView setKeyboardType:UIKeyboardTypeNamePhonePad];
            break;
        case 9:
            [textView.internalTextView setKeyboardType:UIKeyboardTypeDecimalPad];
            break;   */         
        default:
            break;
    }
	textView.returnKeyType = UIReturnKeyDone; //just as an example
	textView.font = [UIFont systemFontOfSize:16.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = placeholderText;
    [textView becomeFirstResponder];
  
	
    UIImage * rawEntryBackground = [UIImage imageNamed:@"uexControl/plugin_control_input_field.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(5, 0, mainWidth-72, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"uexControl/plugin_control_input_entry_bg.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self addSubview:imageView];
    [self addSubview:textView];
    [self addSubview:entryImageView];
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"uexControl/plugin_control_input_btn_bg.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"uexControl/plugin_control_input_btn_pressed.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(self.frame.size.width - 69, 8,63 , 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    if ([btnString length]==0) {
        [doneBtn setTitle:UEX_LOCALIZEDSTRING(@"确定") forState:UIControlStateNormal];
    }else {
        [doneBtn setTitle:btnString forState:UIControlStateNormal];
    }
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[self addSubview:doneBtn];

  
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}
-(void)btnClick
{
	[textView resignFirstResponder];
    [self removeKeyboardNotifucations];
    if (_delegate&&[_delegate respondsToSelector:@selector(inputFinish:)]) {
        [_delegate inputFinish:textView.text];
    }
    [self removeFromSuperview];
}
- (BOOL)PLGrowingTextViewShouldReturn:(PLGrowingTextView *)PLGrowingTextView{
    [PLGrowingTextView resignFirstResponder];
    [self removeKeyboardNotifucations];
    if (_delegate&&[_delegate respondsToSelector:@selector(inputFinish:)]) {
        [_delegate inputFinish:PLGrowingTextView.text];
    }
    [self removeFromSuperview];
    return YES;
}
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.frame;
    containerFrame.origin.y = mainHeight - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.frame;
    containerFrame.origin.y =mainHeight+self.bounds.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)PLGrowingTextViewDidEndEditing:(PLGrowingTextView *)PLGrowingTextView{
    if (_delegate&&[_delegate respondsToSelector:@selector(inputDialogClose)]) {
        [_delegate inputDialogClose];
    }
    [self removeKeyboardNotifucations];
    [self removeFromSuperview];

}

- (void)PLGrowingTextView:(PLGrowingTextView *)PLGrowingTextView willChangeHeight:(float)height
{
    float diff = (PLGrowingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
}

-(void)dealloc {
    [self removeKeyboardNotifucations];
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
