//
//  AsynchronousImageView.m
//  instapad
//
//  Created by Mario Rosales Maillo on 09/06/11.
//  Copyright 2011 mobivery. All rights reserved.
//

#define CACHE_BUFFER 300
#define CACHE_DELETE_BUFFER 30

#import "AsynchronousImageView.h"
@interface AsynchronousImageView (Private)

- (void) flushToCache:(NSData*)file;
- (void) checkCacheSize;
- (void) randomRemove:(int)numFilesToRemove;

- (void) fadeIn;

@end

@implementation AsynchronousImageView

@synthesize filename;
@synthesize okCache;
@synthesize deletingFiles;

- (id) initWithFrame:(CGRect)frame{

	[super initWithFrame:frame];
	return self;
}

- (void)loadImageFromURLString:(NSString *)theUrlString andActiveCache:(BOOL)activeCache{
	
    NSLog(@"theUrlString %@",theUrlString);
	self.filename = [theUrlString retain];
	self.okCache = activeCache;
			
	if (!self.okCache) {
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] 
											  cachePolicy:NSURLRequestReturnCacheDataElseLoad 
											  timeoutInterval:30.0];
		
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}else {

		
		NSArray *comp = [self.filename componentsSeparatedByString:@"/"];
		NSString *fName = [NSString stringWithFormat:@"%@",[comp objectAtIndex:([comp count]-1)]];
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *jpgFilePath = [NSString stringWithFormat:@"%@/%@",docDir,fName];
				
		if ([[NSFileManager defaultManager] fileExistsAtPath:jpgFilePath]) {
			@try {
				[self setAlpha:0.0];
				[self performSelector:@selector(fadeIn) withObject:nil afterDelay:0.1];
				self.image = [UIImage imageWithContentsOfFile:jpgFilePath];
			}
			@catch (NSException * e) {
				NSLog(@"%@ %@",[e name], [e reason]);
				
				NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] 
														 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
													 timeoutInterval:30.0];
				
				connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			}
	
		}else {
			
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] 
												  cachePolicy:NSURLRequestReturnCacheDataElseLoad 
												  timeoutInterval:30.0];
			
			connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			
		}
	}
}
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
	
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	
    if (self.image ) 
		self.image  = nil;
	
	[self setAlpha:0.0];
	[self performSelector:@selector(fadeIn) withObject:nil afterDelay:0.1];
	self.image = [UIImage imageWithData:data];
	if (self.okCache) {
		[self flushToCache:data];
	}else {
		[data release], data = nil;
		[connection release], connection = nil;
	}
	
	[pool release];
}

-(void) flushToCache:(NSData*)file{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	
		NSArray *comp = [self.filename componentsSeparatedByString:@"/"];
		NSString *fName = [NSString stringWithFormat:@"%@",[comp objectAtIndex:([comp count]-1)]];
		
		UIImage *image = [[UIImage alloc] initWithData:file];	
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *jpgFilePath = [NSString stringWithFormat:@"%@/%@",docDir,fName];
		NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
		[data1 writeToFile:jpgFilePath atomically:YES];
		[image release];
		[data release], data = nil;
		[connection release], connection = nil;
		if (!self.deletingFiles) {
			
			[self checkCacheSize];
		}
		
	[pool release];
}

-(void) randomRemove:(int)numFilesToRemove{
	
	self.deletingFiles = TRUE;
		
	NSFileManager *fManager = [NSFileManager defaultManager];

	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSArray *origContents = [fManager contentsOfDirectoryAtPath:docDir error:nil];
	
	NSString *jpgFilePath;
	NSMutableDictionary *filesToRemove = [[NSMutableDictionary alloc] init];

	for (int i =  0; i< origContents.count; i++) {
		jpgFilePath = [NSString stringWithFormat:@"%@/%@",docDir,[origContents objectAtIndex:i]];
		NSDictionary *attributes =[fManager attributesOfItemAtPath:jpgFilePath error:nil];
		[filesToRemove setObject:jpgFilePath forKey:[NSString stringWithFormat:@"%@%@",[attributes objectForKey:@"NSFileSystemFileNumber"],[origContents objectAtIndex:i]]];
	}
	
	NSArray *allKeys = [filesToRemove allKeys];
	NSArray *sortedArray = [allKeys sortedArrayUsingSelector:@selector(compare:)];
		
	for (int i = 0; i < numFilesToRemove; i++) {
		jpgFilePath = [NSString stringWithFormat:@"%@",[filesToRemove objectForKey:[sortedArray objectAtIndex:i]]];
		if ([fManager fileExistsAtPath:jpgFilePath]){
			[fManager removeItemAtPath:jpgFilePath error:nil];
		}
	}
	deletingFiles = FALSE;
	[filesToRemove release];
}

-(void) checkCacheSize{

	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSArray *origContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDir error:nil];
	if (origContents.count > CACHE_BUFFER) {
		int j = (origContents.count - CACHE_BUFFER) + CACHE_DELETE_BUFFER;
		[self randomRemove:j];
	}
}

- (void) fadeIn{
    
    [UIView animateWithDuration:0.3 animations:^{
    [self setAlpha:1.0];
    }];
}

- (void) dealloc{

	[connection release]; connection = nil;
	[data release]; data = nil;
	//self.filename = nil;
    [super dealloc];

}
@end
