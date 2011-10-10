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
    [super dealloc];
}
- (IBAction)loadImage:(id)sender {
    
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", ((UIButton *)sender).tag]];
    self.imageView.image = image;
}

- (IBAction)rotate:(id)sender {
    
    self.imageView.image = [self.imageView.image rotateImageToMaxmumSize:5000 withMinimumSize:400 ansBackgoundColor:[UIColor blackColor]];
}
@end
