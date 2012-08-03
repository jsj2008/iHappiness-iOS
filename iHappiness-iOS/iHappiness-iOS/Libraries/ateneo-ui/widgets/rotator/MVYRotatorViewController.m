//
//  MVYRotatorViewController.m
//  nieve-prisacom
//
//  Created by Angel Garcia Olloqui on 08/02/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "MVYRotatorViewController.h"
#import <QuartzCore/QuartzCore.h>

#define MIN_INSET 1200


@interface  MVYRotatorViewController (private)

- (void)loadScrollViewWithPage:(int)page ;
- (void) drawCards:(CGFloat)page;
- (UIImage *) getImageFromView:(UIView *)view;
- (void) imantar;

@end


@implementation MVYRotatorViewController

@synthesize delegate=delegate_;
@synthesize padding=padding_;
@synthesize verticalScroll=verticalScroll_;


- (id) initWithFrame:(CGRect)frame {

	if (self = [super init]){	
		verticalScroll_=NO;
		padding_=0;
		frame_ = frame;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGSize size = [delegate_ sizeOfPages];
	pageWidth_=size.width;
	pageHeight_=size.height;
	numberOfPages_ = [delegate_ numberOfPages];
	
	self.view.frame=frame_;
	//Creamos la vista donde insertaremos las cartas
	cardsView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:cardsView_];
		
	//Creamos un scroll transparente por encima que nos permitira detectar el scroll y aplicar la animacion de frenado facilmente 
	scrollView_=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	scrollView_.delegate=self;
	[scrollView_ setShowsHorizontalScrollIndicator:NO];
	[scrollView_ setShowsVerticalScrollIndicator:NO];
	if (numberOfPages_>1){
		if (verticalScroll_)
			[scrollView_ setContentInset:UIEdgeInsetsMake(MIN_INSET, 0, MIN_INSET, 0)];
		else
			[scrollView_ setContentInset:UIEdgeInsetsMake(0, MIN_INSET, 0, MIN_INSET)];
	}
	[self.view addSubview:scrollView_];
	
	//Rellenamos el array de controladores
    viewControllers_ = [[NSMutableArray alloc] init];
	imageViews_ = [[NSMutableArray alloc] init];
	
	for (unsigned i = 0; i < numberOfPages_; i++) {
		[viewControllers_ addObject:[NSNull null]];	
		[imageViews_ addObject:[NSNull null]];	
	}
	
	[self drawCards:0.0];
	
	[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];	
}



- (void)dealloc {
	[self.view removeObserver:self forKeyPath:@"frame"];
	
	[cardsView_ release]; cardsView_=nil;
	[scrollView_ setDelegate:nil]; [scrollView_ release]; scrollView_=nil;
	[viewControllers_ release]; viewControllers_=nil;
	[imageViews_ release]; imageViews_=nil;
	delegate_=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
	
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    	
    // Release any cached data, images, etc that aren't in use.
}


- (void) redrawImageForViewController:(UIViewController *)viewController{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	//Obtenemos la posicion de la imagen
	NSInteger pos = [viewControllers_ indexOfObject:viewController];	
	
	//Creamos la nueva imagen del controlador
	BOOL hidden = viewController.view.hidden;
	viewController.view.hidden=NO;
	UIImage *img = [self getImageFromView:viewController.view];
	viewController.view.hidden=hidden;
	
	//Cambiamos la imagen de la vista por la nueva
	UIImageView *imgView = [imageViews_ objectAtIndex:pos];
	[imgView setImage:img];
	
	[pool release];
}



- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= numberOfPages_) return;
	
    // replace the placeholder if necessary
    UIViewController *controller = [viewControllers_ objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
		NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
		
		//Obtenemos el viewcontroller
		controller = [delegate_ viewControllerForPage:page];		
		if (verticalScroll_)
			controller.view.frame=CGRectMake(0, self.view.frame.size.height/2-pageHeight_/2, pageWidth_, pageHeight_);
		else
			controller.view.frame=CGRectMake(self.view.frame.size.width/2-pageWidth_/2, 0, pageWidth_, pageHeight_);
		controller.view.clipsToBounds=YES;
        [viewControllers_ replaceObjectAtIndex:page withObject:controller];
		[controller viewWillAppear:NO];
		[scrollView_ addSubview:controller.view];
		
		//Creamos una image a partir del controlador para poder redimensionar correctamente
		UIImage *view = [self getImageFromView:controller.view];
		UIImageView *img = [[UIImageView alloc] initWithImage:view];
		[img setContentMode:UIViewContentModeScaleAspectFill];
        [imageViews_ replaceObjectAtIndex:page withObject:img];
		[cardsView_ addSubview:img];
		[img release];	
		
		[pool release];
    }	
}


#pragma mark Metodos privados de la clase

- (void) drawCards:(CGFloat)offset {	
	if (numberOfPages_>0){
			
		CGFloat middle = (verticalScroll_?  self.view.frame.size.height/2 : self.view.frame.size.width/2);
		CGFloat desplazamiento = (round(offset)-offset);
		CGFloat angleActive, angleNext, anglePrev;
		
		int activePage = ((int) round(offset)) % numberOfPages_;
		int prevPage=((int) activePage+numberOfPages_+1) % numberOfPages_;
		int nextPage=((int) activePage+numberOfPages_-1) % numberOfPages_;	
		
		//Cargamos los viewcontrollers si no estaban
		[self loadScrollViewWithPage:activePage];
		[self loadScrollViewWithPage:prevPage];
		[self loadScrollViewWithPage:nextPage];
		
		//Si hay 2 elementos
		if (numberOfPages_==2){
			angleActive= (int)(90 + desplazamiento * (180) + 360) % 360 ;
			anglePrev = (int)(270 + desplazamiento * (180) + 360) % 360 ;
			angleNext = anglePrev;
		}
		else {
			angleActive= (int)(90 + desplazamiento * (120) + 360) % 360 ;
			anglePrev = (int)(210 + desplazamiento * (120) + 360) % 360 ;
			angleNext = (int)(330 + desplazamiento * (120) + 360) % 360 ;			
		}
				
		for (UIViewController *vc in viewControllers_)
			if ((NSNull *)vc!=[NSNull null])
				vc.view.hidden=YES;
	
		for (UIImageView *v in imageViews_)
			if ((NSNull *)v!=[NSNull null])
				v.hidden=YES;
		
		CGFloat posX, posY, scale, width, height, halfPage;
		UIView *view;
		
		halfPage=(verticalScroll_? pageHeight_/2 : pageWidth_/2);
		
		//Movemos la pagina anterior		
		scale=(1.0+sin(anglePrev*M_PI/180.0))/4.0+0.5;
		width = pageWidth_*scale;
		height = pageHeight_*scale;
		if (verticalScroll_){
			posX=(pageWidth_-width)/2;
			posY=middle-cos(anglePrev*M_PI/180.0)*(halfPage+padding_)-halfPage+(pageHeight_-height)/2;
		}
		else {
			posX=middle-cos(anglePrev*M_PI/180.0)*(halfPage+padding_)-halfPage+(pageWidth_-width)/2;
			posY=(pageHeight_-height)/2;
		}
		view = [imageViews_ objectAtIndex:prevPage];
		view.hidden=NO;
		view.frame=CGRectMake(posX, posY, width, height);
		if ((anglePrev>330) || (anglePrev<210))
			[cardsView_ bringSubviewToFront:view];

		//Movemos la pagina siguiente
		scale=(1.0+sin(angleNext*M_PI/180.0))/4.0+0.5;
		width = pageWidth_*scale;
		height = pageHeight_*scale;
		if (verticalScroll_){
			posX=(pageWidth_-width)/2;
			posY=middle-cos(angleNext*M_PI/180.0)*(halfPage+padding_)-halfPage+(pageHeight_-height)/2;
		}
		else {
			posX=middle-cos(angleNext*M_PI/180.0)*(halfPage+padding_)-halfPage+(pageWidth_-width)/2;
			posY=(pageHeight_-height)/2;
		}
		view = [imageViews_ objectAtIndex:nextPage];
		view.hidden=NO;
		view.frame=CGRectMake(posX, posY, width, height);
		if ((angleNext>330) || (angleNext<210))
			[cardsView_ bringSubviewToFront:view];
		
		
		//Movemos la pagina actual
		scale=(1.0+sin(angleActive*M_PI/180.0))/4.0+0.5;
		width = pageWidth_*scale;
		height = pageHeight_*scale;
		if (verticalScroll_){
			posX=(pageWidth_-width)/2;
			posY=middle-cos(angleActive*M_PI/180.0)*(halfPage+padding_)-halfPage+(pageHeight_-height)/2;
		}
		else {
			posX=middle-cos(angleActive*M_PI/180.0)*(halfPage+padding_)-halfPage+(pageWidth_-width)/2;
			posY=(pageHeight_-height)/2;
		}
		view = [imageViews_ objectAtIndex:activePage];
		view.hidden=NO;
		view.frame=CGRectMake(posX, posY, width, height);
		[cardsView_ bringSubviewToFront:view];
			
		//Si se ha movido de un controlador previamente seleccionado refrescamos su imagen de cache
		if ((cardSelected_>=0) && (cardSelected_<numberOfPages_)){
			[self redrawImageForViewController:[viewControllers_ objectAtIndex:cardSelected_]];	
			cardSelected_=-1;
		}
		
		//Si la vista esta justo en el centro, damos el cambiazo por el controlador para que capture eventos 
		if (angleActive==90){			
			cardSelected_=activePage;			
			UIView *view = [[viewControllers_ objectAtIndex:activePage] view];
			if (verticalScroll_)
				view.frame=CGRectMake(0, scrollView_.contentOffset.y+self.view.frame.size.height/2-pageHeight_/2, pageWidth_, pageHeight_);
			else
				view.frame=CGRectMake(scrollView_.contentOffset.x+self.view.frame.size.width/2-pageWidth_/2, 0, pageWidth_, pageHeight_);
			view.hidden=NO;
			[scrollView_ bringSubviewToFront:view];
		}
	}
	
}

- (UIImage *) getImageFromView:(UIView *)view{
	UIGraphicsBeginImageContext(view.frame.size);
	
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
	
//	viewImage = [UIImage imageWithData:UIImagePNGRepresentation(viewImage)];
	
	return viewImage;
}

- (void) imantar{
	
	CGFloat offset = (verticalScroll_?  scrollView_.contentOffset.y : scrollView_.contentOffset.x);
	CGFloat size = (verticalScroll_?  scrollView_.frame.size.height : scrollView_.frame.size.width);
	NSInteger page = round(offset/size);
	CGFloat pageOffset = page*size;
	[scrollView_ setContentOffset:(verticalScroll_? CGPointMake(0, pageOffset) : CGPointMake(pageOffset,0)) animated:YES];
	
}

- (CGFloat) currentPagePosition{
	CGFloat pageOffset;
	if (verticalScroll_){
		CGFloat offset = scrollView_.contentOffset.y;
		pageOffset = offset/scrollView_.frame.size.height;
	}
	else {
		CGFloat offset = scrollView_.contentOffset.x;
		pageOffset = offset/scrollView_.frame.size.width;
		
	}
	int page = ((int) floor( pageOffset) % numberOfPages_);
	if (page<0) page+=numberOfPages_;
	pageOffset-=floor(pageOffset);
	return page+pageOffset;	
}

- (void) setPagePosition:(CGFloat)position animated:(BOOL)animated{
	
	//Calculamos la direccion y cantidad de movimiento a aplicar al scroll
	CGFloat currentPosition = [self currentPagePosition];
	CGFloat distanceForward=position-currentPosition;
	if (distanceForward<0) distanceForward+=numberOfPages_;
	CGFloat move = distanceForward;
	if (move>numberOfPages_/2)
		move=-(numberOfPages_-move);
	
	if (verticalScroll_){
		[scrollView_ setContentOffset:CGPointMake(scrollView_.contentOffset.x, scrollView_.contentOffset.y+move*scrollView_.frame.size.height) animated:animated];
	}
	else {
		[scrollView_ setContentOffset:CGPointMake(scrollView_.contentOffset.x+move*scrollView_.frame.size.width, scrollView_.contentOffset.y) animated:animated];		
	}
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (numberOfPages_>1){
		if (verticalScroll_){
			//Regeneramos los insets para que el scroll sea infinito
			CGFloat offset = scrollView_.contentOffset.y;
			[scrollView_ setContentInset:UIEdgeInsetsMake((offset<0)? -offset+MIN_INSET : MIN_INSET, 0, (offset>0)? offset+MIN_INSET : MIN_INSET, 0)];		
							
			[self drawCards:[self currentPagePosition]];	
		}
		else {
			//Regeneramos los insets para que el scroll sea infinito
			CGFloat offset = scrollView_.contentOffset.x;
			[scrollView_ setContentInset:UIEdgeInsetsMake(0, (offset<0)? -offset+MIN_INSET : MIN_INSET, 0,(offset>0)? offset+MIN_INSET : MIN_INSET)];					
			
			[self drawCards:[self currentPagePosition]];	
		}
	}
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{	
	//Si tiene deceleracion lo imantamos cuando pare, si no lo hacemos ahora
	if (decelerate==NO){
		[self imantar];
	}	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViev {	
	 [self imantar];
}



// Override to perform custom actions on status changes
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	//Cuando se haya cambiado el tamanio de la vista, volvemos a calcular las posiciones de los elementos
	if ([keyPath isEqual:@"frame"]){
		[self scrollViewDidScroll:scrollView_];
	}
}
@end
