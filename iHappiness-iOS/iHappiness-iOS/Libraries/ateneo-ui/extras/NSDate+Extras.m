//
//  NSDateExtras.m
//  canalcocina_iPad
//
//  Created by Marcos Hernandez Cifuentes on 24/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Extras.h"


@implementation NSDate (Extras)

- (NSInteger) getYear{

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:(NSYearCalendarUnit) fromDate:self];  
	[gregorian release];
	return [components year]; 
}

- (NSInteger) getMonth{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:(NSMonthCalendarUnit) fromDate:self];  
	[gregorian release];
	return [components month]; 
}

- (NSString*) getMonthLiteral{
	
	NSArray *literalMonths = [[NSArray alloc] initWithObjects:@"Enero",@"Febrero",@"Marzo",@"Abril",@"Mayo",@"Junio",@"Julio",@"Agosto",@"Septiembre",@"Octubre",@"Noviembre",@"Diciembre",nil];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:(NSMonthCalendarUnit) fromDate:self];  
	[gregorian release];
	
	return [literalMonths objectAtIndex:([components month]-1)];

}

- (int) getMonthNumber:(NSString*)literalMonth{
	
	NSMutableDictionary *literalMonths = [[NSMutableDictionary alloc] init];
	[literalMonths setObject:@"1" forKey:@"Enero"];
	[literalMonths setObject:@"2" forKey:@"Febrero"];
	[literalMonths setObject:@"3" forKey:@"Marzo"];
	[literalMonths setObject:@"4" forKey:@"Abril"];
	[literalMonths setObject:@"5" forKey:@"Mayo"];
	[literalMonths setObject:@"6" forKey:@"Junio"];
	[literalMonths setObject:@"7" forKey:@"Julio"];
	[literalMonths setObject:@"8" forKey:@"Agosto"];
	[literalMonths setObject:@"9" forKey:@"Septiembre"];
	[literalMonths setObject:@"10" forKey:@"Octubre"];
	[literalMonths setObject:@"11" forKey:@"Noviembre"];
	[literalMonths setObject:@"12" forKey:@"Diciembre"];
	return [[literalMonths objectForKey:literalMonth] intValue];
	
}

- (int) getNumberDate:(NSString*)strDate andFormat:(NSString*)format{
	
	NSString *finalStr = [[NSString alloc] initWithFormat:@""];
	NSString *tmp = [[NSString alloc] initWithFormat:@""];

	if ([format isEqualToString:@"dd/mm/yyyy"]) {
		
		NSMutableArray *dateParts = [[NSMutableArray alloc] init];
		[dateParts setArray:[strDate componentsSeparatedByString:@"/"]];
		for (int i = ([dateParts count]-1); i >= 0; i--) {
			
			tmp = [dateParts objectAtIndex:i];
			
			if ([tmp length] < 2) {
				tmp = [NSString stringWithFormat:@"0%@",tmp];
			}

			finalStr = [NSString stringWithFormat:@"%@%@",finalStr,tmp];
		}
	}
	return [finalStr intValue];
}

- (NSInteger) getDay{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:(NSDayCalendarUnit) fromDate:self];  
	[gregorian release];
	return [components day]; 
}

- (NSInteger) getHour{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:( NSHourCalendarUnit) fromDate:self];  
	[gregorian release];
	return [components hour]; 
}

- (NSInteger) getMinutes{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:( NSMinuteCalendarUnit) fromDate:self];  
	[gregorian release];
	return [components minute]; 
}

- (NSInteger) getSeconds{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
	NSDateComponents *components = [gregorian components:( NSSecondCalendarUnit) fromDate:self];  
	[gregorian release];
	return [components second]; 
}

@end
