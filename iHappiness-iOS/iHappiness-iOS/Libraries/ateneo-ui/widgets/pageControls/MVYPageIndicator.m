    //
//  MVYPageIndicator.m
//  BBVA Bolsa
//
//  Created by Alejandro Hernández Matías on 14/07/10.
//  Copyright 2010 Mobivery. All rights reserved.
//

#import "MVYPageIndicator.h"

#define HEIGHT_VIEW_INDICATOR 14
#define WIDHT_POINT_INDICATOR 14

@interface MVYPageIndicator (private)

-(int)calculateNumOfViews;

-(void)createViewIndicator;

-(void)addImagesIndicator;

-(void)caluclateImagesPositionViews;

-(void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation MVYPageIndicator

@synthesize imageNoSelected = imageNoSelected_, imagePartialSelected = imagePartialSelected_, imageSelected = imageSelected_, scrollView = scrollView_, verticalOrientation = verticalOrientation_;

int numOfViews_;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithScroll:(UIScrollView *)scroll{
	if (self = [super init]) {
		
		[self setScrollView:scroll];
		[self setVerticalOrientation:FALSE];
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	numOfViews_ = [self calculateNumOfViews];
	[scrollView_ setDelegate:self];
	
	for (UIView *view in [scrollView_ subviews])
		NSLog(@"view: %@", view);

	NSLog(@"total vistas: %d", [[scrollView_ subviews] count]);
	[self createViewIndicator];
	[self addImagesIndicator];
	
	[self caluclateImagesPositionViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  
	self.imageNoSelected = nil;
	self.imagePartialSelected = nil;
	self.imageSelected = nil;
	
	[self.scrollView setDelegate:nil];
	self.scrollView = nil;
	
	[super dealloc];
}


-(void)createViewIndicator{
	
	
	if(verticalOrientation_)
		[self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,HEIGHT_VIEW_INDICATOR,WIDHT_POINT_INDICATOR*numOfViews_)];
	else
		[self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,WIDHT_POINT_INDICATOR*numOfViews_,HEIGHT_VIEW_INDICATOR)];
}

-(void)addImagesIndicator{
	
	for(int i = 0; i < numOfViews_; i++){
		
		UIImageView *pointImage = [[UIImageView alloc] initWithImage:imageNoSelected_];
		
		if(verticalOrientation_)
			[pointImage setFrame:CGRectMake((HEIGHT_VIEW_INDICATOR-imageNoSelected_.size.width)/2,WIDHT_POINT_INDICATOR*i,imageNoSelected_.size.width,imageNoSelected_.size.height)];
		else
			[pointImage setFrame:CGRectMake(WIDHT_POINT_INDICATOR*i,(HEIGHT_VIEW_INDICATOR-imageNoSelected_.size.height)/2,imageNoSelected_.size.width,imageNoSelected_.size.height)];
		
		[pointImage setTag:i+1];
		[self.view addSubview:pointImage];
		[pointImage release];
	}
}
	 
	 
	 
-(int) calculateNumOfViews{
	
	int i = 0;
	
	for (UIView *view in [scrollView_ subviews]) {
		
		if([view alpha] != 0)
			i++;
	}
	
	return i;
}

-(void)caluclateImagesPositionViews{
	
	CGPoint contentOffset = [(UIScrollView*)[self scrollView] contentOffset];
	
	int i = 0;
	
	for (UIView *view in [scrollView_ subviews]) {
		
		if([view alpha] != 0){
		
			UIImageView *point = (UIImageView*)[self.view viewWithTag:i+1];
			
			if(point != NULL){
				
				if(!verticalOrientation_){
				
					if((view.frame.origin.x > contentOffset.x) && (view.frame.origin.x + view.frame.size.width <= contentOffset.x + scrollView_.frame.size.width)){
						
						[point setImage:imageSelected_];
						
					}else if(((view.frame.origin.x > contentOffset.x) && (view.frame.origin.x + view.frame.size.width > contentOffset.x + scrollView_.frame.size.width) && (view.frame.origin.x < contentOffset.x + scrollView_.frame.size.width)) ||
							 ((view.frame.origin.x < contentOffset.x) && (view.frame.origin.x + view.frame.size.width > contentOffset.x))){
						
						[point setImage:imagePartialSelected_];
						
					}else{
						
						[point setImage:imageNoSelected_];
					}
					
				}else{
						
					if((view.frame.origin.y > contentOffset.y) && (view.frame.origin.y + view.frame.size.height <= contentOffset.y + scrollView_.frame.size.height)){
						
						[point setImage:imageSelected_];
						
					}else if(((view.frame.origin.y > contentOffset.y) && (view.frame.origin.y + view.frame.size.height > contentOffset.y + scrollView_.frame.size.height) && (view.frame.origin.y < contentOffset.y + scrollView_.frame.size.height)) ||
							 ((view.frame.origin.y < contentOffset.y) && (view.frame.origin.y + view.frame.size.height > contentOffset.y))){
						
						[point setImage:imagePartialSelected_];
						
					}else{
						
						[point setImage:imageNoSelected_];
					}		
				}
			}
		
		i++;
		}
	}
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method.
	
	[self caluclateImagesPositionViews];
	
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
/*- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}*/

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollViewDidScroll:scrollView];
}



@end
