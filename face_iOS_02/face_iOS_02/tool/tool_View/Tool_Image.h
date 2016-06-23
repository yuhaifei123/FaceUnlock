//
//  Tool_Image.h
//  face_iOS_02
//
//  Created by 虞海飞 on 16/6/20.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool_Image : NSObject

/**
 * 图片旋转
 *
 *  @param image       旋转的图片
 *  @param orientation 旋转的角度
 *
 *  @return 旋转以后的图片
 */
+(UIImage *) imageRotating:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
