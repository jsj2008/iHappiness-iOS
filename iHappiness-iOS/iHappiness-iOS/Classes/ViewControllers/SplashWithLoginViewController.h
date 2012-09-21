//
//  ViewController.h
//  iHappiness-iOS
//
//  Created by Manuel de la Mata Sáez on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashWithLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIView *loginFieldsView;
@property (strong, nonatomic) IBOutlet UITextField *userTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (strong, nonatomic) IBOutlet UIButton *startSessionBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelInitSession;

//IBActions
/**
 Method called when the user press the button of init sesion
 @author Pedro
 @since 1.0
 */
- (IBAction)initSesionBtnPressed:(id)sender;
/**
 Method called when???
 @author Pedro
 @since 1.0
 */
- (IBAction)cancelInitSesionBtnPressed:(id)sender;

@end
