//
//  MVYPageControl.m
//  Mundial_iPhone
//
//  Created by Jose Luis  San Julián Alonso on 26/04/10.
//  Copyright 2010 Mi mundo iPhone. All rights reserved.
//

#import "MVYPageControl.h"


@interface MVYPageControl (Private)
- (void) updateDots;
@end


@implementation MVYPageControl

@synthesize imageNormal = mImageNormal;
@synthesize imageCurrent = mImageCurrent;

- (void) dealloc
{
	[mImageNormal release], mImageNormal = nil;
	[mImageCurrent release], mImageCurrent = nil;
	
	[super dealloc];
}


/** override to update dots */
- (void) setNumberOfPages:(NSInteger)numberOfPages
{
	[super setNumberOfPages:numberOfPages];
	
	// update dot views
	[self updateDots];
}


/** override to update dots */
- (void) setCurrentPage:(NSInteger)currentPage
{
	[super setCurrentPage:currentPage];
	
	// update dot views
	[self updateDots];
}

/** override to update dots */
- (void) updateCurrentPageDisplay
{
	[super updateCurrentPageDisplay];
	
	// update dot views
	[self updateDots];
}

/** Override setImageNormal */
- (void) setImageNormal:(UIImage*)image
{
	[mImageNormal release];
	mImageNormal = [image retain];
	
	// update dot views
	[self updateDots];
}

/** Override setImageCurrent */
- (void) setImageCurrent:(UIImage*)image
{
	[mImageCurrent release];
	mImageCurrent = [image retain];
	
	// update dot views
	[self updateDots];
}

- (void)awakeFromNib {
	
    [super awakeFromNib];
	[self updateDots];
	
    return;
	
}

#pragma mark - (Private)

- (void) updateDots
{
	if(mImageCurrent || mImageNormal)
	{
		// Get subviews
		NSArray* dotViews = self.subviews;
		for(int i = 0; i < dotViews.count; ++i)
		{
			UIImageView* dot = [dotViews objectAtIndex:i];
			// Set image
			dot.image = (i == self.currentPage) ? mImageCurrent : mImageNormal;
			dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, dot.image.size.width, dot.image.size.height);
		}
	}
	
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}


@end
