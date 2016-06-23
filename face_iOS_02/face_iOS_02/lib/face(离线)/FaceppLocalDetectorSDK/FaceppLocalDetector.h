//
//  FaceppOfflineDetector.h
//  iOSDetectorLib
//
//  Created by faceplusplus.com on 13-9-26.
//  Copyright (c) 2013 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/** @defgroup DetectorOptionKeys Detector Configuration Keys
 *  Keys used in the options dictionary to configure a detector.
 *  @{
 */

/*! 
 *  A Key used to specify the minimal size(in pixel) of face for the detector.
 *  The value associated with the key should be an instance of NSNumber with intValue.
 */
extern NSString* const FaceppDetectorMinFaceSize;

/*! 
 *  A Key used to specify the desired accuracy for the detector.
 *  The value associated with the key should be one of the values found in @link AccuracyOptions "Detector Accuracy Options"@endlink.
 */
extern NSString* const FaceppDetectorAccuracy;

/*!
 *  A Key used to enable/disable tracking mode.
 *  The value associated with the key should be an instance of NSNumber with boolValue.
 *  If the tracking mode is on, the images used to detect should be continurous(for example, the list of image is from the same camera), and the result of detection will contains #FaceppLocalFace::trackingID.
 */
extern NSString* const FaceppDetectorTracking;

/*@}*/

/** @defgroup AccuracyOptions Detector Accuracy Options
 *  Value options used to specify the desired accuracy of the detector.
 *  @{
 */

/** Indicates the detector should choose techniques that are lower in accuracy, but more quickly in speed. */
extern NSString* const FaceppDetectorAccuracyNormal;

/** Indicates the detector should choose techniques that are higher in accuracy, and it may takes more processing time. */
extern NSString* const FaceppDetectorAccuracyHigh;

/*@}*/

/*!
 *  Information of the face in detection result.
 */
@interface FaceppLocalFace: NSObject

/** Bounding box of the face in image. */
@property(nonatomic) CGRect bounds;

/** In tracking mode, this ID denote which target this face belong to. */
@property int trackingID;

-(id) initWithBounds: (CGRect) bounds andTrackingID: (int)trackingID;
@end;

/*!
 *  Detection result.
 */
@interface FaceppLocalResult: NSObject

/** An array of #FaceppLocalFace objects. Each object represents a face detected in the image. */
@property(nonatomic, retain) NSArray *faces;

/** The image used for detection. */
@property(nonatomic, retain) UIImage *image;
@end

/*!
 *  A FaceppLocalDetector object can detect human faces in an image or tracking faces in continurous images. 
 */
@interface FaceppLocalDetector : NSObject

/*!
 *  Creates and returns a configured detector
 *
 *  @param options A dictionary containing details how the detector to be configured. See @link DetectorOptionKeys "Detector Configuration Keys"@endlink.
 *  @param key A string contains your registered API key in FacePlusPlus.com.
 *  @return A configured detector. If apikey or sdk-token is invalid, then return nil.
 */
+(FaceppLocalDetector*) detectorOfOptions: (NSDictionary*) options andAPIKey:(NSString*)key;

/*!
 *  Re-configure the detector
 *
 *  @param options A dictionary containing details how the detector to be configured. See @link DetectorOptionKeys "Detector Configuration Keys"@endlink.
 */
-(void) setOptions: (NSDictionary*) options;

/*!
 *  Detect faces in an image
 *
 *  @param image The image you want to detect for.
 *  @return A #FaceppLocalResult object that represents the result of detection.
 */
-(FaceppLocalResult*) detectWithImage: (UIImage*) image;

/*!
 *  Get the version of this FacePlusPlus Local Detector library
 */
-(NSString*) getVersion;

@end
