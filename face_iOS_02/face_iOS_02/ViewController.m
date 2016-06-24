//
//  ViewController.m
//  face_iOS_02
//
//  Created by 虞海飞 on 16/6/12.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import "ViewController.h"
#import "Camera_Up.h"
#import "Tool_Camera.h"
#import "Face_Offline.h"
#import "Tool_Image.h"
#import "AppDelegate.h"
#import "Face_NOline.h"//脸线上

@interface ViewController ()

//开启摄像头
@property(nonatomic,strong) Camera_Up *camera_Up;
@property(nonatomic,strong) Face_Offline *face_Offline;//离线包
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) Face_NOline *face_NOline;//脸线上
@end

const NSString  *face_key = @"75e26ab2c0415e91f88569582d26a1be";

@implementation ViewController

-(Face_Offline *) face_Offline{

    if (_face_Offline == nil) {

        _face_Offline = [[Face_Offline alloc] initKey:(NSString *)face_key];
    }
    return _face_Offline;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _camera_Up = [[Camera_Up alloc] initContr:self];

    _face_NOline = [[Face_NOline alloc] init];
//    [self.face_NOline addGroup];
//    [self.face_NOline groupAddPerson_PersonName:@"yuhaifei_03"];
//    [self.face_NOline groupTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/******************* ToolCameraDelegate 调用摄像头代理  *******************/
/**
 *  摄像头返回图片
 *
 *  @param image 返回图片
 */
-(void)ToolCameraDelegate_Image:(UIImage *)image{

    //绘画好的图片
    UIImage *image_Right = [Tool_Image imageRotating:image rotation:UIImageOrientationRight];
    //下线包检测有没有脸
   NSMutableDictionary *dic  = [self.face_Offline detectorFaceImage:image_Right];
    NSString *dic_count = [NSString stringWithFormat:@"%@",dic[@"count"]];
    if ([dic_count isEqualToString:@"1"]) {

//      addface state =  [self.face_NOline logonFace_FaceImage:image_Right PersonName:@"yuhaifei"];
//
//        NSLog(@"%d",state);
     addface state =   [self.face_NOline judgeFaceAnGroup_FaceUIImage:image_Right];
        NSLog(@"%d",state);
    }
}

@end
