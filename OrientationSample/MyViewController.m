/*
     File: MyViewController.m 
 Abstract: The main view controller of this app.
  
  Version: 1.1 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2011 Apple Inc. All Rights Reserved. 
  
 */

#import "MyViewController.h"

@implementation MyViewController

@synthesize imageView, myToolbar, overlayViewController, capturedImages, text;


#pragma mark -
#pragma mark View Controller

- (void)viewDidLoad
{
    
    UIImage *image = [UIImage imageWithContentsOfFile:@"/users/chetan/Downloads/2.jpg"];
    
    self.imageView.image = image;

    
    self.overlayViewController =
        [[[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil] autorelease];

    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.overlayViewController.delegate = self;
    
    self.capturedImages = [NSMutableArray array];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // camera is not on this device, don't show the camera button
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.myToolbar.items.count];
        [toolbarItems addObjectsFromArray:self.myToolbar.items];
        [toolbarItems removeObjectAtIndex:2];
        [self.myToolbar setItems:toolbarItems animated:NO];
    }
}

- (void)viewDidUnload
{
    self.imageView = nil;
    self.myToolbar = nil;
    
    self.overlayViewController = nil;
    self.capturedImages = nil;
}

- (void)dealloc
{	
	[imageView release];
	[myToolbar release];
    
    [overlayViewController release];
	[capturedImages release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Toolbar Actions

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
        [self.imageView stopAnimating];
	
    if (self.capturedImages.count > 0)
        [self.capturedImages removeAllObjects];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.overlayViewController setupImagePicker:sourceType];
        [self presentModalViewController:self.overlayViewController.imagePickerController animated:YES];
    }
}

- (IBAction)photoLibraryAction:(id)sender
{   
	[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)cameraAction:(id)sender
{
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)load:(id)sender
{
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/users/chetan/Downloads/%d.jpg", ((UIButton *)sender).tag]];
                      
    self.imageView.image = image;
}

- (IBAction)transform:(id)sender
{
    UIImage* image = self.imageView.image;

    NSLog(@"Original Image Size %lu x %lu, orientation %u", CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage), image.imageOrientation);
    
    CGImageRef imageRef = image.CGImage;
    
    int maxSize = 1224;
    int minSize = 700;
    
    int imageInbitmapWidth = CGImageGetWidth(imageRef);
    int imageInbitmapHeight = CGImageGetHeight(imageRef);
    if (imageInbitmapHeight >= imageInbitmapWidth  && imageInbitmapHeight >= minSize)
    {
        imageInbitmapWidth = floorf((float)imageInbitmapWidth * ((float)maxSize / (float)imageInbitmapHeight));
        imageInbitmapHeight = maxSize;
    }
    else if (imageInbitmapWidth >= minSize)
    {
        imageInbitmapHeight = floorf((float)imageInbitmapHeight * ((float)maxSize / (float)imageInbitmapWidth));
        imageInbitmapWidth = maxSize;
    }
    
    int bitmapWidth = imageInbitmapWidth > minSize ? imageInbitmapWidth : minSize;
    int bitmapHeight = imageInbitmapHeight > minSize ? imageInbitmapHeight : minSize;
    int imageInbitmapX = (bitmapWidth - imageInbitmapWidth)/2;
    int imageInbitmapY = (bitmapHeight - imageInbitmapHeight)/2;
    int tmpSwap = 0;
    switch (image.imageOrientation) {
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
    switch (image.imageOrientation)
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
    
    switch (image.imageOrientation) {
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

    int tmpScale = 10;
    
    CGContextSetRGBFillColor (bitmapRef, 0, 1, 0, 1);// 3
    CGContextFillRect (bitmapRef, CGRectMake (0, 0, 50*tmpScale, 100*tmpScale ));// 4
    CGContextSetRGBFillColor (bitmapRef, 0, 0, 1, 1);// 3
    CGContextFillRect (bitmapRef, CGRectMake (0, 0, 50*tmpScale, 25*tmpScale ));// 4
    
    CGContextSetRGBFillColor (bitmapRef, 0, 1, 0, 1);// 3
    CGContextFillRect (bitmapRef, CGRectMake (bitmapHeight-50*tmpScale, bitmapWidth-100*tmpScale, 50*tmpScale, 100*tmpScale ));// 4
    CGContextSetRGBFillColor (bitmapRef, 0, 0, 1, 1);// 3
    CGContextFillRect (bitmapRef, CGRectMake (bitmapHeight-50*tmpScale, bitmapWidth-25*tmpScale, 50*tmpScale, 25*tmpScale ));// 4

    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmapRef);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmapRef);
    CGImageRelease(newImageRef);
    
    NSLog(@"Oriented Image Size %lu x %lu, orientation %u", CGImageGetWidth(newImage.CGImage), CGImageGetHeight(newImage.CGImage), newImage.imageOrientation);
    
    self.imageView.image = newImage;
    
    

    //CGContextFillRect(bitmap, CGRectMake(0, 0, newRect.size.width, newRect.size.height));
    //CGContextSetRGBFillColor (bitmap, 1, 0, 0, 1);// 3
    //CGContextFillRect (bitmap, CGRectMake (100, 0, 100, 200 ));// 4
    
    //CGContextConcatCTM(bitmap, transform);
    
    //CGContextSetRGBFillColor (bitmap, 0, 1, 0, 1);// 3
    //CGContextFillRect (bitmap, CGRectMake (0, 0, 100, 200 ));// 4
    //CGContextSetRGBFillColor (bitmap, 0, 0, 1, 1);// 3
    //CGContextFillRect (bitmap, CGRectMake (0, 0, 100, 50 ));// 4
    

    // Draw into the context; this scales the image
    //CGContextDrawImage(bitmap,  newRect, imgRef);
    
    // Get the resized image from the context and a UIImage

}



#pragma mark -
#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    [self.capturedImages addObject:picture];
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self dismissModalViewControllerAnimated:YES];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // we took a single shot
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // we took multiple shots, use the list of images for animation
            self.imageView.animationImages = self.capturedImages;
            
            if (self.capturedImages.count > 0)
                // we are done with the image list until next time
                [self.capturedImages removeAllObjects];  
            
            self.imageView.animationDuration = 5.0;    // show each captured photo for 5 seconds
            self.imageView.animationRepeatCount = 0;   // animate forever (show all photos)
            [self.imageView startAnimating];
        }
    }
}

@end