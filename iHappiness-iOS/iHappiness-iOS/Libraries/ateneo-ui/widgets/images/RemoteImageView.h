//
//  RemoteImageView.h
//  SportRSS
//
//  Created by Angel Garcia Olloqui on 10/03/09.
//  Copyright 2009 Mi Mundo iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemoteImageView : UIImageView {
	NSURLConnection* connection;
    NSMutableData* data;
	NSURL *url_;
	BOOL updating_;
	BOOL appearEfect_;
}
@property BOOL updating;
@property BOOL appearEfect;
@property (nonatomic, assign) NSURL *url_;

- (void)loadImageFromURL:(NSURL*)url loadingImage:(UIImage *)loadingImage;

@end
