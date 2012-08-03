    //
//  MVYViewController.m
//  As.com-iPad
//
//  Created by Angel Garcia Olloqui on 11/05/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "MVYViewController.h"


@implementation MVYViewController

@synthesize customNavigationController=customNavigationController_;
@synthesize customTabBarController=customTabBarController_;


- (void)dealloc {
	self.customNavigationController=nil;
	self.customTabBarController=nil;
    [super dealloc];
}


- (UIInterfaceOrientation) interfaceOrientation {
	return [[UIApplication sharedApplication] statusBarOrientation];
}

@end
