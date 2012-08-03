//
//  NSObjectExtras.h
//  sogecable
//
//  Created by Angel Garcia Olloqui on 05/10/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(Extras) 

//Trata de ejecutar un setter con nombre similar al pasado por parametro. Devuelve true si se ha podido, False si no.
- (BOOL) executeSetterLike:(NSString *)name value:(id)value;

@end
