//
//  OrientationSampleViewController.h
//  OrientationSample
//
//  Created by Chetan Pungaliya on 10/9/11.
//  Copyright 2011 Chetan Pungaliya All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrientationSampleViewController : UIViewController {
    UIImageView *imageView;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImage *originalImage;

- (IBAction)loadImage:(id)sender;
- (IBAction)rotate:(id)sender;

- (UIImage *) renderImage:(UIImage *)image;

@end
