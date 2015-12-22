//
//  Public_HIST.h
//  AppCan
//
//  Created by asang on 14-7-22.
//
//

#import <Foundation/Foundation.h>

#define IS_NSString(x) ([x isKindOfClass:[NSString class]] && x.length>0)
#define IS_NSMutableArray(x) ([x isKindOfClass:[NSMutableArray class]] && [x count]>0)
#define IS_NSArray(x) ([x isKindOfClass:[NSArray class]] && [x count]>0)
#define IS_NSMutableDictionary(x) ([x isKindOfClass:[NSMutableDictionary class]])
#define IS_NSDictionary(x) ([x isKindOfClass:[NSDictionary class]])

@interface Public_HIST : NSObject
+(UIColor *)strToColor:(NSString *)str;
@end
