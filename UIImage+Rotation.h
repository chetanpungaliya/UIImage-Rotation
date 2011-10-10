//
//  UIImage+Rotation.h
//  OrientationSample
//
//  Created by Chetan Pungaliya on 10/9/11.
//  Copyright 2011 GoshPosh, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Rotation)

- (UIImage *)rotateImageToMaxmumSize:(NSUInteger)maxDim withMinimumSize:(NSUInteger)minDim andBackgoundColor:(UIColor *)color;

@end
