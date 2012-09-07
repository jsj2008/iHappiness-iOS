//
//  ViewController.h
//  iHappiness-iOS
//
//  Created by Manuel de la Mata Sáez on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashWithLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *userTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *initSesionBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelInitSession;

//IBActions
- (IBAction)initSesionBtnPressed:(id)sender;
- (IBAction)cancelInitSesionBtnPressed:(id)sender;

@end
