//
//  UIWebViewExtras.m
//  ateneo-ui-poc
//
//  Created by Angel Garcia Olloqui on 06/08/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "UIWebViewExtras.h"


@implementation UIWebView (Extras)

- (NSInteger) scrollHeight{
	return [[self stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
}

- (CGPoint) contentOffset{
	int x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
	int y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
	return CGPointMake(x, y);
}

- (void) setContentOffset:(CGPoint)offset{
	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(%d,%d)", offset.x, offset.y]];	
}

- (UIScrollView *) scrollView{
	NSArray *subviews = [self subviews];
	for (UIView *view in subviews){
		if ([view isKindOfClass:[UIScrollView class]])
			return (UIScrollView *) view;
	}
	return nil;
}

@end
