//
//  Camera_Up.m
//  face++
//
//  Created by 虞海飞 on 16/6/12.
//  Copyright © 2016年 虞海飞. All rights reserved.
// 启动摄像头

#import "Camera_Up.h"
#import "Tool_Camera.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Camera_Up

-(Tool_Camera *) tool_Camera{

    if (_tool_Camera == nil) {

        _tool_Camera = [[Tool_Camera alloc] init];
    }

    return _tool_Camera;
}

#pragma  mark -- 启动摄像头，初始化
/**
 *  启动摄像头，初始化
 *
 *  @param controller 调用的控制器
 *
 *  @return self
 */
- (instancetype)initContr:(UIViewController<ToolCameraDelegate> *)controller
{
    self = [super init];
    if (self) {
        [self.tool_Camera tool_StartScan_Controller:controller];
        self.tool_Camera.delegate = controller;
    }
    
    return self;
}

-(void)ToolCameraDelegate_Image:(UIImage *)image{


}

@end
