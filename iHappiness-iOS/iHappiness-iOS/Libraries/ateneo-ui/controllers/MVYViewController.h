//
//  MVYViewController.h
//  As.com-iPad
//
//  Created by Angel Garcia Olloqui on 11/05/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MVYNavigationController;
@class MVYTabbarViewController;

@interface MVYViewController : UIViewController {
	MVYNavigationController *customNavigationController_;
	MVYTabbarViewController *customTabBarController_;
}

@property(nonatomic, retain) MVYNavigationController *customNavigationController;
@property(nonatomic, retain) MVYTabbarViewController *customTabBarController;

@end
