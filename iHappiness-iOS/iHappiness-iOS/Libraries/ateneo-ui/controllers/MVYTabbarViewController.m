    //
//  MVYTabbarViewController.m
//  cincodias_iPad
//
//  Created by Angel Garcia Olloqui on 22/07/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "MVYTabbarViewController.h"


@implementation MVYTabbarViewController


@synthesize viewControllers=viewControllers_, selectedViewController=selectedViewController_, selectedIndex=selectedIndex_, delegate=delegate_, containerView=containerView_;


- (void)dealloc {
	selectedViewController_=nil;
	delegate_=nil;
	[containerView_ release]; containerView_=nil;
	[viewControllers_ release]; viewControllers_=nil;
	
	self.containerView=nil;
	
    [super dealloc];
}



#pragma mark Standard methods bypass

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];	
	[selectedViewController_ viewWillAppear:animated];	
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[selectedViewController_ viewDidAppear:animated];	
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[selectedViewController_ viewWillDisappear:animated];
}
- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[selectedViewController_ viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [selectedViewController_ shouldAutorotateToInterfaceOrientation:interfaceOrientation];	
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {	
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[selectedViewController_ willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[selectedViewController_ willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];	
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[selectedViewController_ didRotateFromInterfaceOrientation:fromInterfaceOrientation];	
}
- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[selectedViewController_ willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];	
}
- (void) didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[super didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
	[selectedViewController_ didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];	
}
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
	[selectedViewController_ willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];	
}


#pragma mark Metodos de la clase

- (void) setSelectedViewController:(UIViewController *)vc {
	//Si es el mismo no hacemos nada
	if (vc==selectedViewController_) return;
		
	NSInteger controllerIndex = [viewControllers_ indexOfObject:vc];
	
	//Si no esta en el array de controladores no hacemos nada
	if ((controllerIndex<0) || (controllerIndex>=[viewControllers_ count])) return;
	
	//Comprobamos si el delegado tiene implementado el metodo shouldSelect
	if ([delegate_ respondsToSelector:@selector(tabBarController: shouldSelectViewController:)]){
		if ([delegate_ tabBarController:nil shouldSelectViewController:vc]==NO) return;
	}
	
	//Cambiamos el selected index
	[self willChangeValueForKey:@"selectedIndex"];
	selectedIndex_=controllerIndex;
	[self didChangeValueForKey:@"selectedIndex"];
	
	//Cambiamos el controlador seleccionado
	UIViewController *oldController = selectedViewController_;
	[self willChangeValueForKey:@"selectedViewController"];
	selectedViewController_=vc;
	[self didChangeValueForKey:@"selectedViewController"];

	if ([vc isKindOfClass:[MVYViewController class]]){
		[((MVYViewController *) vc) setCustomNavigationController:self.customNavigationController];
		[((MVYViewController *) vc) setCustomTabBarController:self];
	}
	
	//Notificamos el cambio a los controladores y lo aplicamos en la vista
	[oldController viewWillDisappear:YES];
	[oldController.view removeFromSuperview];
	[oldController viewDidDisappear:YES];
	
	
	[selectedViewController_.view setFrame:CGRectMake(0, 0, containerView_.frame.size.width, containerView_.frame.size.height)];
	[selectedViewController_ viewWillAppear:YES];
	[containerView_ addSubview:selectedViewController_.view];
	[selectedViewController_ viewDidAppear:YES];
	
	//Comprobamos si el delegado tiene implementado el metodo notificacion de cambio
	if ([delegate_ respondsToSelector:@selector(tabBarController: didSelectViewController:)]){
		[delegate_ tabBarController:nil didSelectViewController:vc];
	}	
}

- (void) setSelectedIndex:(NSUInteger)index {
		
	//Si el indice es el mismo no hacemos nada
	if (index==selectedIndex_) return;
	
	//Si el indice no es valido no hacemos nada
	if (index<0 || index>=[viewControllers_ count]) return;
	
	UIViewController *vc = [viewControllers_ objectAtIndex:index];
		
	[self setSelectedViewController:vc];	 
}

- (void)setViewControllers:(NSArray *)viewControllers{
	[self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated{
	//Si es el mismo array no hacemos nada
	if (viewControllers==viewControllers_) return;
	
	//Eliminamos los datos antiguos
	selectedViewController_=nil;
	[viewControllers_ release];
	selectedIndex_=-1;
	
	[self willChangeValueForKey:@"viewControllers"];
	viewControllers_ = [viewControllers retain];
	[self didChangeValueForKey:@"viewControllers"];
	
	//Seleccionamos el primer tab
	[self setSelectedIndex:0];
}




@end
