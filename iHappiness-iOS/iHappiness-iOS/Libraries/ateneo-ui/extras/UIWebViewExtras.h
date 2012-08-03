//
//  UIWebViewExtras.h
//  ateneo-ui-poc
//
//  Created by Angel Garcia Olloqui on 06/08/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIWebView (Extras) 

// Devuelve el alto total de la webview
- (NSInteger) scrollHeight;

//Devuelve el contentOffset
- (CGPoint) contentOffset;

//Establece el contentOffset
- (void) setContentOffset:(CGPoint)offset;

//Trata de devolver el scrollview asociado a la webview. Puede no funcionar en versiones futuras porque es un hack
- (UIScrollView *) scrollView;

@end
