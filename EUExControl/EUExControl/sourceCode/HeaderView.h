//
//  HeaderView.h
//  AppCan
//
//  Created by AppCan on 11-8-9.
//  Copyright 2011 AppCan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol HeaderViewDelegate <NSObject>

- (void)cancled:(id)headerView; 
- (void)confirm:(id)headerView;

@end

@interface HeaderView : UIView {
	id<HeaderViewDelegate> delegate;
 
	UIButton *cancle;
	UIButton *confirm;
	CAGradientLayer *lay;
}

@property (nonatomic,assign) id<HeaderViewDelegate> delegate;
 
@property (nonatomic, retain) UIButton * cancle;
@property (nonatomic, retain) UIButton * confirm;
@property (nonatomic, assign) CAGradientLayer * lay;

@property (nonatomic, retain) UILabel * canLabel;
@property (nonatomic, retain) UILabel *conLabel;

@end
