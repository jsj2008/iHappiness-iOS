//
//  ViewController.m
//  iHappiness-iOS
//
//  Created by Manuel de la Mata Sáez on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[LoginDAO sharedInstance] requestLoginWithUser:@"pedroduran" andPassword:@"rocko#23"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
