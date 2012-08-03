//
//  VSFPageControl.h
//
//  Created by Jose Luis  San Julián Alonso on 11/03/11.
//

#import <UIKit/UIKit.h>


@interface VSFPageControl : UIPageControl {

	UIImage* mImageNormal;
	UIImage* mImageCurrent;
}

@property (nonatomic, retain) UIImage* imageNormal;
@property (nonatomic, retain) UIImage* imageCurrent;

@end