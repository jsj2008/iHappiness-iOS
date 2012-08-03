//
//  UILabelExtras.m
//  ABC_iPad
//
//  Created by Angel Garcia Olloqui on 03/03/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "UILabelExtras.h"


@implementation UILabel(Extras)


//Redimensiona verticalmente el label para que se ajuste al texto intriducido
- (void) resizeHeightToFillText {
	
	if (self.text){
		CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
		
		CGSize expectedLabelSize = [[self text] sizeWithFont:[self font] 
										   constrainedToSize:maximumLabelSize 
											   lineBreakMode:[self lineBreakMode]]; 
		
		//adjust the label the the new height.
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, expectedLabelSize.height)];
		
	}
	else {
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, 0)];	
	}
	
}


- (void) resizeHeightToFitText{	
	if (self.text){
		CGSize expectedLabelSize = [[self text] sizeWithFont:[self font] 
										   constrainedToSize:self.frame.size 
											   lineBreakMode:[self lineBreakMode]]; 
		
		//adjust the label the the new height.
		if (expectedLabelSize.height<self.frame.size.height)
			[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, expectedLabelSize.height)];
	}
	else {
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, 0)];
	}
}



- (NSInteger) numeroRetornosCarro {
	
	NSString *textoLabel = self.text;
	
	int i = 0;
	
	
	for (i = 0 ; i < [textoLabel length] ; i++)
	{
		if(([textoLabel characterAtIndex:i] != 32)&&([textoLabel characterAtIndex:i] != '\n')&&([textoLabel characterAtIndex:i] != '\r'))
			break;
	}
	
	return i;
	
}


//Devuelve el numero de caracteres que caben en 
- (NSInteger) numberOfVisibleCharacters{
	NSInteger visible = [self.text length];
	NSString *originalText = self.text;
	CGRect labelRect = self.frame;
	
	//Comprobamos si el texto cabe completo 
	[self resizeHeightToFillText];
	if (self.frame.size.height  > labelRect.size.height){
		
		//Obtenemos la proporcion en tamanio
		CGFloat proportion = labelRect.size.height / self.frame.size.height - 0.1;
		
		//Metemos un numero de caracteres proporcional al tamanio hasta que se pase
		do {
			proportion += 0.1;
			if (proportion>1) proportion=1.0;			
			self.text=[originalText substringToIndex:([originalText length]*proportion-1)];			
			[self resizeHeightToFillText];
		} while ((self.frame.size.height  <= labelRect.size.height) && (proportion<1.0));
		
		//Quitamos palabras hasta que quepa
		do {
			int pos=[self.text length];
			while (pos>0) {
				pos--;
				unichar c = [self.text characterAtIndex:pos];
				if (c==' ' || c=='\n' || c=='\t')
					break;				
			}
			if (pos>0){
				self.text = [self.text substringToIndex:pos];
				[self resizeHeightToFillText];
			}
			else {
				self.text=@"";
				break;
			}
		} while (self.frame.size.height  > labelRect.size.height);
		
		//Calculamos numero de caracteres visibles
		visible = [self.text length];
	}
	
	self.text=originalText;
	self.frame=labelRect;
	
	return visible;
}

@end
