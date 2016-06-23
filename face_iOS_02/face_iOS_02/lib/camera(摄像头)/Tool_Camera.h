//
//  Tool_QrCode.h
//  NewsTableView
//
//  Created by 虞海飞 on 16/3/26.
//  Copyright © 2016年 虞海飞. All rights reserved.
// 调用摄像头
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> //二维码

@protocol ToolCameraDelegate <NSObject>

//得到图片以后，回调回来(图片)
-(void) ToolCameraDelegate_Image:(UIImage *)image;

@end

@interface Tool_Camera : NSObject<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,weak) id<ToolCameraDelegate> delegate;

enum {
    PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
    PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
    PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
    PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
    PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
    PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
    PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
    PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
};

//图片
@property (nonatomic,strong) UIImage *image_Face;

/**
 *  调用摄像头
 */
-(void) tool_StartScan_Controller:(UIViewController *)controller;
/**
 清空边线
 */
-(void) clearConers;

/**
 绘制图形
 */
-(void)drawCorners_CodeObject: (NSArray *)metadataObjects;
@end
