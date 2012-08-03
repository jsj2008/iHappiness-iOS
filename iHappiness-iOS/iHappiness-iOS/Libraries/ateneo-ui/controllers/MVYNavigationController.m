    //
//  MVYNavigationController.m
//  ABC_iPad
//
//  Created by Angel Garcia Olloqui on 27/04/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "MVYNavigationController.h"
#import "MVYViewController.h"
#import "UIViewExtras.h"


@implementation MVYNavigationController
@synthesize viewControllers=viewControllers_, contentView=contentView_, navView=navView_;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
	//	pool_ = [[NSAutoreleasePool alloc] init];
		effects_ = [[NSString alloc] init];
		viewControllers_ = [[NSMutableArray alloc] initWithCapacity:1];					
		loaded_=NO;
	}	
	return self;
}

/*
- (void)didReceiveMemoryWarning {	
	[pool_ release];
	pool_ = [[NSAutoreleasePool alloc] init];
}
*/

- (void) viewDidLoad {
	[super viewDidLoad];	
	[self.view setBackgroundColor:[UIColor clearColor]];
	loaded_=YES;
	//Miramos si ya hay controladores por si se ha liberado la vista (viewDidUnload)
	if ([viewControllers_ count]>0){
		UIView *destinationView=(self.contentView? self.contentView : self.view);
		UIViewController *vc = [viewControllers_ lastObject];
		[vc.view setFrame:destinationView.bounds];	
		[destinationView addSubview:vc.view];				
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.contentView=nil;
	self.navView=nil;
}


- (void)dealloc {
	[viewControllers_ release]; viewControllers_=nil;
	[effects_ release]; effects_=nil;
	//[pool_ release]; pool_=nil;
	
	//Vistas
	self.contentView=nil;
	self.navView=nil;

    [super dealloc];
}


#pragma mark Rotate methods bypass

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.view;		//agarcia: Forzamos la generacion de la vista por si ha sido liberada (viewDidUnload)
	[[viewControllers_ lastObject] viewWillAppear:animated];	 
}
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[[viewControllers_ lastObject] viewDidAppear:animated];	 
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[viewControllers_ lastObject] viewWillDisappear:animated];	 
}
- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[[viewControllers_ lastObject] viewDidDisappear:animated];	 
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [[viewControllers_ lastObject] shouldAutorotateToInterfaceOrientation:interfaceOrientation];								
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[[viewControllers_ lastObject] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[[viewControllers_ lastObject] willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];	
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[[viewControllers_ lastObject] didRotateFromInterfaceOrientation:fromInterfaceOrientation];	
}
-(void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[[viewControllers_ lastObject] willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];	
}
-(void) didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[super didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
	[[viewControllers_ lastObject] didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];	
}
-(void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
	[[viewControllers_ lastObject] willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];	
}

- (void) setCustomTabBarController:(MVYTabbarViewController *)tabbar {
	[super setCustomTabBarController:tabbar];
	
	for (UIViewController *vc in viewControllers_){
		if ([vc isKindOfClass:[MVYViewController class]]){
			[((MVYViewController *) vc) setCustomTabBarController:tabbar];
		}				
	}	
}

#pragma mark Push/pop methods and effects


- (void) pushViewController:(UIViewController *)controller {
	[self pushViewController:controller effect:EFFECT_NONE];
}

- (void) pushViewController:(UIViewController *)controller effect:(NSInteger)effect{
	//Si el navbar aun no esta cargado simplemente agregamos el controlador al array de viewcontrollers
	if (!loaded_){		
		if ([controller isKindOfClass:[MVYViewController class]]){
			[((MVYViewController *) controller) setCustomNavigationController:self];
			[((MVYViewController *) controller) setCustomTabBarController:self.customTabBarController];
		}		
		[viewControllers_ addObject:controller];				
	}
	else {
		self.view;		//Forzamos que exista la vista antes de hacer el push
		
		UIViewController *lastVC = [viewControllers_ lastObject];
		lastVC.view;	//Forzamos que exista la vista antes de hacer el push
		[lastVC viewWillDisappear:YES];
		UIView *destinationView=(self.contentView? self.contentView : self.view);
		
		if ([controller isKindOfClass:[MVYViewController class]]){
			[((MVYViewController *) controller) setCustomNavigationController:self];
			[((MVYViewController *) controller) setCustomTabBarController:self.customTabBarController];
		}
		
		[viewControllers_ addObject:controller];
		[controller.view setFrame:destinationView.bounds];	
		
		//Metemos la vista nueva
		if (effect==EFFECT_FADE){
			[destinationView addSubview:controller.view];		
			if (self.view.superview)
				[controller viewWillAppear:YES];				
			controller.view.alpha=0.0;	
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:1];	
			controller.view.alpha=1.0;	
			[UIView commitAnimations];			
			if (self.view.superview){
				[controller performSelector:@selector(viewDidAppear:) withObject:NO afterDelay:1];
				[lastVC performSelector:@selector(viewDidDisappear:) withObject:NO afterDelay:1];
			}
		}	
		else if (effect==EFFECT_FLIP){
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:1];	
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:destinationView cache:YES];		
			[destinationView addSubview:controller.view];		
			[UIView commitAnimations];
			if (self.view.superview){
				[controller viewWillAppear:YES];					
				[controller performSelector:@selector(viewDidAppear:) withObject:NO afterDelay:1];	
				[lastVC performSelector:@selector(viewDidDisappear:) withObject:NO afterDelay:1];
			}
		}
		else if (effect==EFFECT_SCALE){
			NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
			if (self.view.superview)
				[controller viewWillAppear:YES];
			UIImage *image = [controller.view convertToImage];
			UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
			imageView.frame=CGRectMake(destinationView.bounds.size.width/2, destinationView.bounds.size.height/2, 0, 0);
			[destinationView addSubview:imageView];		
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.5];	
			imageView.frame=CGRectMake(0, 0, destinationView.bounds.size.width,destinationView.bounds.size.height);
			[UIView commitAnimations];
			[destinationView performSelector:@selector(addSubview:) withObject:controller.view afterDelay:0.5];		
			[imageView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];		
			if (self.view.superview){
				[controller performSelector:@selector(viewDidAppear:) withObject:NO afterDelay:0.5];
				[lastVC performSelector:@selector(viewDidDisappear:) withObject:NO afterDelay:0.5];
			}
			[imageView release];
			[pool release];
		}
		else {
			[destinationView addSubview:controller.view];		
			if (self.view.superview){
				[controller viewWillAppear:YES];				
				[controller viewDidAppear:YES];			
				[lastVC viewDidDisappear:YES];
			}
		}
	}
	//Actualizamos los efectos acumulados para deshacerlos en el pop
	NSString *effects = [[NSString alloc] initWithFormat:@"%@,%d", effects_, effect];
	[effects_ release]; 
	effects_ = effects;	
}

- (void) popViewController{
	[self popViewController:YES];
}

- (void) popViewController:(BOOL)animated{
	self.view;
	if ([viewControllers_ count]>0){
		UIView *destinationView=(self.contentView? self.contentView : self.view);

		//Obtenemos el efecto y actualizamos la lista
		NSArray *effects = [effects_ componentsSeparatedByString:@","];
		NSInteger effect = [[effects lastObject] intValue];
		effects = [NSMutableArray arrayWithArray:effects];
		[((NSMutableArray *) effects) removeLastObject];
		[effects_ release];
		effects_ =[[effects componentsJoinedByString:@","] retain];
		
		//Quitamos el controlador de la lista
		UIViewController *lastController = (UIViewController *) [[viewControllers_ lastObject] retain];			//Liberado con retardo, 3 segs		
		[viewControllers_ removeLastObject];	
		UIViewController *newVC = [viewControllers_ lastObject];
		if (newVC.view.superview==nil){		//Si no estaba agregada (viewDidUnload) la agregamos
			[newVC.view setFrame:destinationView.bounds];	
			[destinationView addSubview:newVC.view];			
		}
		
		if (self.view.superview){
			[lastController viewWillDisappear:YES];
			[newVC viewWillAppear:YES];	
		}
		
		if (animated==NO) effect=EFFECT_NONE;
		
		if (effect==EFFECT_FADE){		
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:1];	
			lastController.view.alpha=0.0;	
			[UIView commitAnimations];						
			[lastController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];		
			if (self.view.superview){
				[lastController performSelector:@selector(viewDidDisappear:) withObject:nil afterDelay:1];		
				[newVC performSelector:@selector(viewDidAppear:) withObject:nil afterDelay:1];		
			}
		}
		else if (effect==EFFECT_FLIP){
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:1];	
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:destinationView cache:YES];		
			[lastController.view removeFromSuperview];
			[UIView commitAnimations];				
			if (self.view.superview){
				[lastController performSelector:@selector(viewDidDisappear:) withObject:nil afterDelay:1];		
				[newVC performSelector:@selector(viewDidAppear:) withObject:nil afterDelay:1];		
			}
		}
		else if (effect==EFFECT_SCALE){		
			UIImage *image = [lastController.view convertToImage];
			UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
			[destinationView addSubview:imageView];		
			[lastController.view removeFromSuperview];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.5];	
			imageView.frame=CGRectMake(destinationView.bounds.size.width/2,destinationView.bounds.size.height/2, 0, 0);
			[UIView commitAnimations];
			[imageView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];		
			if (self.view.superview){
				[lastController performSelector:@selector(viewDidDisappear:) withObject:nil afterDelay:0.5];		
				[newVC performSelector:@selector(viewDidAppear:) withObject:nil afterDelay:0.5];		
			}
			[imageView release];
		}
		else {
			if (self.view.superview){
				[lastController viewDidDisappear:YES];		
				[newVC viewDidAppear:YES];		
			}
			[lastController.view removeFromSuperview];
		}
		
		[lastController performSelector:@selector(release) withObject:nil afterDelay:3];			//Liberamos 3 seg despues para evitar problemas con efectos
	}
}

- (void) popToRootController {
	//Obtenemos el efecto y actualizamos la lista
	NSArray *effects = [effects_ componentsSeparatedByString:@","];
	effects = [NSMutableArray arrayWithArray:effects];
	
	//Quitamos el controlador de la lista
	while ([viewControllers_ count]>1){
		UIViewController *lastController = (UIViewController *) [viewControllers_ lastObject];
		if (self.view.superview){
			[lastController viewWillDisappear:NO];
			[lastController viewDidDisappear:NO];
		}
		[lastController.view removeFromSuperview];		
		[viewControllers_ removeLastObject];	
		[((NSMutableArray *) effects) removeLastObject];
	}
	UIViewController *newVC = [viewControllers_ lastObject];
	newVC.view;
	if (self.view.superview){
		[newVC viewWillAppear:NO];
		[newVC viewDidAppear:NO];
	}
	[effects_ release];
	effects_ =[[effects componentsJoinedByString:@","] retain];	
}

- (void) animateImageReduce:(UIScrollView *)scrollview{
	UIView *imageView = [scrollview viewWithTag:1];						 
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:PAGE_ANIMATION_DURATION];	
	imageView.frame=CGRectMake(imageView.frame.origin.x+scrollview.frame.size.width*(1.0-PAGE_ANIMATION_SCALE)*0.5, imageView.frame.origin.y+scrollview.frame.size.height*(1.0-PAGE_ANIMATION_SCALE)*0.5, scrollview.frame.size.width*PAGE_ANIMATION_SCALE, scrollview.frame.size.height*PAGE_ANIMATION_SCALE);
	[UIView commitAnimations];				
	
	[self performSelector:@selector(animateScrollMove:) withObject:scrollview afterDelay:PAGE_ANIMATION_DURATION inModes:[NSArray arrayWithObjects:NSRunLoopCommonModes, NSDefaultRunLoopMode, nil]];	
}

- (void) animateScrollMove:(UIScrollView *)scrollview{
	//Miramos si es a izquierdas o derechas
	if ([scrollview viewWithTag:1].frame.origin.x>[scrollview viewWithTag:2].frame.origin.x){
		[scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
	}else {
		[scrollview setContentOffset:CGPointMake(scrollview.frame.size.width, 0) animated:YES];	
	}
	[self performSelector:@selector(animateImageAmplify:) withObject:scrollview afterDelay:PAGE_ANIMATION_DURATION inModes:[NSArray arrayWithObjects:NSRunLoopCommonModes, NSDefaultRunLoopMode, nil]];
}

- (void) animateImageAmplify:(UIScrollView *)scrollview{
	UIView *imageView = [scrollview viewWithTag:2];						 
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:PAGE_ANIMATION_DURATION];	
	imageView.frame=CGRectMake(imageView.frame.origin.x-scrollview.frame.size.width*(1.0-PAGE_ANIMATION_SCALE)*0.5, 0, scrollview.frame.size.width, scrollview.frame.size.height);
	[UIView commitAnimations];					
	[scrollview performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:PAGE_ANIMATION_DURATION inModes:[NSArray arrayWithObjects:NSRunLoopCommonModes, NSDefaultRunLoopMode, nil]];		
}

- (void) generatePageAnimation:(UIImage *)fromImage toImage:(UIImage *)toImage directionLeft:(BOOL)directionLeft{
	UIView *destinationView=(self.contentView? self.contentView : self.view);

	//Creamos las vistas que vamos a manipular para hacer el efecto
	UIImageView *imageFromView = [[UIImageView alloc] initWithImage:fromImage];
	[imageFromView setContentMode:UIViewContentModeScaleAspectFit];
	[imageFromView setTag:1];
	
	UIImageView *imageToView = [[UIImageView alloc] initWithImage:toImage];
	[imageToView setContentMode:UIViewContentModeScaleAspectFit];
	[imageToView setTag:2];
	
	UIScrollView *backgroundScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, destinationView.bounds.size.width,destinationView.bounds.size.height)];	
	[backgroundScroll setBackgroundColor:[UIColor grayColor]];
	[backgroundScroll setUserInteractionEnabled:NO];
	[backgroundScroll setContentSize:CGSizeMake(destinationView.bounds.size.width*2, destinationView.bounds.size.height)];
	
	//Agregamos las imagenes
	if (directionLeft){
		imageFromView.frame=CGRectMake(backgroundScroll.frame.size.width, 0, backgroundScroll.frame.size.width, backgroundScroll.frame.size.height);
		imageToView.frame=CGRectMake(backgroundScroll.frame.size.width*(1.0-PAGE_ANIMATION_SCALE)*0.5, backgroundScroll.frame.size.height*(1.0-PAGE_ANIMATION_SCALE)*0.5, backgroundScroll.frame.size.width*PAGE_ANIMATION_SCALE, backgroundScroll.frame.size.height*PAGE_ANIMATION_SCALE);	
		[backgroundScroll setContentOffset:CGPointMake(backgroundScroll.frame.size.width, 0)];
	} else {
		imageFromView.frame=CGRectMake(0, 0, backgroundScroll.frame.size.width, backgroundScroll.frame.size.height);
		imageToView.frame=CGRectMake(backgroundScroll.frame.size.width+backgroundScroll.frame.size.width*(1.0-PAGE_ANIMATION_SCALE)*0.5, backgroundScroll.frame.size.height*(1.0-PAGE_ANIMATION_SCALE)*0.5, backgroundScroll.frame.size.width*PAGE_ANIMATION_SCALE, backgroundScroll.frame.size.height*PAGE_ANIMATION_SCALE);	
		[backgroundScroll setContentOffset:CGPointMake(0,0)];
	}
	[backgroundScroll addSubview:imageFromView];	
	[backgroundScroll addSubview:imageToView];
	
	[destinationView addSubview:backgroundScroll];
	
	//Lanzamos las animaciones
	[self performSelector:@selector(animateImageReduce:) withObject:backgroundScroll afterDelay:0 inModes:[NSArray arrayWithObjects:NSRunLoopCommonModes, NSDefaultRunLoopMode, nil]];
	
	[backgroundScroll release];
	[imageToView release];
	[imageFromView release];
}



@end
