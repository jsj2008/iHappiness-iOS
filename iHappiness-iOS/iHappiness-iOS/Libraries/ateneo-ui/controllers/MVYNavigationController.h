//
//  MVYNavigationController.h
//  ABC_iPad
//
//  Created by Angel Garcia Olloqui on 27/04/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVYViewController.h"

#define EFFECT_NONE 0
#define EFFECT_FADE 1
#define EFFECT_FLIP 2
#define EFFECT_SCALE 3
#define PAGE_ANIMATION_SCALE 0.85
#define PAGE_ANIMATION_DURATION 0.3


@interface MVYNavigationController : MVYViewController {
	NSMutableArray *viewControllers_;
	NSString *effects_;
	NSAutoreleasePool *pool_;
	
	UIView *contentView_;
	UIView *navView_;
	
	BOOL loaded_;
}
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIView *navView;
@property(readonly) NSArray *viewControllers;

//Push a new ViewController in the main window with a fade efect
- (void) pushViewController:(UIViewController *)controller;
//Push a new ViewController in the main window with a custom effect
- (void) pushViewController:(UIViewController *)controller effect:(NSInteger)effect;
//Pop last viewController out the main window with the opposite effect
- (void) popViewController;
//Pop last viewController out the main window with the opposite effect
- (void) popViewController:(BOOL)animated;
//Pop all viewcontroller without effects
- (void) popToRootController;
//Create a Safari like page effect transition between two images at fullscreen
- (void) generatePageAnimation:(UIImage *)fromImage toImage:(UIImage *)toImage directionLeft:(BOOL)directionLeft;


@end
