//
//  OrientationSampleAppDelegate.h
//  OrientationSample
//
//  Created by Chetan Pungaliya on 10/9/11.
//  Copyright 2011 Chetan Pungaliya All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrientationSampleViewController;

@interface OrientationSampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet OrientationSampleViewController *viewController;

@end
