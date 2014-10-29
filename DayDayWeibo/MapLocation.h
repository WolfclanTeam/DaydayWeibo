

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject<MKAnnotation>
//经纬度坐标
@property(readwrite,nonatomic)CLLocationCoordinate2D coordinate;
//街道信息
@property(copy,nonatomic)NSString*streetAddress;
//城市信息
@property(copy,nonatomic)NSString*city;
//省份信息
@property(copy,nonatomic)NSString*state;
//邮编信息
@property(copy,nonatomic)NSString*zip;


@end
