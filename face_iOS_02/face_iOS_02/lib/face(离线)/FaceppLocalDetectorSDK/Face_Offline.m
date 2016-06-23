//
//  Face_Offline.m
//  face_iOS_02
//
//  Created by 虞海飞 on 16/6/12.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import "Face_Offline.h"

@implementation Face_Offline

/**
 *  启动时候的key
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initKey:(NSString *)key
{
    self = [super init];
    if (self) {

        [self add_Init_FaceKey:key];
    }
    return self;
}

/***************  离线*********************************************/
#pragma  mark -- 初始化
/**
 *
 * key 自己的key
 *  @param key <#key description#>
 */
-(void) add_Init_FaceKey:(NSString *)key{

    NSDictionary *options = [NSDictionary dictionaryWithObjects:[
                                                                 NSArray arrayWithObjects:[NSNumber numberWithBool:YES],
                                                                 [NSNumber numberWithInt:20],
                                                                 FaceppDetectorAccuracyHigh, nil]
                                                        forKeys:[
                                                                 NSArray arrayWithObjects:FaceppDetectorTracking,
                                                                 FaceppDetectorMinFaceSize,
                                                                 FaceppDetectorAccuracy, nil]];

    //@"75e26ab2c0415e91f88569582d26a1be"
    _detector = [FaceppLocalDetector detectorOfOptions: options andAPIKey:key];
}

#pragma  mark -- 检测图片 [ count 1 == 有脸图片，其他没有]
/**
 *  NSMutableDictionary 检测图片 [ count 1 == 有脸图片，其他没有]
 *  @param image 检测图片
 *
 *  @return dic[count : 有几张脸的图片，rect：图片位置，trackingId: 图片id（离线没有） ]
 */
-(NSMutableDictionary *) detectorFaceImage:(UIImage *)image{

    FaceppLocalResult *result = [self.detector detectWithImage:image];

    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    //里面有脸的图片有几张
    mdic[@"count"] = [NSString stringWithFormat:@"%d",result.faces.count];
    for (size_t i=0; i < result.faces.count; i++) {
        FaceppLocalFace *face = [result.faces objectAtIndex:i];

        //图片位置
        mdic[@"rect"] = NSStringFromCGRect(face.bounds);
        //图片位置
        mdic[@"trackingId"] = [NSString stringWithFormat:@"%d",face.trackingID];
    }

    return mdic;
}

@end
