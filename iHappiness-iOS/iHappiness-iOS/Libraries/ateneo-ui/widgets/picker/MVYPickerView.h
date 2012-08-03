//
//  MVYPickerView.h
//  LaSexta
//
//  Created by Angel Garcia Olloqui on 04/06/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVYPickerViewDelegate

- (NSInteger) numberOfItems:(id)mvyPickerView;
- (UIView *)viewForItem:(NSInteger)item andPickerView:(id)mvyPickerView;
- (void) willChangeItemSelectedTo:(NSInteger)item andPickerView:(id)mvyPickerView;

@end


@interface MVYPickerView : UIScrollView<UIScrollViewDelegate> {
	
	BOOL selecItemOnTouch_;
	BOOL autoselectOnScroll_;
	NSMutableArray *itemViews_;
	NSMutableArray *itemPositions_;
	
	NSInteger numberOfItems_, padding_, itemSelected_, totalWidth_, minInset_;
	
	IBOutlet id<MVYPickerViewDelegate> delegate_;
	
}

//Establece el delegado del picker
@property (nonatomic, assign) id<MVYPickerViewDelegate> pickerDelegate;
//Establece una separacion entre elementos. Default = 0
@property NSInteger padding;		
//Establece si el picker debe dejar seleccionar items pulsando sobre ellos ademas de arrastrar el scroll. Default=YES
@property BOOL selecItemOnTouch;
//Establece si el picker debe autoaseleccionar un elemento al hacer scroll (iman). Default=YES
@property BOOL autoselectOnScroll;

//Permite conocer el item seleccionado del picker
@property(readonly) NSInteger itemSelected;

//Permite acceder al array de vistas a modo de consulta
@property (nonatomic, readonly) NSMutableArray *itemViews;


- (void) selectItem:(NSInteger)item;

@end

