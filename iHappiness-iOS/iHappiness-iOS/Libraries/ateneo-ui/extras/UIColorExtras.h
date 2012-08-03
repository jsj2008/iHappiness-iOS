//
//  UIColorExtras.h
//  As.com-iPad
//
//  Created by Angel Garcia Olloqui on 11/05/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (extras)

//Devuelve un color a partir de su representacion en hexadecimal (estilo web)
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//Devuelve el color en formato texto
- (NSString *) hexStringFromColor;

@end
