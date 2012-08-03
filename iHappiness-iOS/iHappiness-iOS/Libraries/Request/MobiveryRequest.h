//
//
//  Created by Mario Rosales on 07/06/11.
//  Copyright 2011 mobivery. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MobiveryRequest : NSObject  {
	
	NSURLConnection *mainConnexion_;
	NSMutableData *receivedData;
	NSString *finalDestination;
	NSMutableURLRequest *theRequest;
	NSMutableArray *connectionRedirects;
	NSString *errorRequest;
	
	BOOL inProgress;
        
    SEL okSel;
    SEL koSel;
    
    NSString *method_;
    
    NSString *mainUrl;
    
    id delegate_;

}

@property (nonatomic, assign) SEL okSel;
@property (nonatomic, assign) SEL koSel;

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *finalDestination;
@property (nonatomic, retain) NSMutableURLRequest *theRequest;
@property (nonatomic, retain) NSMutableArray *connectionRedirects;
@property (nonatomic, retain) NSString *errorRequest;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, assign) id delegate;
@property (nonatomic) BOOL inProgress;
@property (nonatomic, retain) NSString *cookie;

+ (MobiveryRequest*) sharedInstance;

- (void) connect:(NSString*)Url withParams:(NSMutableDictionary*) params withMethods:(NSString*)method withOkSelector:(SEL)okSelector andKoSelector:(SEL)koSelector;

- (void) connect:(NSString*)Url withParams:(NSMutableDictionary*)params withMethods:(NSString*)method withBodyContent:(NSString*)bodyContent withLogin:(NSString*)loginString withOkSelector:(SEL)okSelector andKoSelector:(SEL)koSelector;
- (void) connect:(NSString*)Url withJSONParams:(NSString*) params withMethods:(NSString*)method withOkSelector:(SEL)okSelector andKoSelector:(SEL)koSelector;


@end
