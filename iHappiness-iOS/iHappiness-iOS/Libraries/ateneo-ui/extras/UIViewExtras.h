//
//  UIViewExtras.h
//  ABC_iPad
//
//  Created by Angel Garcia Olloqui on 10/03/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (extras) 

//Convierte una vista en una imagen para permitir su manipulacion (devuelve formato bitmap)
- (UIImage *) convertToImage;

//Elimina todas las vistas hijas
- (void) removeSubviews;

//Elimina todos los gestures de la vista
- (void) removeGesturesRecognizers;

@end
