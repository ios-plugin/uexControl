//
//  Public_HIST.m
//  AppCan
//
//  Created by asang on 14-7-22.
//
//

#import "Public_HIST.h"
#import "EUtility.h"

@implementation Public_HIST

#pragma mark -
#pragma mark NSString转换为UIColor

+(UIColor *)strToColor:(NSString *)str{
    if ([str isKindOfClass:[NSString class]] && str.length>0) {
        UIColor *colors = [EUtility ColorFromString:str];
        return colors;
    }else{
        return nil;
    }
}

@end
