//
//  MVYRotatorViewController.h
//  nieve-prisacom
//
//  Created by Angel Garcia Olloqui on 08/02/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVYRotatorViewControllerDelegate

//Devuelve el numero de paginas
- (NSInteger) numberOfPages;

//Devuelve el tamanio de las paginas (todas deben ser del mismo tamanio)
- (CGSize) sizeOfPages;

//Devuelve el controlador asociado a la pagina
- (UIViewController *)viewControllerForPage:(NSInteger)page;

@end


@interface MVYRotatorViewController : UIViewController<UIScrollViewDelegate> {
	CGRect frame_;
	UIView *cardsView_;
	UIScrollView *scrollView_;

	NSMutableArray *viewControllers_;
	NSMutableArray *imageViews_;
	NSInteger numberOfPages_, pageWidth_, pageHeight_, padding_;
	NSInteger cardSelected_;
	
	id<MVYRotatorViewControllerDelegate> delegate_;
	
	BOOL verticalScroll_;
}
//Establece el delegado
@property (nonatomic, assign) id<MVYRotatorViewControllerDelegate> delegate;

//Define si debe rotar en vertical u horizontal
@property BOOL verticalScroll;

//Permite establecer una separacion entre elementos
@property NSInteger padding;

- (id) initWithFrame:(CGRect)frame;

//Actualiza la imagen de cache del controlador
- (void) redrawImageForViewController:(UIViewController *)viewController;

//Devuelve la posicion del rotador (offset)
- (CGFloat) currentPagePosition;

//Establece la posicion del rotador (offset)
- (void) setPagePosition:(CGFloat)position animated:(BOOL)animated;

//Repinta las fichas suponiendo un offset (mejor no utilizar, ver setPagePosition)
- (void) drawCards:(CGFloat)offset;

@end
