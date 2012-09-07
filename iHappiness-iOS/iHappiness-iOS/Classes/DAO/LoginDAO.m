//
//  LoginDAO.m
//  iHappiness-iOS
//
//  Created by Pedro Durán on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import "LoginDAO.h"
#import "Reachability.h"

#define kPreferenceSessionUserName @"UserName"

@interface  LoginDAO (Private)

- (void)basecampLogin:(NSString *)userName andPassword:(NSString *)password;

//Login responses
- (void)returnLoginOK:(NSData *)data;
- (void)returnLoginError:(NSError *)anError;

@end

@implementation LoginDAO

static LoginDAO* staticLoginDAO_;

@synthesize request = _request;
@synthesize userName = _userName;
@synthesize userLogged = _userLogged;

#pragma mark - Public Methods

+ (LoginDAO*)sharedInstance {
    
    if (staticLoginDAO_ == nil){
        staticLoginDAO_ = [[self alloc] init];
    }
    return staticLoginDAO_;
    
}

- (void)requestLoginWithUser:(NSString*)userName andPassword:(NSString*)password {
    if (BASECAMP_LOGIN) {
        [self basecampLogin:userName andPassword:password];
    }
}

- (BOOL)isUserLogged {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@", [defaults objectForKey:kPreferenceSessionUserName]);
    
    //id cosa =[defaults objectForKey:kPreferenceSessionToken];
    //if UserDefaults has the kPreferenceSessionToken fullfilled it will return YES
	
	if (!self.userName) {
		self.userName = [defaults objectForKey:kPreferenceSessionUserName];
	}
	
    if(self.userName && ![self.userName isEqualToString:@""]){
        return YES;   
    }else{ //Otherwise will send NO
        return NO;
    }
    
}

#pragma mark - Private Methods

- (void)basecampLogin:(NSString *)userName andPassword:(NSString *)password {
    
    //sets the url
    NSString *url = [NSString stringWithFormat:REQUEST_LOGIN_BASECAMP_API_URL];
    if( LOG_REQUESTS ) NSLog(@">>> LoginDAO requestURL: %@",url);
    
    //prepares the connection
    if (self.request == nil) {
		self.request = [[MobiveryRequest alloc] init];
		[self.request setDelegate:self];
	}
    
    NSString *loginString = [NSString stringWithFormat:@"%@:%@", userName, password];
    
    
    
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        //performs the request
        [self.request connect:url withParams:nil withMethods:@"GET" withBodyContent:nil withLogin:loginString withOkSelector:@selector(returnLoginOK:) andKoSelector:@selector(returnLoginError:)];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kServiceLoginFail object:self];
    }
    
}

- (void)returnLoginOK:(NSData *)data {
    
    //obtaining the answer
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if( LOG_RESPONSES ) NSLog(@"<<< LoginDAO Response:%@", dataString);
    
    if ([dataString rangeOfString:@"<account>"].location!=NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kServiceLoginOK object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kServiceLoginFail object:nil];
    }
    
    
}

- (void)returnLoginError:(NSError *)anError {
    
    
    if( LOG_RESPONSES ) NSLog(@"<<< LoginDAO Response ERROR:%@", anError);
    
    //notifies the failure
    [[NSNotificationCenter defaultCenter] postNotificationName:kServiceLoginFail object:nil];
}

@end
