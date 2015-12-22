//
//  InputDialog.h
//  AppCan
//
//  Created by AppCan on 12-6-6.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLGrowingTextView.h"
typedef enum AppCanKeyBroardKeys {
    StandardKB = 0,
    NumberKB,
    EmailKB,
    URLKB,
    PassWordKB
}AppCanKB;

@protocol InputDialogDelegate <NSObject>
-(void)inputFinish:(NSString *)inputResult;
-(void)inputDialogClose;
@end
@interface InputDialog : UIView<PLGrowingTextViewDelegate>{
    UIButton *btn;
     PLGrowingTextView *textView;
    id<InputDialogDelegate> _delegate;
    float mainWidth;
    float mainHeight;
    BOOL isLandspace;
    UIImageView *entryImageView;
}
@property(nonatomic,strong)NSMutableDictionary * Viewdic;
@property(nonatomic,strong)UIButton *doneBtn;
@property(nonatomic,strong) UIView * view;
@property(nonatomic,strong)UIImageView *entryImageView;
@property(nonatomic,strong)NSString * strings;
@property(assign)id<InputDialogDelegate> delegate;
-(void)openInputWithText:(NSString*)placeholderText btnText:(NSString*)btnString KeyBoardType:(int)keyBoardType dialogBg:(NSString*)diaLogColor dialogButBg:(NSString*)dialogButBg dialogETBg:(NSString*)dialogETBg count:(NSInteger)counts;
@end
