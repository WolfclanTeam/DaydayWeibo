

#import "MapLocation.h"

@implementation MapLocation

@synthesize streetAddress,city,state,zip,coordinate;

-(NSString*)title{
    return @"您的位置"; 
}
-(NSString*)subtitle{
    NSMutableString*ret=[[NSMutableString alloc]initWithFormat:@"%@,%@,%@,%@",state,city,streetAddress,zip];
//    if (state) {
//        [ret appendString:state];
//    }
//    if (city) {
//        [ret appendString:city];
//    }
//    if (city&&state) {
//        [ret appendString:@", "];
//    }
//    if (streetAddress&&(city||state||zip)) {
//        [ret appendString:@" · "];
//    }
//    if (streetAddress) {
//        [ret appendString:streetAddress];
//    }
//    if (zip) {
//        [ret appendFormat:@", %@",zip];
//    }
    return ret;
}

@end
