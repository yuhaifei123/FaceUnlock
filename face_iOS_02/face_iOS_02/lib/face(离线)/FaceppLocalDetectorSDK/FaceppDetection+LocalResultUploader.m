//
//  FaceppDetection+OfflineResultUploader.m
//  iOSDetectorLib
//
//  Created by youmu on 13-9-27.
//  Copyright (c) 2013年 Yang Mu. All rights reserved.
//

#import "FaceppDetection+LocalResultUploader.h"
#import "FaceppClient.h"

@implementation FaceppDetection (LocalResultUploader)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    int width = newSize.width;
    int height = newSize.height;
    
    unsigned char *rawData = (unsigned char*) malloc(width*height*sizeof(unsigned char));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    NSUInteger bytesPerPixel = 1;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, 0);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    free(rawData);
    return [UIImage imageWithCGImage: grayImageRef];
}

#undef attribute
-(FaceppResult*) uploadLocalResult: (FaceppLocalResult*)result attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag {
    // resize to 600x600
    int sizeLimit = 600;
    float scale = MAX([result.image size].width / sizeLimit, [result.image size].height / sizeLimit);
    if (scale > 1) {
        result.image = [FaceppDetection imageWithImage:result.image scaledToSize:
                        CGSizeMake([result.image size].width/scale, [result.image size].height/scale)];
    } else
        scale = 1;
    NSMutableString *offline_result = [NSMutableString stringWithString:@"["];
    for (size_t i=0; i<result.faces.count; i++) {
        if (i>0)
            [offline_result appendString: @","];
        FaceppLocalFace *face = [result.faces objectAtIndex:i];
        [offline_result appendFormat:@"[%d,%d,%d,%d]",
         (int)(face.bounds.origin.x / scale),
         (int)(face.bounds.origin.y / scale),
         (int)((face.bounds.origin.x+face.bounds.size.width) / scale),
         (int)((face.bounds.origin.y+face.bounds.size.height) / scale)];
    }
    [offline_result appendString:@"]"];
    
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:4];
    [params addObject:@"mode"];
    [params addObject:@"offline"];
    [params addObject:@"offline_result"];
    [params addObject:offline_result];
    
    NSData *data = UIImageJPEGRepresentation(result.image, 0);
    return [self detectWithURL:nil orImageData:data mode:FaceppDetectionModeDefault attribute:attribute tag:tag async:NO others:params];
}

@end
