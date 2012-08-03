//
//  MVYPageControl.h
//  Mundial_iPhone
//
//  Created by Jose Luis  San Julián Alonso on 26/04/10.
//  Copyright 2010 Mi mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MVYPageControl : UIPageControl {
    
	UIImage* mImageNormal;
	UIImage* mImageCurrent;
}

@property (nonatomic,readwrite,retain) UIImage* imageNormal;
@property (nonatomic,readwrite,retain) UIImage* imageCurrent;

@end