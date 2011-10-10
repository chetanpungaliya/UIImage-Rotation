//
//  OrientationSampleViewController.m
//  OrientationSample
//
//  Created by Chetan Pungaliya on 10/9/11.
//  Copyright 2011 Chetan Pungaliya All rights reserved.
//

#import "OrientationSampleViewController.h"
#import "UIImage+Rotation.h"

@implementation OrientationSampleViewController
@synthesize imageView;
@synthesize originalImage = _originalImage;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageView release];
    [_originalImage release];
    [super dealloc];
}

- (UIImage *) renderImage:(UIImage *)image
{
    
    UIImage *renderedImage = image;
    if (image)
    {
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(NULL,
                                                   CGImageGetWidth(image.CGImage),
                                                   CGImageGetHeight(image.CGImage),
                                                   8,
                                                   0,
                                                   colorSpaceRef,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextSetRGBFillColor (bitmapRef, 0, 0, 0, 1);
    CGContextFillRect (bitmapRef, CGRectMake (0, 0, CGImageGetWidth(image.CGImage),
                                              CGImageGetHeight(image.CGImage)));
    
    CGContextDrawImage(bitmapRef, CGRectMake(0, 0, CGImageGetWidth(image.CGImage),
                                             CGImageGetHeight(image.CGImage)), image.CGImage);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmapRef);
    renderedImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmapRef);
    CGImageRelease(newImageRef);
    
    }
    return renderedImage;
}

- (IBAction)loadImage:(id)sender {
    
    self.originalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", ((UIButton *)sender).tag]];
    
    UIImage *image = self.originalImage;
    
    self.imageView.image = [self renderImage:image];
}

- (IBAction)rotate:(id)sender {
    
    self.imageView.image = [self renderImage:[self.originalImage rotateImageToMaxmumSize:5000 withMinimumSize:400 andBackgoundColor:[UIColor blackColor]]];
}
@end
