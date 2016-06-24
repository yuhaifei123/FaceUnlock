//
//  Face_NOline.h
//  face_iOS_02
//
//  Created by 虞海飞 on 16/6/20.
//  Copyright © 2016年 虞海飞. All rights reserved.
//


@interface Face_NOline : NSObject

/**
 枚举，申请人返回的数据是不是对
 Array_faceIdCountFew   脸的数量还没有够
 addFaceTestGood        申请脸以后，测试成功
 addFaceTestNO          申请脸以后，测试失败
 addfaceNO              申请脸失败
 faceIDNO               服务器没有返回脸的ID
 notFoundPerson         没有根据脸找到人
 foundPerson            根据脸找到人
 addgroupGood           Group创建成功
 addgroupNO             Group创建失败
 groupAddPersonGood     group添加人成功
 groupAddPersonNO       group添加人失败
 groupTestGood          group，测试成功
 groupTestNO            group，测试失败
 jsonGroupGood          group，返回的数据，解析成功
 jsonGroupNO            group，返回的数据，解析失败
 groupJudgeGoog         group, 人脸识别成功
 groupJudgeNO           group, 人脸识别失败
 */
typedef enum {
                arrayFaceIdCountFew = 1,
                addFaceTestGood,
                addFaceTestNO,
                addfaceNO,
                faceIDNO,
                notFoundPerson,
                foundPerson,
                addGroupGood,
                addGroupNO,
                groupAddPersonGood,
                groupAddPersonNO,
                groupTestGood,
                groupTestNO,
                jsonGroupGood,
                jsonGroupNO,
                groupJudgeGoog,
                groupJudgeNO
} addface;

/**
 *  人的id
 */
@property (nonatomic,copy) NSString *person_id;
/**
 *  人的名字
 */
@property (nonatomic,copy) NSString *person_name;

/**
 *  初始化图片的data
 */
@property (nonatomic,strong) NSData *imageData;

/**
 * 脸的图片
 */
@property (nonatomic,strong) UIImage *faceImage;


/**
 *  初始化 脸在线方法
 *
 *  @param image 需要初始化图片
 *
 *  @return self
 */
- (instancetype)initImage:(UIImage *)image;

/**
 *  检测给定图片(Image)中的所有人脸(Face)的位置和相应的面部属性
 *
 *  @param data 检测人脸的data
 *
 *  @return FaceppResult 默认调用其content(字典)
 */
-(FaceppResult *) face_Detection_NSData:(NSData *)data;

/**
 *  创建人的方法
 *
 *  @param name 人需要的人名
 *
 *  @return FaceppResult 默认调用其content(字典)
 */
-(FaceppResult *) face_PersonCreate_Name:(NSString *)name;

/**
 *  将一组Face加入到一个Person中。注意，一个Face只能被加入到一个Person中
 *  1，等到face_Id
 *  @param image 脸招聘
 *  @param name  personName 人的名字
 *
 *  @return addface 枚举
 */
-(addface) face_AddfaceImage:(UIImage *)image PersonName:(NSString *)name;

/**
 *  人脸申请成功，训练
 *
 *  @param name     人的名字
 *  @param personId 人的id
 *
 *  @return 是否训练成功
 */
-(BOOL) face_VerifyPerson_PersonName:(NSString *)name Person_Id:(NSString *)personId;

/**
 *  根据脸判断是不是同一个人
 *
 *  @param personName   人的名字
 *  @param iamge        扫描的照片
 *
 *  @return addface 枚举
 */
-(addface) judgeFace_PersonName:(NSString *)personName UIImage:(UIImage *)iamge;

/**
 *  添加集团（一个项目就只要一个集团）
 *
 *  @param name <#name description#>
 */
-(addface) addGroup;

/**
 *  把人添加到集团里面去
 *
 *  @param name 把人的名字
 */
-(addface) groupAddPerson_PersonName:(NSString *)personName;

/**
 *  集团测试
 *
 *  @return  @return addface 枚举
 */
-(addface) groupTest;

/**
 *  注册人脸，把几个方法集成在一起，
 *
 *  @param faceImage  脸的图片
 *  @param personName 人的名字
 *
 *  @return addface(枚举)
 */
-(addface) logonFace_FaceImage:(UIImage *)faceImage PersonName:(NSString *)personName;

/**
 *  人脸的照片和集团里面做比较
 *
 *  @param iamge     脸的照片
 *
 *  @return addface
 */
-(addface) judgeFaceAnGroup_FaceUIImage:(UIImage *)iamge;

@end
