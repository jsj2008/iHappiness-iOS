//
//  ViewController.m
//  iHappiness-iOS
//
//  Created by Manuel de la Mata Sáez on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import "SplashWithLoginViewController.h"
#import "LoginDAO.h"
#import "MVYToast.h"

#define KEYBOARD_OFFSET 180
#define SPLASH_ANIMATION_DURATION 1
#define LOGO_REDUCTION_FACTOR 0.5

@interface SplashWithLoginViewController ()
/**
 Method that configure the interface of the VC
 @author Pedro
 @since 1.0
 */
- (void)configureView;
/**
 Method that configures all the labels in the VC
 @author Pedro
 @since 1.0
 */
- (void)configureLabels;
/**
 Method that init the splash main animation
 @author Pedro
 @since 1.0
 */
- (void)initSplashAnimation;
/**
 Method that add all the notifications needed in the VC
 @author Pedro
 @since 1.0
 */
- (void)addNotifications;
/**
 Method that remove all the notifications needed in the VC
 @author Pedro
 @since 1.0
 */
- (void)removeNotifications;
/**
 Method that init the login complete animation
 @author Pedro
 @since 1.0
 */
- (void)initLoginCompleteAnimation;

/**
 Method called when the LoginService returns an OK notification
 @author Pedro
 @since 1.0
 */
- (void)loginComplete;

/**
 Method called when the LoginService returns an Fail notification
 @author Pedro
 @since 1.0
 */
- (void)loginFail;

/**
 Method called when the Keyboard will show
 @author Pedro
 @since 1.0
 */
- (void)keyboardWillShow;

/**
 Method called when the Keyboard will hide
 @author Pedro
 @since 1.0
 */
- (void)keyboardWillHide;

@end

@implementation SplashWithLoginViewController
@synthesize logoImageView = _logoImageView;
@synthesize activityIndicator = _activityIndicator;
@synthesize loginFieldsView = _loginFieldsView;
@synthesize userTxtFld = _userTxtFld;
@synthesize passwordTxtFld = _passwordTxtFld;
@synthesize startSessionBtn = _initSesionBtn;
@synthesize cancelInitSession = _cancelInitSession;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setUserTxtFld:nil];
    [self setPasswordTxtFld:nil];
    [self setLogoImageView:nil];
    [self setActivityIndicator:nil];
    [self setStartSessionBtn:nil];
    [self setCancelInitSession:nil];
    [self setLoginFieldsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addNotifications];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    
    //Launch the splash animation
    [self  performSelector:@selector(initSplashAnimation) withObject:nil afterDelay:SPLASH_ANIMATION_DURATION];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotifications];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Pubic methods

- (IBAction)initSesionBtnPressed:(id)sender {
    //Disable the initsession button to avoid repeating connections
    [self.startSessionBtn setEnabled:FALSE];
    
    NSString *userName = [self.userTxtFld text];
    NSString *password = [self.passwordTxtFld text];
    
    if ((userName) && [userName length]>0 && (password) && [password length]>0) {
        [self.activityIndicator startAnimating];
        [[LoginDAO sharedInstance] requestLoginWithUser:userName andPassword:password];
    }
    
    //Hide the keyboard
    [self.userTxtFld resignFirstResponder];
    [self.passwordTxtFld resignFirstResponder];
}

- (IBAction)cancelInitSesionBtnPressed:(id)sender {
}

#pragma mark - Private methods

- (void)configureView {
    
    [self.activityIndicator stopAnimating];
    
    //Splash animation initial configuration
    [self.logoImageView setTransform:CGAffineTransformMakeTranslation(0, 100)];
    [self.loginFieldsView setAlpha:0.0];
    [self.loginFieldsView setHidden:NO];
    
    [self configureLabels];
}

- (void)configureLabels {
    
}

- (void)initSplashAnimation {
    
    [UIView animateWithDuration:SPLASH_ANIMATION_DURATION
                     animations:^ {
                         [self.logoImageView setTransform:CGAffineTransformIdentity];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:SPLASH_ANIMATION_DURATION
                                          animations:^ {
                                              [self.loginFieldsView setAlpha:1.0];
                                          }
                          ];
                     }
     ];
}

- (void)addNotifications {
    //Login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete) name:kServiceLoginOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail) name:kServiceLoginFail object:nil];
    
    //Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    //Login
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServiceLoginOK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServiceLoginFail object:nil];
    
    //Keyboard
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)initLoginCompleteAnimation {
    int finalYOffset = self.logoImageView.frame.origin.y + (self.logoImageView.frame.size.height/2*LOGO_REDUCTION_FACTOR);
    
    [UIView animateWithDuration:SPLASH_ANIMATION_DURATION animations:^{
        CGAffineTransform translation = CGAffineTransformMakeTranslation(0, -finalYOffset);
        CGAffineTransform reduction = CGAffineTransformMakeScale(LOGO_REDUCTION_FACTOR, LOGO_REDUCTION_FACTOR);
        [self.logoImageView setTransform:CGAffineTransformConcat(reduction,translation)];
    }];
}

- (void)loginComplete {
    [self.activityIndicator stopAnimating];
    //Enable the initsession button
    [self.startSessionBtn setEnabled:TRUE];
    
    //Show success message
    MVYToast *toast = [[MVYToast alloc] initWithMessage:@"Bienvenido mobiveriano!" andImageName:@"icon-57.png"];
    [toast show];
    
    //Clear the textFields
    [self.userTxtFld setText:@""];
    [self.passwordTxtFld setText:@""];
    
    //Launch the segue to the next viewcontroller
    [self performSelector:@selector(performSegueWithIdentifier:sender:) withObject:@"LoginOk" afterDelay:toast.displayTime];
    
    [self initLoginCompleteAnimation];
}

- (void)loginFail {
    [self.activityIndicator stopAnimating];
    //Enable the initsession button
    [self.startSessionBtn setEnabled:TRUE];
    
    //Show error message
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error en login" 
                                                    message:@"No se ha podido acceder\n Recuerda usar tu nombre de usuario y contraseña de basecamp" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)keyboardWillShow {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0,-KEYBOARD_OFFSET);
        
    }];
}

- (void)keyboardWillHide {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
}

@end
