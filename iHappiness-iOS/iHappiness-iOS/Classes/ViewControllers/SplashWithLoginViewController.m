//
//  ViewController.m
//  iHappiness-iOS
//
//  Created by Manuel de la Mata Sáez on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import "SplashWithLoginViewController.h"
#import "LoginDAO.h"

@interface SplashWithLoginViewController ()

@end

@implementation SplashWithLoginViewController
@synthesize logoImageView;
@synthesize userTxtFld;
@synthesize passwordTxtFld;
@synthesize activityIndicator;
@synthesize initSesionBtn;
@synthesize cancelInitSession;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[LoginDAO sharedInstance] requestLoginWithUser:@"pedroduran" andPassword:@"rocko#23"];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)initSesionBtnPressed:(id)sender {
}

- (IBAction)cancelInitSesionBtnPressed:(id)sender {
}
@end
