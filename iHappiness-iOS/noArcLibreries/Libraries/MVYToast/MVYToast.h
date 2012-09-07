//
//  MVYToast.h
//  MYVToastExample
//
//  Created by Manuel de la Mata Saez on 30/05/12.
//  Copyright (c) 2012 Mobivery. All rights reserved.
//
//
//  It's mandatory to include: #import <QuartzCore/QuartzCore.h> 
//
//  Example of use MYVToastExample:
//  
//
//      MVYToast *toast = [[MVYToast alloc] initWithMessage:@"Test"];
//      [toast show];
//  
//
//      MVYToast *toast = [[MVYToast alloc] initWithMessage:@"Test" forDuration:2];
//      [toast show];
//  
//
//      MVYToast *toast = [[MVYToast alloc] initWithMessage:@"Test" forDuration:2 andPosition:MVYToastCenterPosition];
//      [toast show];
//  
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/** typedef to specifie the position of the toast **/
typedef enum {
    MVYToastTopPosition = 1,
    MVYToastCenterPosition = 2,
    MVYToastBottomPosition = 3,
} MVYToastPosition;


/** class that shows a Toast like the Android feature SDK **/
@interface MVYToast : UIView

@property (nonatomic,retain) UIImageView *toastImageView;            /** addtional image **/
@property (nonatomic,retain) NSString *imageString;             /** name for the image **/
@property (nonatomic,retain) UILabel *textLabel;                /** UILabel for the message **/
@property (nonatomic,retain) NSString *message;                 /** message that will be shown **/
@property (nonatomic,retain) UIColor *toastColor;               /** toast background color **/
@property (nonatomic,assign) int displayTime;                   /** time of exposition of the toast **/
@property (nonatomic,assign) float opacity;                     /** alpha wich is going to be displayed the toast **/
@property (nonatomic,assign) MVYToastPosition desiredPosition;  /** position where it will be displayed the toast **/


/**
 * Init method specifing only the message to show.
 * @param stringMessage string to be shown in the toast.
 * @since 1.0
 */
-(id)initWithMessage:(NSString*)stringMessage;

/**
 * Init method specifing the message and the time that will be shown.
 * @param stringMessage string to be shown in the toast.
 * @param time integer that specifies the display duration.
 * @since 1.0
 */
-(id)initWithMessage:(NSString*)stringMessage forDuration:(int)time;

/**
 * Init method specifing the message and the time that will be shown.
 * @param stringMessage string to be shown in the toast.
 * @param time integer that specifies the display duration.
 * @param position MVYToastPosition that specifies where it's going to be displayed.
 * @since 1.0 
 */
-(id)initWithMessage:(NSString*)stringMessage forDuration:(int)time andPosition:(MVYToastPosition)position;

/**
 * Init method specifing only the message to show.
 * @param stringMessage string to be shown in the toast.
 * @param imageString string with the name of the image to show.
 * @since 1.0
 */
-(id)initWithMessage:(NSString*)stringMessage andImageName:(NSString*)stringImage;


/**
 * Method that shows the toast in the window.
 * @since 1.0 
 */
-(void)show;

@end
