//
//  PageViewController.h
//  nieve-prisacom
//
//  Created by Jose Luis  San Julián Alonso on 26/01/10.
//  Copyright 2010 Mi mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSFPageControl.h"

@protocol PageViewControllerDelegate

- (NSInteger) numberOfPages;
- (UIViewController *)viewControllerForPage:(NSInteger)page;

@optional

- (void) willChangePageTo:(NSInteger)page;

@end


@interface PageViewController : UIViewController<UIScrollViewDelegate> {

	id<PageViewControllerDelegate> delegate_;
	UIScrollView *scrollView_;
	//UIPageControl *pageControl_;
	VSFPageControl *pageControl_;
	NSInteger numberOfPages_;
	
	NSMutableArray *viewControllers_;
	BOOL pageControlUsed_;
	NSInteger pageControlHeight_;
}

@property (nonatomic, assign) id<PageViewControllerDelegate> delegate;
//@property (readonly) UIPageControl *pageControl;
@property (readonly) VSFPageControl *pageControl;
@property (readonly) UIScrollView *scrollView;
@property (readonly) NSArray *viewControllers;
@property NSInteger pageControlHeight;

- (id) init;
- (IBAction)changePage:(id)sender;
- (void) changePageTo:(NSInteger)page animated:(BOOL)animated;
- (void)loadScrollViewWithPage:(int)page;

@end
