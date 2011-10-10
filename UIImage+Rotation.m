//
//  UIImage+Rotation.m
//  OrientationSample
//
//  Created by Chetan Pungaliya on 10/9/11.
//  Copyright 2011 GoshPosh, Inc. All rights reserved.
//

#import "UIImage+Rotation.h"

@implementation UIImage (UIImage_Rotation)

- (UIImage *)rotateImageToMaxmumSize:(NSUInteger)maxDim withMinimumSize:(NSUInteger)minDim andBackgoundColor:(UIColor *)color
{
    NSLog(@"Original Image Size %lu x %lu, orientation %u", CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage), self.imageOrientation);
    
    CGImageRef imageRef = self.CGImage;
    
    int imageInbitmapWidth = CGImageGetWidth(imageRef);
    int imageInbitmapHeight = CGImageGetHeight(imageRef);
    if (imageInbitmapHeight >= imageInbitmapWidth  && imageInbitmapHeight >= minDim)
    {
        imageInbitmapWidth = floorf((float)imageInbitmapWidth * ((float)maxDim / (float)imageInbitmapHeight));
        imageInbitmapHeight = maxDim;
    }
    else if (imageInbitmapWidth >= minDim)
    {
        imageInbitmapHeight = floorf((float)imageInbitmapHeight * ((float)maxDim / (float)imageInbitmapWidth));
        imageInbitmapWidth = maxDim;
    }
    
    int bitmapWidth = imageInbitmapWidth > minDim ? imageInbitmapWidth : minDim;
    int bitmapHeight = imageInbitmapHeight > minDim ? imageInbitmapHeight : minDim;
    int imageInbitmapX = (bitmapWidth - imageInbitmapWidth)/2;
    int imageInbitmapY = (bitmapHeight - imageInbitmapHeight)/2;
    int tmpSwap = 0;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            tmpSwap = bitmapWidth;
            bitmapWidth = bitmapHeight;
            bitmapHeight = tmpSwap;
            break;
            
        default:
            break;
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(NULL,
                                                   bitmapWidth,
                                                   bitmapHeight,
                                                   8,
                                                   0,
                                                   colorSpaceRef,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetRGBFillColor (bitmapRef, 0, 0, 0, 1);// 3
    CGContextFillRect (bitmapRef, CGRectMake (0, 0, bitmapWidth, bitmapHeight ));// 4
    
    CGColorSpaceRelease(colorSpaceRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, bitmapWidth, bitmapHeight);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, bitmapWidth, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, bitmapHeight);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, bitmapWidth, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, bitmapHeight, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    
    CGContextConcatCTM(bitmapRef, transform);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmapRef, CGRectMake(imageInbitmapX, imageInbitmapY, imageInbitmapWidth, imageInbitmapHeight), imageRef);
    
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmapRef);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmapRef);
    CGImageRelease(newImageRef);
    
    NSLog(@"Oriented Image Size %lu x %lu, orientation %u", CGImageGetWidth(newImage.CGImage), CGImageGetHeight(newImage.CGImage), newImage.imageOrientation);
    
    return newImage;
    
}

@end
