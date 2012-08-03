//
//  LoginDAO.h
//  iHappiness-iOS
//
//  Created by Pedro Durán on 03/08/12.
//  Copyright (c) 2012 mobivery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobiveryRequest.h"

#define LOG_REQUESTS 1
#define LOG_RESPONSES 1

#define REQUEST_LOGIN_BASECAMP_API_URL @"https://mobivery.basecamphq.com/account.xml"

#define BASECAMP_LOGIN 1
#define kServiceLoginOK @"kServiceLoginOK"
#define kServiceLoginFail @"kServiceLoginKO"

@interface LoginDAO : NSObject

@property(nonatomic,strong) MobiveryRequest *request;
@property(nonatomic,strong) NSString *userName;

+ (LoginDAO*)sharedInstance;
- (void)requestLoginWithUser:(NSString*)userName andPassword:(NSString*)password;
- (void)logout;
- (BOOL)isUserLogged;

@end
