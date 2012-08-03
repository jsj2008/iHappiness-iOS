//
//  MVYPageIndicator.h
//  BBVA Bolsa
//
//  Created by Alejandro Hernández Matías on 14/07/10.
//  Copyright 2010 Mobivery. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MVYPageIndicator : UIViewController <UIScrollViewDelegate> {
	
	UIImage *imageNoSelected_;
	UIImage *imagePartialSelected_;
	UIImage *imageSelected_;
	
	UIScrollView *scrollView_;
	
	BOOL verticalOrientation_;

}

@property (nonatomic, retain) UIImage* imageNoSelected;
@property (nonatomic, retain) UIImage* imagePartialSelected;
@property (nonatomic, retain) UIImage* imageSelected;

@property (nonatomic, retain) UIScrollView* scrollView;

@property (nonatomic) BOOL verticalOrientation;

- (id)initWithScroll:(UIScrollView *)scroll;

@end
