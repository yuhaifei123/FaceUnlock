//
//  Face_NOline.m
//  face_iOS_02
//
//  Created by 虞海飞 on 16/6/20.
//  Copyright © 2016年 虞海飞. All rights reserved.
// 脸在线方法

#import "Face_NOline.h"

@interface Face_NOline ()

@end

/**
 *  默认添加5个face_Id,发送给Person(人)，创建人
 */
static  NSMutableArray *mArray_faceId;

/**
 *  默认一个人默认是5张脸的照片
 */
static const int faceNo = 3;

/**
 * 集团的名字
 */
NSString* const groupName = @"集团的名字";

@implementation Face_NOline

/**
 *  注册人脸，把几个方法集成在一起，
 *
 *  @param faceImage  脸的图片
 *  @param personName 人的名字
 *
 *  @return addface(枚举)
 */
-(addface) logonFace_FaceImage:(UIImage *)faceImage PersonName:(NSString *)personName{

    addface faceState = [self face_AddfaceImage:faceImage PersonName:personName];
    if (faceState == addFaceTestNO) {

        [self groupAddPerson_PersonName:personName];
        [self groupTest];
    }

    return faceState;
}

/**
 *  初始化 脸在线方法
 *
 *  @param image 需要初始化图片
 *
 *  @return self
 */
- (instancetype)initImage:(UIImage *)image{

    self = [super init];

    [FaceppAPI setDebugMode:YES];
    if (self) {
        self.imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    return self;
}

/**
 *  检测给定图片(Image)中的所有人脸(Face)的位置和相应的面部属性
 *
 *  @param data 检测人脸的data
 *
 *  @return FaceppResult 默认调用其content(字典)
 */
-(FaceppResult *) face_Detection_NSData:(NSData *)data{

    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil
                                                    orImageData:data];
    return result;
}

/**
 *  创建人的方法
 *
 *  @param name 人需要的人名
 *
 *  @return FaceppResult 默认调用其content(字典)
 */
-(FaceppResult *) face_PersonCreate_Name:(NSString *)name{

    FaceppResult *personResult = [[FaceppAPI person] createWithPersonName: name
                                                                andFaceId: nil
                                                                   andTag: nil
                                                               andGroupId: nil
                                                              orGroupName: nil];
    return personResult;
}

/**
 *  将一组Face加入到一个Person中。注意，一个Face只能被加入到一个Person中
 *  1，等到face_Id
 *  @param image 脸照片
 *  @param name  personName 人的名字
 *
 *  @return addface 枚举
 */
-(addface) face_AddfaceImage:(UIImage *)image PersonName:(NSString *)name{

    self.imageData = UIImageJPEGRepresentation(image, 1.0);
    //得到脸照片的Id
    FaceppResult *faceppResult = [self face_Detection_NSData:self.imageData];

    NSString *face_Id = [self jsonParsing_Dic:faceppResult.content];

    //全局变量存放face_Id数组
    if (mArray_faceId == nil) {

        mArray_faceId = [NSMutableArray array];
    }

    int  count = mArray_faceId.count;
    if (face_Id != nil) {

        if (count < faceNo) {

            mArray_faceId[count] = face_Id;
            return arrayFaceIdCountFew;
        }
        else if (count == faceNo){

            if ([self fice_PersonAddFace_Name:name MArray_faceId:mArray_faceId] == true) {

                return addFaceTestGood;
            }
            return addFaceTestNO;
        }
    }

    return faceIDNO;
}

/**
 *  创建人，在人里面添加脸（face_Id）
 *  @param MArray_faceId 需要给人的face_Id
 *  @param 是否正确
 */
-(BOOL) fice_PersonAddFace_Name:(NSString *)name MArray_faceId:(NSArray *)mArray_faceId{

    //申请人
    FaceppResult *faceppResult = [self face_PersonCreate_Name:name];
    NSDictionary *dic = faceppResult.content;
    //判断返回的数据正确
    if (dic[@"person_id"] != nil) {

        NSArray *array_Person = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",dic[@"person_id"]],[NSString stringWithFormat:@"%@",dic[@"person_name"]],nil];

       FaceppResult *faceppResulr = [[FaceppAPI person] addFaceWithPersonName:array_Person[1] orPersonId:array_Person[0] andFaceId:mArray_faceId];

        //判断是不是申请人成功
        if (faceppResulr.success == 1) {

            self.person_id = array_Person[0];
            self.person_name = array_Person[1];

            //每次添加完了以后，
           return [self face_VerifyPerson_PersonName:self.person_name Person_Id:self.person_id];
        }
        return faceppResulr.success;
    }

    return false;
}

/**
 *  json解析器，解析
 *
 *  @param dic 服务器返回的脸的数据
 *
 *  @return face_Id;
 */
-(NSString *) jsonParsing_Dic:(NSDictionary *)dic{
    //得到服务器
    NSArray *array_Face = dic[@"face"];
    if (array_Face.count >= 1) {

        NSDictionary *dic_Face = array_Face[0];
        return [NSString stringWithFormat:@"%@",dic_Face[@"face_id"]];
    }

    return nil;
}

/**
 *  人脸申请成功，训练
 *
 *  @param name     人的名字
 *  @param personId 人的id
 *
 *  @return 是否训练成功
 */
-(BOOL) face_VerifyPerson_PersonName:(NSString *)name Person_Id:(NSString *)personId{

    FaceppResult *faceppResulr = [[FaceppAPI train] trainAsynchronouslyWithId:personId orName:name andType:FaceppTrainVerify];

    //得到返回对象
    NSDictionary *dic = faceppResulr.content;
    if (dic[@"session_id"] != nil) {

        return true;
    }

    return false;
}

/**
 *  根据脸判断是不是同一个人
 *
 *  @param personName   人的名字
 *  @param iamge        扫描的照片
 *
 *  @return addface 枚举
 */
-(addface) judgeFace_PersonName:(NSString *)personName UIImage:(UIImage *)iamge{

    //得到脸照片的Id
    FaceppResult *faceppResult = [self face_Detection_NSData:self.imageData];
    NSString *face_Id = [self jsonParsing_Dic:faceppResult.content];
    //判断face_Id 是不是存在
    if (face_Id != nil){

        //得到脸部检测结果，判断是不是同一个人
        FaceppResult *faceppResult = [[FaceppAPI recognition] verifyWithFaceId:face_Id andPersonId:nil orPersonName:personName async:NO];
        NSString *string_is_same_person = [NSString stringWithFormat:@"%@",faceppResult.content[@"is_same_person"]];
        if(faceppResult.content[@"is_same_person"] != nil){

            if ([string_is_same_person isEqualToString:@"1" ]) return foundPerson;
        }
    }
    else{
        return faceIDNO;
    }

    return notFoundPerson;
}

/**
 *  人脸的照片和集团里面做比较
 *
 *  @param iamge     脸的照片
 *
 *  @return addface
 */
-(addface) judgeFaceAnGroup_FaceUIImage:(UIImage *)iamge{

    self.imageData = UIImageJPEGRepresentation(iamge, 1.0);
    // 返回数据判断
   FaceppResult *faceppResult = [[FaceppAPI recognition] identifyWithGroupId:nil
                                     orGroupName: groupName
                                          andURL:nil
                                     orImageData:self.imageData
                                     orKeyFaceId:nil
                                           async:NO];
    NSLog(@"%@",faceppResult.content);

    return nil;
}

/**
 *  添加集团（一个项目就只要一个集团）
 *
 *   @return addface 枚举
 */
-(addface) addGroup{

    //得到脸部检测结果，判断是不是同一个人
    FaceppResult *faceppResult = [[FaceppAPI group] createWithGroupName:groupName];

    if (faceppResult.content[@"group_name"] != nil) return addGroupGood;

    return addGroupNO;
}

/**
 *  把人添加到集团里面去
 *
 *  @param name 把人的名字
     @return addface 枚举
 */
-(addface) groupAddPerson_PersonName:(NSString *)personName{

    NSArray *array_Person = [NSArray arrayWithObjects:personName, nil];
    //把脸添加到
    FaceppResult *faceppResult = [[FaceppAPI group] addPersonWithGroupId:nil orGroupName:groupName andPersonId:nil orPersonName:array_Person];

    //判读是不是成功
    NSString *string_success = [NSString stringWithFormat:@"%@",faceppResult.content[@"success"]];
    if ([string_success isEqualToString:@"1"]) return groupAddPersonGood;

    return addGroupNO;
}

/**
 *  集团测试
 *
 *  @return  @return addface 枚举
 */
-(addface) groupTest{

     FaceppResult *faceppResulr = [[FaceppAPI train] trainAsynchronouslyWithId:nil orName:groupName andType:FaceppTrainIdentify];

    //判读是不是测试成功
    if (faceppResulr.content[@"session_id"] != nil) return groupTestGood;

    return groupTestNO;
}

@end
