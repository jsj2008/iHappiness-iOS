//
//  NSStringExtras.h
//  As.com-iPad
//
//  Created by Angel Garcia Olloqui on 12/05/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extras)

- (NSString *) substringBetweenTags:(NSString *)tag0 andTag:(NSString *)tag1;
- (NSString *) validXMLString;

- (NSString *) stringByDecodingHTMLEntities;
- (NSString *) stringByEncodingHTMLEntities;
- (NSString *) stringWithNewLinesAsBRs;
- (NSString *) stringByRemovingNewLinesAndWhitespace;
- (NSString *) stringByStrippingTags;
- (NSString *) stringByRemovingControlCharacters;
- (NSString *) stringByConvertingUSDateToESDate;
- (NSString *) stringByConvertingUSDateToESDateWithHour;

@end