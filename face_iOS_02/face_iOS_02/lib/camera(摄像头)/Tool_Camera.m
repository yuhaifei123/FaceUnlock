//
//  Tool_QrCode.m
//  NewsTableView
//
//  Created by 虞海飞 on 16/3/26.
//  Copyright © 2016年 虞海飞. All rights reserved.
//
#import <AVFoundation/AVFoundation.h> //二维码
#import "Tool_Camera.h"

@interface Tool_Camera ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureSession *aVCaptureSession;//会话
@property (nonatomic,strong) AVCaptureDeviceInput *aVCaptureDeviceInput;//输入对象
@property (nonatomic,strong) AVCaptureMetadataOutput *aVCaptureMetadataOutput;//输出对象
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *aVCaptureVideoPreviewLayer;//输出对象
@property (nonatomic,strong) CALayer *drawLayer; // 创建用于绘制边线的图层
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;//是不是要识别脸


@end

#pragma  mark -- 主屏的frame
/**
 *  主屏的frame
 */
#define DEF_SCREEN_FRAME  [UIScreen mainScreen].bounds

@implementation Tool_Camera

#pragma  mark -- 懒加载
- (AVCaptureSession *)aVCaptureSession{

    if (_aVCaptureSession == nil) {

        _aVCaptureSession = [[AVCaptureSession alloc] init];
    }

    return _aVCaptureSession;
}

//拿到输入设备
-(AVCaptureDeviceInput *)aVCaptureDeviceInput{

    if (_aVCaptureDeviceInput == nil) {
        NSError *error;
        //拿摄像头
        AVCaptureDevice *aVCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

        _aVCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:aVCaptureDevice error:&error];
    }

    return _aVCaptureDeviceInput;
}

-(AVCaptureMetadataOutput *)aVCaptureMetadataOutput{

    if (_aVCaptureMetadataOutput == nil) {

        _aVCaptureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    }

    return _aVCaptureMetadataOutput;
}

-(AVCaptureVideoPreviewLayer *)aVCaptureVideoPreviewLayer{

    if (_aVCaptureVideoPreviewLayer == nil) {

        _aVCaptureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.aVCaptureSession];
        _aVCaptureVideoPreviewLayer.frame = DEF_SCREEN_FRAME;
    }

    return _aVCaptureVideoPreviewLayer;
}

-(CALayer *) drawLayer{

    if (_drawLayer == nil) {
        _drawLayer = [[CALayer alloc] init];
        _drawLayer.frame = DEF_SCREEN_FRAME;
    }

    return _drawLayer;
}

-(AVCaptureVideoDataOutput *) videoDataOutput{

    if (_videoDataOutput == nil) {

        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    }
    return _videoDataOutput;
}

#pragma  mark --  调用摄像头
-(void) tool_StartScan_Controller:(UIViewController<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate> *)controller{

    // 1.判断是否能够将输入添加到会话中
    if ([self.aVCaptureSession canAddInput:self.aVCaptureDeviceInput]) {

        [self.aVCaptureSession addInput: self.aVCaptureDeviceInput];
    }

    // 2.判断是否能够将输出添加到会话中
    if ([self.aVCaptureSession canAddOutput:self.aVCaptureMetadataOutput]) {

        [self.aVCaptureSession addOutput: self.aVCaptureMetadataOutput];
    }

    //3.判断是不是有人脸识别
    if ( [self.aVCaptureSession canAddOutput:self.videoDataOutput]){

        [self.aVCaptureSession addOutput:self.videoDataOutput];
    }

    // 4.设置输出能够解析的数据类型
    // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
    self.aVCaptureMetadataOutput.metadataObjectTypes = self.aVCaptureMetadataOutput.availableMetadataObjectTypes;

    // 5.设置输出对象的代理, 只要解析成功就会通知代理 dispatch_get_main_queue()在主线程
    [self.aVCaptureMetadataOutput setMetadataObjectsDelegate:controller queue:dispatch_get_main_queue() ];

    [self.videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    //当然，先不要急，因为捕捉到得帧是YUV颜色通道的，这种颜色通道无法通过以上函数转换，RGBA颜色通道才可以成功转换，所以，先需要把视频帧的输出格式设置一下：
    [self.videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    //前后摄像头
    [self swapFrontAndBackCameras];

    //人脸识别
    [self add_FaceIdentify];

    // 添加预览图层
    [controller.view.layer insertSublayer:self.aVCaptureVideoPreviewLayer atIndex:0];

    // 添加绘制图层到预览图层上
    [self.aVCaptureVideoPreviewLayer addSublayer:self.drawLayer];
    
    [self.aVCaptureSession startRunning];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}


#pragma  mark -- 前后摄像头
/**
 * 前后摄像头
 */
- (void)swapFrontAndBackCameras {
    // Assume the session is already running

    NSArray *inputs = self.aVCaptureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {

            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;

            // 这里本来是用来切换的，现在指定为固定的前置就好了
            // if (position == AVCaptureDevicePositionFront)
            //     newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            // else
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];

            // beginConfiguration ensures that pending changes are not applied immediately
            [self.aVCaptureSession beginConfiguration];

            [self.aVCaptureSession removeInput:input];
            [self.aVCaptureSession addInput:newInput];

            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.aVCaptureSession commitConfiguration];
            break;
        }
    } 
}

#pragma  mark -- 人脸识别
/**
 *人脸识别
 */
-(void) add_FaceIdentify{

    [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:true];
}

/**
 绘制图形

 :param: codeObject 保存了坐标的对象
 */
-(void)drawCorners_CodeObject: (NSArray *)metadataObjects{

    //获取扫描到的二维码的位置
    for (NSObject *object in metadataObjects){

        if ([object isKindOfClass: [AVMetadataMachineReadableCodeObject class]]) {
            // 将坐标转换界面可识别的坐标
            AVMetadataMachineReadableCodeObject  *codeObject = (AVMetadataMachineReadableCodeObject *)[self.aVCaptureVideoPreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)object];
            // 2.1.3绘制图形
            if (codeObject.corners == nil || codeObject.corners.count == 0) {

                return;
            }

            //创建一个图层
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.lineWidth = 4;
            layer.strokeColor =[UIColor redColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;

            //创建路径
            UIBezierPath *path = [[UIBezierPath alloc] init];
            CGPoint point = CGPointZero;
            int index = 0;

            //移动到第一个点
            //从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
            CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)codeObject.corners[index++], &point);
            [path moveToPoint:point];

            //移动到其它的点
            while (index < codeObject.corners.count) {

                CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)codeObject.corners[index++], &point);
                [path addLineToPoint:point];
            }
            //关闭路径
            [path closePath];
            //绘制路径
            layer.path = path.CGPath;
            //将绘制好的图层添加到drawLayer上
            [self.drawLayer addSublayer:layer];
        }
    }
}

/**
 清空边线
 */
-(void) clearConers{

    if (self.drawLayer.sublayers == nil || self.drawLayer.sublayers.count == 0) {
        return;
    }

    for (int i = 0; i <= self.drawLayer.sublayers.count; i++) {
        CALayer *layer = self.drawLayer.sublayers[i];
        [layer removeFromSuperlayer];
    }
}

//得到每一帧
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{

    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    if (image != nil) {

        if ([self.delegate respondsToSelector:@selector(ToolCameraDelegate_Image:)]) {

            [self.delegate ToolCameraDelegate_Image:image];
        }
    }
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);

    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];

    // 释放Quartz image对象
    CGImageRelease(quartzImage);

    return (image);
}

@end
