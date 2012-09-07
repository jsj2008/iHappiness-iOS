//
//  MVYToast.m
//  MYVToastExample
//
//  Created by Manuel de la Mata Sáez on 30/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MVYToast.h"

#define VERTICAL_MARGIN 5
#define SIDE_MARGINS 20
#define DEFAULT_DISPLAY_TIME 2
#define DEFAULT_OPACITY 0.7
#define DEFAULT_BACKGROUND_COLOR [UIColor blackColor]
#define DEFAULT_FADE_IN_OUT_TIME 0.3
#define DEFAULT_HEIGHT 40

/** Privated methods of the class **/
@interface MVYToast (private)
-(void)hideToast;
@end

@implementation MVYToast

@synthesize toastImageView;
@synthesize imageString;
@synthesize textLabel;
@synthesize message;
@synthesize toastColor;
@synthesize displayTime;
@synthesize opacity;
@synthesize desiredPosition;

#pragma mark - init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opacity = DEFAULT_OPACITY;
        self.toastColor = DEFAULT_BACKGROUND_COLOR;
        self.displayTime = DEFAULT_DISPLAY_TIME;
        self.message = @"";
    }
    return self;
}

- (id)initWithMessage:(NSString *)stringMessage
{
    return [self initWithMessage:stringMessage forDuration:DEFAULT_DISPLAY_TIME andPosition:MVYToastBottomPosition];
}

- (id)initWithMessage:(NSString *)stringMessage forDuration:(int)time
{
   return [self initWithMessage:stringMessage forDuration:time andPosition:MVYToastBottomPosition];
}

- (id)initWithMessage:(NSString *)stringMessage forDuration:(int)time andPosition:(MVYToastPosition)position
{
    CGRect frame = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] bounds];   
 
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opacity = DEFAULT_OPACITY;
        self.toastColor = DEFAULT_BACKGROUND_COLOR;
        self.displayTime = time;
        self.message = stringMessage;
        self.desiredPosition = position;
        self.imageString = nil;
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(id)initWithMessage:(NSString *)stringMessage andImageName:(NSString *)stringImage{
    
    CGRect frame = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] bounds];   
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opacity = DEFAULT_OPACITY;
        self.toastColor = DEFAULT_BACKGROUND_COLOR;
        self.displayTime = DEFAULT_DISPLAY_TIME;
        self.message = stringMessage;
        self.desiredPosition = MVYToastCenterPosition;
        self.imageString = stringImage;
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}


#pragma mark - draw methods

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code    
    //defines the backgroundView
    //calculates where it will be placed depending on the desiredPosition
    int x;
    int y;
    
    switch (self.desiredPosition) {
        case MVYToastTopPosition:
            x = SIDE_MARGINS;
            y = VERTICAL_MARGIN + 20;
            break;
        case MVYToastCenterPosition:
            x = SIDE_MARGINS;
            y = self.frame.size.height/2 - DEFAULT_HEIGHT;
            break;
        case MVYToastBottomPosition:
            x = SIDE_MARGINS;
            y = self.frame.size.height-VERTICAL_MARGIN- DEFAULT_HEIGHT - 20;
            break;            
        default:
            break;
    }

    
    if(imageString==nil){ //no image
        
        //creates the background view that will have the especified color
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width -(SIDE_MARGINS*2) , DEFAULT_HEIGHT)];
        [backgroundView setBackgroundColor:self.toastColor];
        [backgroundView setAlpha:self.opacity];
        [backgroundView.layer setMasksToBounds:YES];
        [backgroundView.layer setCornerRadius:10.0f];
        [self addSubview:backgroundView];
        
        
        //creates the textLabel
        self.textLabel = [[UILabel alloc] initWithFrame:backgroundView.frame];
        [self.textLabel setText:self.message];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setTextAlignment:UITextAlignmentCenter];
        [self.textLabel setNumberOfLines:0];
        [self addSubview:self.textLabel];
        
        //calculates if it needs to resize the frame of the label and the background view depending on the text length
        UIFont *dataFont = [UIFont fontWithName:@"Helvetica" size:15];
        CGSize maximumSize = CGSizeMake(self.textLabel.frame.size.width , 400);
        CGSize dataStringSize = [self.textLabel.text sizeWithFont:dataFont constrainedToSize:maximumSize lineBreakMode:self.textLabel.lineBreakMode];
        
        //if it's bigger than the default height it will need to resize them
        if(dataStringSize.height > DEFAULT_HEIGHT){
            
            CGRect frame = backgroundView.frame;
            frame.size.height = dataStringSize.height + 50;
            frame.origin.y = self.frame.size.height-VERTICAL_MARGIN- frame.size.height - 20;
            [backgroundView setFrame:frame];    
            [self.textLabel setFrame:frame];
        }
        
    }else{ //with image
        
        int offsetY = 0;
        
        self.toastImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageString]];
        
        //creates the background view that will have the especified color
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width -(SIDE_MARGINS*2) , self.toastImageView.frame.size.height)];
        [backgroundView setBackgroundColor:self.toastColor];
        [backgroundView setAlpha:self.opacity];
        [backgroundView.layer setMasksToBounds:YES];
        [backgroundView.layer setCornerRadius:10.0f];
        [self addSubview:backgroundView];
        
        //sets the position of the toastImageView
        [self.toastImageView setCenter:backgroundView.center]; 
        [self addSubview:self.toastImageView];
        
        offsetY += self.toastImageView.frame.size.height + 5;
        
        //creates the textLabel
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y + offsetY , backgroundView.frame.size.width, DEFAULT_HEIGHT)];
        [self.textLabel setText:self.message];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setTextAlignment:UITextAlignmentCenter];
        [self.textLabel setNumberOfLines:0];
        [self addSubview:self.textLabel];
        
        //calculates if it needs to resize the frame of the label and the background view depending on the text length
        UIFont *dataFont = [UIFont fontWithName:@"Helvetica" size:15];
        CGSize maximumSize = CGSizeMake(self.textLabel.frame.size.width , 400);
        CGSize dataStringSize = [self.textLabel.text sizeWithFont:dataFont constrainedToSize:maximumSize lineBreakMode:self.textLabel.lineBreakMode];
        
        //if it's bigger than the default height it will need to resize them
        if(dataStringSize.height > DEFAULT_HEIGHT){

            int difference = (dataStringSize.height - DEFAULT_HEIGHT)+30;
            CGRect frame = self.textLabel.frame;
            frame.size.height +=  difference;
            [self.textLabel setFrame:frame];

            offsetY += textLabel.frame.size.height;
            
            frame = backgroundView.frame;
            frame.size.height = offsetY;
            [backgroundView setFrame:frame];

            [self.textLabel setTransform:CGAffineTransformMakeTranslation(0, -difference)];
            [self.toastImageView setTransform:CGAffineTransformMakeTranslation(0, -difference)];            
            [backgroundView setTransform:CGAffineTransformMakeTranslation(0, -difference)];
            
        }else{
            
            offsetY += textLabel.frame.size.height;
            
            CGRect frame = backgroundView.frame;
            frame.size.height = offsetY;
            [backgroundView setFrame:frame];
        }
     

        
    }

}

#pragma mark - Public methods


/**
 * Method that shows the toast in the window.
 * @since 1.0 
 */
-(void)show{
        
    //adds to the window
    [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addSubview:self];   
    
    //set the alpha of the toast initially to 0.0f
    [self setAlpha:0.0f];
    [self setUserInteractionEnabled:NO];

    //sets the text to the label
    [self.textLabel setText:self.message];
    
    //inits the animation of fade in
    [UIView animateWithDuration:DEFAULT_FADE_IN_OUT_TIME animations:^{
        [self setAlpha:self.opacity];
        
    }];
    
    //after the duration it will hide the toast
    [self performSelector:@selector(hideToast) withObject:nil afterDelay:self.displayTime];
}

#pragma mark - Privated methods

/**
 * Method that performs the fade out animation and then releases it.
 * @since 1.0 
 */
-(void)hideToast{
    
    [UIView animateWithDuration:DEFAULT_FADE_IN_OUT_TIME animations:^{
        [self setAlpha:0.0f];
        
    }completion:^(BOOL finished){
        if (finished) { //Final
            [self removeFromSuperview];
            //[self release];
        }
    } ];
    
}


@end
