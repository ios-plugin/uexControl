//
//  HeaderView.m
//  AppCan
//
//  Created by AppCan on 11-8-9.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "HeaderView.h"
#import "EUtility.h"

@implementation HeaderView
@synthesize delegate,cancle,confirm,lay;
 
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.alpha = 0.8;
		static NSMutableArray * colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:4];
            UIColor * color = nil;
			color = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1.0];
            [colors addObject:(id)color.CGColor];
			color = [UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:1.0];
            [colors addObject:(id)color.CGColor];
            color = [UIColor colorWithRed:0	green:0 blue:0 alpha:1.0];
            [colors addObject:(id)color.CGColor];
            color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
            [colors addObject:(id)color.CGColor];
		}
		lay = [[CAGradientLayer layer] retain];
		[lay setFrame:self.bounds];
		[lay setColors:colors];
		[lay setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1.0], nil]];
        float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion < 7.0) {
            [self.layer addSublayer:lay];
        } else {
            [self setBackgroundColor:[UIColor whiteColor]];
        }
        ////取消按钮
		UILabel * canLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 2.5, 35, 25)];
		canLabel.text = @"取消";
		canLabel.textColor = [UIColor whiteColor];
		canLabel.font = [UIFont systemFontOfSize:12.0];
		[canLabel setBackgroundColor:[UIColor clearColor]];
		
		cancle = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 41, 30)];
		[cancle setImage:[UIImage imageNamed:@"uexControl/top_button.png"] forState:UIControlStateNormal];
		[cancle addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[cancle addSubview:canLabel];
		[canLabel release];
		/////////确定按钮
		UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 2.5, 35, 25)];
		conLabel.text = @"完成";
		conLabel.textColor = [UIColor whiteColor];
		conLabel.font = [UIFont systemFontOfSize:12.0];
		[conLabel setBackgroundColor:[UIColor clearColor]];
		confirm = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-46, 5, 41, 30)];
		[confirm setImage:[UIImage imageNamed:@"uexControl/top_button.png"] forState:UIControlStateNormal];
		[confirm addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[confirm addSubview:conLabel];
		[conLabel release];

		[self addSubview:cancle];
		[self addSubview:confirm];
    }
    return self;
}

- (void)cancleButtonClicked {
	if(delegate != nil && [delegate respondsToSelector: @selector(cancled:)] == YES){
		[delegate cancled:self];	
	}
}

- (void)confirmButtonClicked {
	if(delegate != nil && [delegate respondsToSelector: @selector(confirm:)] == YES){
		[delegate confirm:self];	
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    self.cancle = nil;
    self.confirm = nil;
    self.lay = nil;
    [super dealloc];
}


@end
