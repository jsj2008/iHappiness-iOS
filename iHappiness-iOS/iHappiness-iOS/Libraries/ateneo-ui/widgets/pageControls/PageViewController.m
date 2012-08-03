//
//  PageViewController.m
//  nieve-prisacom
//
//  Created by Jose Luis  San Julián Alonso on 26/01/10.
//  Copyright 2010 Mi mundo iPhone. All rights reserved.
//

#import "PageViewController.h"

#define PAGECONTROL_HEIGHT 40

@interface PageViewController (private)

- (void)loadScrollViewWithPage:(int)page;

@end


@implementation PageViewController

@synthesize delegate=delegate_;
@synthesize pageControl=pageControl_;
@synthesize scrollView=scrollView_;
@synthesize pageControlHeight=pageControlHeight_;
@synthesize viewControllers=viewControllers_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	pageControlHeight_=PAGECONTROL_HEIGHT;
	return self;	
}


- (id) init {
	self=[super init];
	pageControlHeight_=PAGECONTROL_HEIGHT;
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	scrollView_ = [[UIScrollView alloc] init];
	scrollView_.pagingEnabled=YES;
	scrollView_.showsHorizontalScrollIndicator=NO;
	scrollView_.showsVerticalScrollIndicator=NO;	
	scrollView_.delegate=self;
	//pageControl_ = [[UIPageControl alloc] init];
	pageControl_ = [[VSFPageControl alloc] init];
	
	[self.view addSubview:scrollView_];
	[self.view addSubview:pageControl_];	
	
	//Modificamos el pageController
	//[pageControl_ setImageNormal:[UIImage imageNamed:@"page control desact.png"]];
	//[pageControl_ setImageCurrent:[UIImage imageNamed:@"page control.png"]];

	
	[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];	
}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	
	if (numberOfPages_<=0){
		numberOfPages_ = [delegate_ numberOfPages];
		NSMutableArray *controllers = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < numberOfPages_; i++) {
			[controllers addObject:[NSNull null]];
		}
		[viewControllers_ release];
		viewControllers_ =	controllers;
		
		[pageControl_ setFrame:CGRectMake(0, self.view.frame.size.height-pageControlHeight_, self.view.frame.size.width, pageControlHeight_)];
		[pageControl_ addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		[pageControl_ setNumberOfPages:numberOfPages_];
		
		CGRect frame = self.view.frame;
		frame.size.height=frame.size.height-pageControlHeight_;
		[scrollView_ setFrame:frame];
		[scrollView_ setContentSize:CGSizeMake(numberOfPages_*self.view.frame.size.width, frame.size.height)];
		
		[pageControl_ setCurrentPage:0];
		
		//Cargamos las tres paginas
		[self loadScrollViewWithPage:pageControl_.currentPage-1];
		[self loadScrollViewWithPage:pageControl_.currentPage];
		[self loadScrollViewWithPage:pageControl_.currentPage+1];
	}else {
		CGFloat pageWidth = scrollView_.frame.size.width;
		int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		
		UIViewController *vc = [viewControllers_ objectAtIndex:page];
		if ([vc isKindOfClass:[UIViewController class]])
			[vc viewWillAppear:animated];
	}
}


- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	CGFloat pageWidth = scrollView_.frame.size.width;
	int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if ([viewControllers_ count]>page){
		UIViewController *vc = [viewControllers_ objectAtIndex:page];
		if ([vc isKindOfClass:[UIViewController class]])
			[vc viewWillDisappear:animated];
	}
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.delegate=nil;
	scrollView_.delegate=nil;
	[self.view removeObserver:self forKeyPath:@"frame"];
	[viewControllers_ release]; viewControllers_ = nil;
	[scrollView_ release];  scrollView_ = nil;
	[pageControl_ release];  pageControl_=nil;
    [super dealloc];
}



- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= numberOfPages_) return;
	
    // replace the placeholder if necessary
    UIViewController *controller = [viewControllers_ objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
		controller = [delegate_ viewControllerForPage:page];
        [viewControllers_ replaceObjectAtIndex:page withObject:controller];
    }
		
    // add the controller's view to the scroll view
	if (nil == controller.view.superview) {
        controller.view.frame = CGRectMake(scrollView_.frame.size.width*page, 0, scrollView_.frame.size.width, scrollView_.frame.size.height);
        [scrollView_ addSubview:controller.view];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
	CGFloat pageWidth = scrollView_.frame.size.width;
	int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (pageControlUsed_){
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
	if ((pageControl_.currentPage!=page) && (page<numberOfPages_) && (page>=0)){
		if ([((NSObject *) delegate_) respondsToSelector:@selector(willChangePageTo:)])
			[delegate_ willChangePageTo:page];
		if ([[viewControllers_ objectAtIndex:pageControl_.currentPage] isKindOfClass:[UIViewController class]])
			[[viewControllers_ objectAtIndex:pageControl_.currentPage] viewWillDisappear:YES];
		[[viewControllers_ objectAtIndex:page] viewWillAppear:YES];
		pageControl_.currentPage = page;		
	}	
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed_ = NO;
	[self scrollViewDidScroll:scrollView];
}

- (IBAction)changePage:(id)sender {
	[self changePageTo:pageControl_.currentPage animated:YES];	
}


- (void) changePageTo:(NSInteger)page animated:(BOOL)animated {
	if ((page<0) || (page>=numberOfPages_)) return;
	
	CGFloat pageWidth = scrollView_.frame.size.width;
	int pageOld = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (pageOld!=page){
		if ([((NSObject *) delegate_) respondsToSelector:@selector(willChangePageTo:)])
			[delegate_ willChangePageTo:page];
		
		// load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
		[self loadScrollViewWithPage:page - 1];
		[self loadScrollViewWithPage:page];
		[self loadScrollViewWithPage:page + 1];
		// update the scroll view to the appropriate page
		CGRect frame = scrollView_.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
		
		[scrollView_ scrollRectToVisible:frame animated:animated];
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		pageControlUsed_ = YES;
		
		[[viewControllers_ objectAtIndex:pageOld] viewWillDisappear:animated];
		[[viewControllers_ objectAtIndex:page] viewWillAppear:animated];
		
		pageControl_.currentPage=page;
	}				
}


// Override to perform custom actions on status changes
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	//Cuando se haya cambiado el tamanio de la vista, redimensionamos su scroll, pagecontrol y controllers
	if ([keyPath isEqual:@"frame"]){
		NSInteger currentPage = pageControl_.currentPage;
		pageControlUsed_=YES;		//Lo marcamos como si se hubiese hecho con pagecontrol directamente para evitar scroll
		
		//Redimensionamos el scroll y pagecontrol
		[pageControl_ setFrame:CGRectMake(0, self.view.frame.size.height-pageControlHeight_, self.view.frame.size.width, pageControlHeight_)];		
		CGRect frame = self.view.frame;
		frame.size.height=frame.size.height-pageControlHeight_;
		[scrollView_ setFrame:frame];
		[scrollView_ setContentSize:CGSizeMake(numberOfPages_*self.view.frame.size.width, frame.size.height)];
		
		//movemos cada viewcontroller ya cargado a su posicion nueva en el scroll
		for (int i=0; i<[viewControllers_ count]; i++){			
			UIViewController *controller = [viewControllers_ objectAtIndex:i];
			if ((NSNull *)controller != [NSNull null]) {			
				controller.view.frame = CGRectMake(scrollView_.frame.size.width*i, 0, scrollView_.frame.size.width, scrollView_.frame.size.height);
			}			
		}
		
		//Recolocamos el contentOffset
		frame = scrollView_.frame;
		frame.origin.x = frame.size.width * currentPage;
		frame.origin.y = 0;		
		[scrollView_ scrollRectToVisible:frame animated:YES];
		
	}
}

@end
