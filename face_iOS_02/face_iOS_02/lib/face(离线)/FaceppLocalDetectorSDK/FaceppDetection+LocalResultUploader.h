//
//  FaceppDetection+OfflineResultUploader.h
//  iOSDetectorLib
//
//  Created by faceplusplus.com on 13-9-26.
//  Copyright (c) 2013 Megvii. All rights reserved.
//

#import "FaceppDetection.h"
#import "FaceppLocalDetector.h"

@interface FaceppDetection (LocalResultUploader)

/*!
 *  Commit the local detection result to FacePlusPlus.com to obtain face_ids and other attributes.
 *  It is faster then use online-detection directly.
 */
-(FaceppResult*) uploadLocalResult: (FaceppLocalResult*)result attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag;

@end
