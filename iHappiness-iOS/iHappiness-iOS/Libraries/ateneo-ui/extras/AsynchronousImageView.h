//
//  AsynchronousImageView.h
//  instapad
//
//  Created by Mario Rosales Maillo on 09/06/11.
//  Copyright 2011 mobivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AsynchronousImageView : UIImageView 
{
    NSURLConnection *connection;
    NSMutableData *data;
	
	BOOL okCache;
	BOOL deletingFiles;
	NSString *filename;
	
}

@property (nonatomic) BOOL okCache;
@property (nonatomic) BOOL deletingFiles;
@property (nonatomic, retain) NSString* filename;

- (void)loadImageFromURLString:(NSString *)theUrlString andActiveCache:(BOOL)activeCache;
- (id) initWithFrame:(CGRect)frame;

@end