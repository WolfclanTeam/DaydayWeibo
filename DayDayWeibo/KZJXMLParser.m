//
//  KZJXMLParser.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJXMLParser.h"

@implementation KZJXMLParser
@synthesize passValueBlock;
-(void)iosParseXML:(NSString*)string
{
  
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];//设置NSXMLParser对象的解析方法代理
    parser.delegate = self;
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //NSLog(@"拿到了一个节点的开始，元素名为：%@，其下属性有：%@",elementName,attributeDict);
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"拿到了一个节点结束，元素名为：%@。",elementName);
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
   // NSLog(@"文本内容为：%@",string);
    passValueBlock(string);
}
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    //NSLog(@"解析文档开始了++++++++++++++");
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
   // NSLog(@"解析文档结束");
}

@end
