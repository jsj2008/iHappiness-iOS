//
//
//  Created by Mario Rosales on 07/06/11.
//  Copyright 2011 mobivery. All rights reserved.
//

#import "MobiveryRequest.h"
#import "NSStringExtras.h"

#define TIME_OUT_INTERVAL 11.0

@interface  MobiveryRequest (Private)
-(NSString *)encode:(NSData *)plainText;
@end



@implementation MobiveryRequest

@synthesize receivedData;
@synthesize finalDestination;
@synthesize theRequest;
@synthesize connectionRedirects;
@synthesize inProgress;
@synthesize errorRequest;
@synthesize delegate = delegate_;
@synthesize okSel, koSel;
@synthesize method = method_;
@synthesize cookie = _cookie;

static MobiveryRequest* staticMobiveryRequest_;


+ (MobiveryRequest*) sharedInstance {
    
    if (staticMobiveryRequest_ == nil)
    {
        staticMobiveryRequest_ = [[self alloc] init];
    }
    
    return staticMobiveryRequest_;
}

- (void) connect:(NSString*)Url withParams:(NSMutableDictionary*) params withMethods:(NSString*)method withOkSelector:(SEL)okSelector andKoSelector:(SEL)koSelector{
	
    //NSLog(@"Url %@",Url);
    
    mainUrl = [[NSString alloc] initWithFormat:@"%@",Url];
    
    self.inProgress = TRUE;
    self.method = [method uppercaseString];
	receivedData = [NSMutableData alloc];
	connectionRedirects = [[NSMutableArray alloc] init];
	finalDestination = [NSString stringWithFormat:@""];
    theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setHTTPShouldHandleCookies:TRUE];
    [theRequest setHTTPMethod:self.method];
    
    //NSLog(@"self.cookie %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"]);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] isEqualToString:@""]) {
        [theRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] forHTTPHeaderField:@"Set-Cookie"];
    }

    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    okSel = okSelector;
    koSel = koSelector;

    NSMutableString *paramString=[NSMutableString stringWithFormat:@""];

	if ([params count]>0){
		//Establecemos los parametros
		NSEnumerator *enumerator = [params keyEnumerator];
		id key;
		while ((key = [enumerator nextObject])) {
			[paramString appendFormat:@"%@=%@&", key, [params objectForKey:key]];
		}
		NSRange range;
		range.length=1;
		range.location=[paramString length]-1;
		[paramString deleteCharactersInRange:range];
        
    }
    

    if ([self.method isEqualToString:@"POST"]) {
            
        theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]
                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
										   timeoutInterval:TIME_OUT_INTERVAL];
            
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];

    } else if ([self.method isEqualToString:@"GET"]) {
            
        NSString *tmpUrl;
        if (![paramString isEqualToString:@""]) {
            tmpUrl = [NSString stringWithFormat:@"%@?%@",Url,paramString];
        }else{
            tmpUrl = [NSString stringWithFormat:@"%@",Url];
        }
        
        theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:tmpUrl]
                                        cachePolicy:NSURLRequestReloadIgnoringCacheData
                                        timeoutInterval:TIME_OUT_INTERVAL];
            
        [theRequest setHTTPMethod:@"GET"];
        
        }
		//[paramString release];

	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if (theConnection) {
		receivedData = [[NSMutableData data] retain];
		
	} else {
		NSLog(@"Connection failed! Error");
		self.inProgress = FALSE;
	}

}

- (void) connect:(NSString*)Url withJSONParams:(NSString*) params withMethods:(NSString*)method withOkSelector:(SEL)okSelector andKoSelector:(SEL)koSelector{
	
    //NSLog(@"Url %@",Url);
    
    mainUrl = [[NSString alloc] initWithFormat:@"%@",Url];
    
    self.inProgress = TRUE;
    self.method = [method uppercaseString];
	receivedData = [NSMutableData alloc];
	connectionRedirects = [[NSMutableArray alloc] init];
	finalDestination = [NSString stringWithFormat:@""];
    theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setHTTPShouldHandleCookies:TRUE];
    [theRequest setHTTPMethod:self.method];
    
    //NSLog(@"self.cookie %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"]);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] isEqualToString:@""]) {
        [theRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] forHTTPHeaderField:@"Set-Cookie"];
    }
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    okSel = okSelector;
    koSel = koSelector;
    
    NSMutableString *paramString=[[NSMutableString alloc] initWithString: params];
    
    
    
    if ([self.method isEqualToString:@"POST"]) {
        
        theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]
                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       timeoutInterval:TIME_OUT_INTERVAL];
        
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];

    } else if ([self.method isEqualToString:@"GET"]) {
        
        NSString *tmpUrl;
        if (![paramString isEqualToString:@""]) {
            tmpUrl = [NSString stringWithFormat:@"%@?%@",Url,paramString];
        }else{
            tmpUrl = [NSString stringWithFormat:@"%@",Url];
        }
        
        theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:tmpUrl]
                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       timeoutInterval:TIME_OUT_INTERVAL];
        
        [theRequest setHTTPMethod:@"GET"];
        
    }
    //[paramString release];
    
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
	if (theConnection) {
		receivedData = [[NSMutableData data] retain];
		
	} else {
		NSLog(@"Connection failed! Error");
		self.inProgress = FALSE;
	}
    
}


- (void) connect:(NSString*)Url withParams:(NSMutableDictionary*)params withMethods:(NSString*)method withBodyContent:(NSString*)bodyContent withLogin:(NSString*)loginString withOkSelector:(SEL)okSelector andKoSelector:(SEL)koSelector {
	
    mainUrl = [[NSString alloc] initWithFormat:@"%@",Url];
    
    self.inProgress = TRUE;
    self.method = [method uppercaseString];
	receivedData = [NSMutableData alloc];
	connectionRedirects = [[NSMutableArray alloc] init];
	finalDestination = [NSString stringWithFormat:@""];
    theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setHTTPShouldHandleCookies:TRUE];
    [theRequest setHTTPMethod:self.method];
    
    NSLog(@"self.cookie %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"]);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] isEqualToString:@""]) {
        [theRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"] forHTTPHeaderField:@"Set-Cookie"];
    }
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    okSel = okSelector;
    koSel = koSelector;
    
    NSMutableString *paramString=[NSMutableString stringWithFormat:@""];
    
	if ([params count]>0){
		//Establecemos los parametros
		NSEnumerator *enumerator = [params keyEnumerator];
		id key;
		while ((key = [enumerator nextObject])) {
			[paramString appendFormat:@"%@=%@&", key, [params objectForKey:key]];
		}
		NSRange range;
		range.length=1;
		range.location=[paramString length]-1;
		[paramString deleteCharactersInRange:range];
        
    }
    
    NSString *encodedLoginData = [self encode:[loginString dataUsingEncoding:NSUTF8StringEncoding]];  
    
    // create the contents of the header   
    NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData];
//    NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", loginString];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]
                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                   timeoutInterval:TIME_OUT_INTERVAL];     
    
    // add the header to the request.  Here's the $$$!!!  
    [theRequest addValue:authHeader forHTTPHeaderField:@"Authorization"];
    
//    [theRequest addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
//    [theRequest addValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    if ([self.method isEqualToString:@"POST"]) {
        
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
        
    } else if ([self.method isEqualToString:@"GET"]) {
        
        NSString *tmpUrl;
        if (![paramString isEqualToString:@""]) {
            tmpUrl = [NSString stringWithFormat:@"%@?%@",Url,paramString];
        }else{
            tmpUrl = [NSString stringWithFormat:@"%@",Url];
        }
        
        [theRequest setHTTPMethod:@"GET"];
        
    }
    //[paramString release];
    
    if (bodyContent) {
        [paramString appendString:bodyContent];
        [theRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
	if (theConnection) {
		receivedData = [[NSMutableData data] retain];
		
	} else {
		NSLog(@"Connection failed! Error");
		self.inProgress = FALSE;
	}
    
        
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
		
    [receivedData setLength:0];
    
    NSDictionary *dictionary = [[NSDictionary alloc] init];
        
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	if ([response respondsToSelector:@selector(allHeaderFields)]) {
		dictionary = [httpResponse allHeaderFields];
	}
    
    
    for (id key in [dictionary allKeys]){
        NSString *tmp = [NSString stringWithFormat:@" %@",[dictionary objectForKey:key]];
        if ([key isEqualToString:@"Set-Cookie"]) {
            if ([dictionary objectForKey:key] && ![[dictionary objectForKey:key] isEqualToString:@""]) {
                if ([tmp rangeOfString:@"JSESSIONID"].location != NSNotFound) {
                    //NSLog(@"seteamos la cookie %@",[[NSMutableString alloc] initWithString:[dictionary objectForKey:key]]);
                    [[NSUserDefaults standardUserDefaults] setValue:[[NSMutableString alloc] initWithString:[dictionary objectForKey:key]] forKey:@"cookie"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
    self.inProgress = FALSE;
	self.errorRequest = [NSString stringWithFormat:@"%@",error];
    
    if (delegate_ && koSel) {
        [delegate_ performSelector:koSel withObject:nil];
    }
    
	[connection release];
    [receivedData release];	
}

- (NSURLRequest *)connection: (NSURLConnection *)inConnection willSendRequest: (NSURLRequest *)inRequest redirectResponse: (NSURLResponse *)inRedirectResponse{

    NSDictionary *dictionary = [[NSDictionary alloc] init];
    

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)inRedirectResponse;
	if ([inRedirectResponse respondsToSelector:@selector(allHeaderFields)]) {
		dictionary = [httpResponse allHeaderFields];
	}
        
    for (id key in [dictionary allKeys]){
        NSString *tmp = [NSString stringWithFormat:@" %@",[dictionary objectForKey:key]];
        if ([key isEqualToString:@"Set-Cookie"]) {
            if ([dictionary objectForKey:key] && ![[dictionary objectForKey:key] isEqualToString:@""]) {
                if ([tmp rangeOfString:@"JSESSIONID"].location != NSNotFound) {
                    //NSLog(@"seteamos la cookie %@",[[NSMutableString alloc] initWithString:[dictionary objectForKey:key]]);
                    [[NSUserDefaults standardUserDefaults] setValue:[[NSMutableString alloc] initWithString:[dictionary objectForKey:key]] forKey:@"cookie"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }
       
    if (([mainUrl rangeOfString:@"desconectar?cm-forced-device-type"].location == NSNotFound) && [dictionary valueForKey:@"X-Oi-Login"]) {
        NSLog(@"logout dictionary %@",dictionary);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SBJSONresultadoNull" object:nil];
    }

	NSString *redirect = [NSString stringWithFormat:@"%@",[inRequest URL]];
	[connectionRedirects addObject:redirect];
	return inRequest;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

	self.inProgress = FALSE;
	self.finalDestination = [connectionRedirects lastObject];
    
    NSLog(@"Url: %@",connection.currentRequest.URL);
    
    if (delegate_ && okSel) {
        [delegate_ performSelector:okSel withObject:receivedData];
    }
    
    [connection release];
	
}

-(void) dealloc{
	self.receivedData = nil;
    self.finalDestination = nil;
    self.theRequest = nil;
    self.connectionRedirects = nil;
    self.errorRequest = nil;
    self.delegate = nil;
    self.koSel = nil;
    self.okSel = nil;
    self.method = nil;
    self.cookie = nil;
    [mainUrl release];
    [super dealloc];
}


//BASE64 encode
-(NSString *)encode:(NSData *)plainText {  
    static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    int encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;  
    unsigned char *outputBuffer = malloc(encodedLength);  
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];  
    
    NSInteger i;  
    NSInteger j = 0;  
    int remain;  
    
    for(i = 0; i < [plainText length]; i += 3) {  
        remain = [plainText length] - i;  
        
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];  
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |   
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];  
        
        if(remain > 1)  
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)  
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];  
        else   
            outputBuffer[j++] = '=';  
        
        if(remain > 2)  
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];  
        else  
            outputBuffer[j++] = '=';              
    }  
    
    outputBuffer[j] = 0;  
    
    NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];  
    free(outputBuffer);  
    
    return result;  
} 
                
@end
