//
//  MVYTabbarViewController.h
//  cincodias_iPad
//
//  Created by Angel Garcia Olloqui on 22/07/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVYViewController.h"

@interface MVYTabbarViewController : MVYViewController {
	UIView *containerView_;
	
	NSArray *viewControllers_;
	UIViewController *selectedViewController_;
	NSUInteger selectedIndex_;
	id<UITabBarControllerDelegate> delegate_;
}

@property (nonatomic, retain) IBOutlet UIView *containerView;

//Properties y metodos de UITababr
@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,assign) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic,assign) id<UITabBarControllerDelegate> delegate;

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;



@end
