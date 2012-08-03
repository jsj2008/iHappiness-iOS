//
//  NSObjectExtras.m
//  sogecable
//
//  Created by Angel Garcia Olloqui on 05/10/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "NSObjectExtras.h"


@implementation NSObject(Extras)


- (BOOL) executeSetterLike:(NSString *)name value:(id)value{
	@try {
		
		//Primero se intenta con el nombre directo
		NSMutableString *setter = [[NSString alloc] initWithFormat:@"set%@:",[name capitalizedString]];
		SEL sel = NSSelectorFromString(setter);
		[setter release];	
		if ([self respondsToSelector:sel]){		
			[self performSelector:sel withObject:value];
			return YES;
		}
		
		//Si no funciona, probamos sustituyendo _ por formato con letras capitalizadas
		setter = [[NSMutableString alloc] initWithString:@"set"];
		NSArray *words=[name componentsSeparatedByString:@"_"];
		for (NSString *word in words){
			[setter appendString:[word capitalizedString]];
		}
		[setter appendString:@":"];
		sel = NSSelectorFromString(setter);
		[setter release];	
		if ([self respondsToSelector:sel]){		
			[self performSelector:sel withObject:value];
			return YES;
		}		
	}
	@catch (NSException * e) {		
	}	
	return NO;
}

@end
