//
//  UIViewExtras.m
//  ABC_iPad
//
//  Created by Angel Garcia Olloqui on 10/03/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "UIViewExtras.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(extras)

- (UIImage *) convertToImage {
	
	UIGraphicsBeginImageContext(self.frame.size);
	
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return viewImage;		
}

- (void) removeSubviews {
	NSArray *subviews = [self subviews];	
	for (UIView *v in subviews)
		[v removeFromSuperview];	
}


- (void) removeGesturesRecognizers{
	#if __IPHONE_3_2
	NSArray *gestures = [self gestureRecognizers];
	for (UIGestureRecognizer *g in gestures)
		[self removeGestureRecognizer:g];	
	#endif
}
@end
