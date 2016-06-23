//
//  Face_Offline.h
//  face_iOS_02
//
//  Created by 虞海飞 on 16/6/12.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppLocalDetector.h"

@interface Face_Offline : NSObject

@property (nonatomic,strong) FaceppLocalDetector *detector;

#pragma  mark -- 检测图片 [ count 1 == 有脸图片，其他没有]
/**
 *  检测图片 [ count 1 == 有脸图片，其他没有]
 *  @param image 检测图片
 *
 *  @return dic[count : 有几张脸的图片，rect：图片位置，trackingId: 图片id（离线没有） ]
 */
-(NSMutableDictionary *) detectorFaceImage:(UIImage *)image;

/**
 *  启动时候的key
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initKey:(NSString *)key;
@end
