//
//  RemoteImageView.m
//  SportRSS
//
//  Created by Angel Garcia Olloqui on 10/03/09.
//  Copyright 2009 Mi Mundo iPhone. All rights reserved.
//

#import "RemoteImageView.h"
#import "UIImageExtras.h"

@interface RemoteImageView (Private)

- (NSString *) getImageName:(NSURL *)url;
- (NSData *) getCachedImage:(NSURL *)url;
- (void) setCachedImage:(NSData *)data url:(NSURL *)url; 

@end
	
	
@implementation RemoteImageView

@synthesize updating=updating_;
@synthesize appearEfect=appearEfect_;
@synthesize url_;


- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self!=nil){
		updating_=NO;
		appearEfect_=YES;
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (id) initWithImage:(UIImage *)image {
	self = [super initWithImage:image];
	if (self!=nil){
		updating_=NO;
		appearEfect_=YES;
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (id) init {
	self = [super init];
	if (self!=nil){
		updating_=NO;
		appearEfect_=YES;
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void)loadImageFromURL:(NSURL*)url loadingImage:(UIImage *)loadingImage {
	//Borramos si existiese conexiones anteriroes
	[connection release]; connection=nil;
	[data release]; data=nil;

	[self setImage:loadingImage];
	
	//Si se ha especificado una URL
	if (url!=nil){
		
		//Cargamos la imagen de la cache
		NSData *imageCache = [self getCachedImage:url];
		
		//NSData *imageCache = nil;
		//Si no hay imagen en la cache y no se esta ya actualizando, la pedimos
		if ((imageCache==nil) && ((!self.updating) || (![url_ isEqual:url]))){			
			[url_ release];
			url_=[url retain];
			self.updating=YES;
			
			//Lanzamos la nueva conexion
			NSURLRequest* request = [NSURLRequest requestWithURL:url
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:5.0];
			 
			connection = [[NSURLConnection alloc]
						  initWithRequest:request delegate:[self retain]];			
		}
		//Si habia imagen, la cargamos
		else{
			self.updating=NO;
			UIImage *image=[UIImage imageWithData:imageCache];
			[self setImage:image];		
		}
	}
}

//Convierte una url en un hash para almacenar en la cache						
- (NSString *) getImageName:(NSURL *)url{
	return [NSString stringWithFormat:@"%U",[[url absoluteString] hash]];
}


//Devuelve la imagen de la cache, o nil si no existe
- (NSData *) getCachedImage:(NSURL *)url{
	NSString *imageName = [self getImageName:url];
	
	NSString *filePath=[NSTemporaryDirectory() stringByAppendingString:imageName];
	
	//Si no hay imagen en cache, devolvemos nil
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
		return nil;
	
	return [[NSFileManager defaultManager] contentsAtPath:filePath];
}


//Actualiza la imagen en la cache
- (void) setCachedImage:(NSData *)imageData url:(NSURL *)url{
	NSString *imageName = [self getImageName:url];
	
	NSString *filePath=[NSTemporaryDirectory() stringByAppendingString:imageName];
	
	[[NSFileManager defaultManager] createFileAtPath:filePath contents:imageData attributes:nil];	
}



- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
	if (appearEfect_){
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.15];
		[self setAlpha: 0.0]; 
		[UIView commitAnimations]; 

		[self performSelector:@selector(loadThumbnail:) withObject:theConnection afterDelay: 0.15];
	}
	else {
		[self performSelector:@selector(loadThumbnail:) withObject:theConnection afterDelay: 0];
	}
	
}

- (void) loadThumbnail:(NSURLConnection*)theConnection {
  [connection release]; connection=nil;

	UIImage *image = [UIImage imageWithData:data];
	//Si la imagen es mas grande que la WebView
	
	if ((image.size.width>self.frame.size.width) || (image.size.height>self.frame.size.height)){
		//Reescalamos la imagen al tamaño de la webview
//		image=[image imageByScalingProportionallyToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
		
		//Guardamos la imagen reescalada 
		//[self setCachedImage:UIImageJPEGRepresentation(image, 1.0) url:url_];
//		[self setCachedImage:UIImagePNGRepresentation(image) url:url_];		//agarcia: Se hace en PNG para mantener las transparencias
		[self setCachedImage:data url:url_];
	}
	else {
		//Guardamos la imagen original
		[self setCachedImage:data url:url_];			
	}
	
	//Establecemos la imagen dentro de la imageView
	[self setImage:image];
	
	//Pintamos de nuevo la vista
    [self setNeedsLayout];
	
	//Liberamos los datos
    [data release];
    data=nil;
	
	//Creamos una animacion
	[self performSelector:@selector(showThumbnail) withObject: nil afterDelay: 0.0];	

	self.updating=NO;	
}	


- (void) showThumbnail {
	if (appearEfect_){
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.75];
	}
	[self setAlpha: 1.0]; 
	[UIView commitAnimations];  
	
	[self release];
}


- (void)dealloc {
    [connection cancel]; 
    [connection release]; connection=nil;
    [data release]; data=nil;
	[url_ release];
    [super dealloc];
}


@end
