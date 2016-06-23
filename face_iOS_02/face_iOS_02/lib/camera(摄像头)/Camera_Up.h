//
//  Camera_Up.h
//  face++
//
//  Created by 虞海飞 on 16/6/12.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool_Camera.h"

@interface Camera_Up : NSObject<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,ToolCameraDelegate>

@property (nonatomic,strong) UIImage *image_Face;//面图片

@property (nonatomic,strong) Tool_Camera *tool_Camera;//摄像头类

#pragma  mark -- 启动摄像头，初始化
/**
 *  启动摄像头，初始化
 *
 *  @param controller 调用的控制器
 *
 *  @return self
 */
- (instancetype)initContr:(UIViewController *)controller;

@end
