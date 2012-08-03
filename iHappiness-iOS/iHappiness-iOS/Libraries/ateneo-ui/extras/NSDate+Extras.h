//
//  NSDateExtras.h
//  canalcocina_iPad
//
//  Created by Marcos Hernandez Cifuentes on 24/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Extras)

- (NSInteger) getYear;
- (NSInteger) getMonth;
- (NSString*) getMonthLiteral;
- (int) getMonthNumber:(NSString*)literalMonth;
- (NSInteger) getDay;
- (NSInteger) getHour;
- (NSInteger) getMinutes;
- (NSInteger) getSeconds;
- (int) getNumberDate:(NSString*)strDate andFormat:(NSString*)format;

@end