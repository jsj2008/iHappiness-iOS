//
//  UILabelExtras.h
//  ABC_iPad
//
//  Created by Angel Garcia Olloqui on 03/03/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel(Extras)

//Redimensiona verticalmente el label para que se ajuste al texto introducido (ampliandose si fuese necesario)
- (void) resizeHeightToFillText;

//Redimensiona verticalmente el label para que se reduzca en funcion del texto
- (void) resizeHeightToFitText;

//Devuelve el numero de caracteres que caben en 
- (NSInteger) numberOfVisibleCharacters;

//Devuelve el numero de retornos de carro al principio del texto 
- (NSInteger) numeroRetornosCarro;

@end
