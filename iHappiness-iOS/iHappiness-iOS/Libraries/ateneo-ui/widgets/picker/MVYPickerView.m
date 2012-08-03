//
//  MVYPickerView.m
//  LaSexta
//
//  Created by Angel Garcia Olloqui on 04/06/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "MVYPickerView.h"


@interface MVYPickerView (private)

- (void) loadVisibleElements;
- (void) createElements;

- (void) imantar;

@end



@implementation MVYPickerView

@synthesize pickerDelegate=delegate_;
@synthesize padding=padding_;
@synthesize itemViews=itemViews_;
@synthesize itemSelected=itemSelected_;
@synthesize selecItemOnTouch=selecItemOnTouch_;
@synthesize autoselectOnScroll=autoselectOnScroll_;


- (id)initWithFrame:(CGRect)frame{
	if ((self = [super initWithFrame:frame])) {		
        // Initialization code
		padding_=0;
		minInset_=frame.size.width*2;		
		selecItemOnTouch_=YES;
		autoselectOnScroll_=YES;
		
		//Configuramos el scroll donde insertaremos los elementos
		self.delegate=self;
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setContentInset:UIEdgeInsetsMake(0, minInset_*2, 0, minInset_*2)];
		
		//Cambiamos los colores de las vistas insertadas a transparente
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	if (numberOfItems_==0){
		[self createElements];		
	}
	
	[super drawRect:rect];
}


- (void)dealloc {
	[itemViews_ release]; itemViews_=nil;
	[itemPositions_ release]; itemPositions_=nil;
	
    [super dealloc];
}


#pragma mark Metodos de control de pulsaciones
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	
	// If not dragging, process touch for Select an item
	if ((!self.dragging) && (selecItemOnTouch_)){
		UITouch *touch = [touches anyObject];		
		if ([itemViews_ containsObject:touch.view]){
			[self selectItem:[itemViews_ indexOfObject:touch.view]];
		}		
	}
	else{
		[super touchesEnded: touches withEvent: event];
	}	
}

#pragma mark Metodos de la clase

- (void) createElements {
	numberOfItems_ = [delegate_ numberOfItems:self];
	
	//Rellenamos el array de controladores y los agregamos al scroll
	itemViews_ = [[NSMutableArray alloc] init];	
	for (unsigned i = 0; i < numberOfItems_; i++) {		
		UIView *view = [delegate_ viewForItem:i andPickerView:self];		
		[itemViews_ addObject:view];	
		[self addSubview:view];
	}
	
	//Establecemos las posiciones iniciales de cada elemento
	itemPositions_ = [[NSMutableArray alloc] init];
	CGFloat offset = padding_;
	[itemPositions_ addObject:[NSNumber numberWithFloat:offset]];	
	for (UIView *view in itemViews_){						
		view.frame = CGRectMake(offset, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
		offset += view.frame.size.width+padding_;
		[itemPositions_ addObject:[NSNumber numberWithFloat:offset]];	
	}	
	
	//El ancho total es todo el offset menos el ultimo padding que estara repetido con el inicial en la forma circular
	totalWidth_ = offset-padding_;	
}

- (void) loadVisibleElements {
	
	//calculamos cual es el offset haciendo el modulo para quitar vueltas
	NSInteger modOffset = ((int) self.contentOffset.x) % totalWidth_;
	if (modOffset<0) modOffset+=totalWidth_;	
	NSInteger modOffsetEnd = modOffset + self.frame.size.width;
	NSInteger page = self.contentOffset.x / totalWidth_;
	NSInteger pageOffset = page * totalWidth_;
	if (self.contentOffset.x<0) pageOffset-=totalWidth_;
	
	for (unsigned int i = 0; i<[itemPositions_ count]-1; i++){
		CGFloat pos0 = [[itemPositions_ objectAtIndex:i] floatValue];
		CGFloat pos1 = [[itemPositions_ objectAtIndex:i+1] floatValue];
		
		//Comprobamos si el elemento i deberia estar visible
		//	si el inicio esta entre offset y offset + width
		//  o si el final esta entre offset y offset + width
		if (((pos0>=modOffset) && (pos0<modOffsetEnd)) || ((pos1>modOffset) && (pos1<=modOffsetEnd))){ 			
			//Recolocamos el elemento si esta mal colocado
			UIView *view = [itemViews_ objectAtIndex:i];
			if (view.frame.origin.x!=pos0+pageOffset){
				[view setFrame:CGRectMake(pos0+pageOffset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
			}
		}
		//Comprobamos si deberia estar visible en la proxima pagina, y lo movemos
		else if (((pos0+totalWidth_>=modOffset) && (pos0+totalWidth_<modOffsetEnd)) || ((pos1+totalWidth_>modOffset) && (pos1+totalWidth_<=modOffsetEnd))){ 			
			
			//Recolocamos el elemento
			UIView *view = [itemViews_ objectAtIndex:i];
			if (view.frame.origin.x!=pos0+pageOffset+totalWidth_){
				[view setFrame:CGRectMake(pos0+pageOffset+totalWidth_, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];			
			}
		}		
	}
}


- (void) imantar{	
	if (autoselectOnScroll_){
		//calculamos cual es el offset haciendo el modulo para quitar vueltas
		NSInteger modOffset = ((int) self.contentOffset.x) % totalWidth_;
		if (modOffset<0) modOffset+=totalWidth_;	
		
		//Calculamos la posicion central del scroll
		NSInteger modOffsetCenter = ((int) (modOffset + self.frame.size.width/2)) % totalWidth_;	
		NSInteger page = self.contentOffset.x / totalWidth_;
		NSInteger pageOffset = page * totalWidth_;
		if (self.contentOffset.x<0) pageOffset-=totalWidth_;
		
		for (NSInteger i = 0; i<[itemPositions_ count]-1; i++){
			CGFloat pos0 = [[itemPositions_ objectAtIndex:i] floatValue];
			CGFloat pos1 = [[itemPositions_ objectAtIndex:i+1] floatValue];
			
			//Comprobamos si el elemento i contiene el punto en modOffsetCenter
			if ((pos0<=modOffsetCenter) && (pos1>=modOffsetCenter)){ 						
				[self selectItem:i];
			}		
		}	
	}
}

- (void) selectItem:(NSInteger)item{
	if (numberOfItems_==0){
		[self createElements];
	}
	
	if ((item>=numberOfItems_) || (item<0))
		return;
	
	//if ([((NSObject *) delegate_) respondsToSelector:@selector(willChangeItemSelectedTo:)])
		[delegate_ willChangeItemSelectedTo:item andPickerView:self];
	
	//Calculamos cual es el offset haciendo el modulo para quitar vueltas
	NSInteger modOffset = ((int) self.contentOffset.x) % totalWidth_;	
	if (modOffset<0) modOffset+=totalWidth_;	
	NSInteger modOffsetCenter = ((int) (modOffset + self.frame.size.width/2)) % totalWidth_;	
	
	//Miramos si el item esta mas cerca por la izquierda o por la derecha
	CGFloat pos0 = [[itemPositions_ objectAtIndex:item] floatValue];
	CGFloat pos1 = [[itemPositions_ objectAtIndex:item+1] floatValue];
	CGFloat posCenter = pos0+(pos1-pos0)/2;
	
	CGFloat distanceLeft = modOffsetCenter-posCenter;
	if (distanceLeft<0) distanceLeft +=totalWidth_;
	
	CGFloat distanceRight =  posCenter - modOffsetCenter;
	if (distanceRight<0) distanceRight +=totalWidth_;
	
	CGFloat movement=(distanceLeft<distanceRight)? -distanceLeft : distanceRight;
	
	[self setContentOffset:CGPointMake(self.contentOffset.x+movement, self.contentOffset.y) animated:YES];
	
	[self willChangeValueForKey:@"itemSelected"];
	itemSelected_=item;
	[self didChangeValueForKey:@"itemSelected"];
}


#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (numberOfItems_>0){		
		//Regeneramos los insets para que el scroll sea infinito
		CGFloat offset = self.contentOffset.x;
		if (offset<0){			
			if (self.contentInset.left-abs(offset)<minInset_){
				[self setContentInset:UIEdgeInsetsMake(0, -offset+minInset_*2, 0, minInset_*2)];			
			}
		}
		else {
			[self setContentInset:UIEdgeInsetsMake(0, minInset_*2, 0, offset+minInset_*2)];		
		}
		
		
		//Configuramos los elementos visibles
		[self loadVisibleElements];
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



@end