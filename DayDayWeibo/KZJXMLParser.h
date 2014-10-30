//
//  KZJXMLParser.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^PassValueBlock)(NSString *str);
@interface KZJXMLParser : NSObject<NSXMLParserDelegate>
@property(copy,nonatomic)PassValueBlock passValueBlock;
-(void)iosParseXML:(NSString*)string;
@end
