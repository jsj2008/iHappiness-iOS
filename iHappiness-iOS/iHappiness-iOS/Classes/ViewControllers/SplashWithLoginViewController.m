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
@synthesize userTxtFld = _userTxtFld;
@synthesize passwordTxtFld = _passwordTxtFld;
@synthesize activityIndicator = _activityIndicator;
@synthesize initSesionBtn = _initSesionBtn;
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
    [self setInitSesionBtn:nil];
    [self setCancelInitSession:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Pubic methods

- (IBAction)initSesionBtnPressed:(id)sender {
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
    [self.navigationController setNavigationBarHidden:TRUE];
    
    [self.activityIndicator stopAnimating];
    
    [self configureLabels];
}

- (void)configureLabels {
    
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

- (void)loginComplete {
    [self.activityIndicator stopAnimating];
    
    //Show success message
    MVYToast *toast = [[MVYToast alloc] initWithMessage:@"Bienvenido mobiveriano!" andImageName:@"icon-57.png"];
    [toast show];
    
    //Launch the segue to the next viewcontroller
    [self performSelector:@selector(performSegueWithIdentifier:sender:) withObject:@"LoginOk" afterDelay:toast.displayTime];
}

- (void)loginFail {
    [self.activityIndicator stopAnimating];
    
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
