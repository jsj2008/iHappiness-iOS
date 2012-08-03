//
//  NSStringExtras.m
//  As.com-iPad
//
//  Created by Angel Garcia Olloqui on 12/05/10.
//  Copyright 2010 Mi Mundo iPhone. All rights reserved.
//

#import "NSStringExtras.h"
#import "GTMNSString+HTML.h"


@implementation NSString (Extras)

- (NSString *) substringBetweenTags:(NSString *)tag0 andTag:(NSString *)tag1 {
	NSRange tokenIni, tokenFin;
	if (tag0)
		tokenIni = [self rangeOfString:tag0 options:NSCaseInsensitiveSearch];
	if (tag1)
		tokenFin = [self rangeOfString:tag1 options:NSCaseInsensitiveSearch];
	
	if (tag0 && tag1 && tokenIni.location!=NSNotFound && tokenFin.location!=NSNotFound){
		NSRange range =NSMakeRange(tokenIni.location+tokenIni.length, tokenFin.location-tokenIni.location-tokenIni.length);
		return [self substringWithRange:range];
	}	
	else if (tokenIni.location!=NSNotFound && tag1==nil){
		return [self substringFromIndex:tokenIni.location+tokenIni.length];		
	}
	else if (tokenFin.location!=NSNotFound && tag0==nil){
		return [self substringToIndex:tokenFin.location+tokenFin.length];		
	}
	
	return nil;
}


- (NSString *)validXMLString
{
    // Not all UTF8 characters are valid XML.
    // See:
    // http://www.w3.org/TR/2000/REC-xml-20001006#NT-Char
    // (Also see: http://cse-mjmcl.cse.bris.ac.uk/blog/2007/02/14/1171465494443.html )
    //
    // The ranges of unicode characters allowed, as specified above, are:
    // Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF] /* any Unicode character, excluding the surrogate blocks, FFFE, and FFFF. */
    //
    // To ensure the string is valid for XML encoding, we therefore need to remove any characters that
    // do not fall within the above ranges.
    
    // First create a character set containing all invalid XML characters.
    // Create this once and leave it in memory so that we can reuse it rather
    // than recreate it every time we need it.
    static NSCharacterSet *invalidXMLCharacterSet = nil;
    
    if (invalidXMLCharacterSet == nil)
    {
        // First, create a character set containing all valid UTF8 characters.
        NSMutableCharacterSet *XMLCharacterSet = [[NSMutableCharacterSet alloc] init];
        [XMLCharacterSet addCharactersInRange:NSMakeRange(0x9, 1)];
        [XMLCharacterSet addCharactersInRange:NSMakeRange(0xA, 1)];
        [XMLCharacterSet addCharactersInRange:NSMakeRange(0xD, 1)];
        [XMLCharacterSet addCharactersInRange:NSMakeRange(0x20, 0xD7FF - 0x20)];
        [XMLCharacterSet addCharactersInRange:NSMakeRange(0xE000, 0xFFFD - 0xE000)];
        [XMLCharacterSet addCharactersInRange:NSMakeRange(0x10000, 0x10FFFF - 0x10000)];
        
        // Then create and retain an inverted set, which will thus contain all invalid XML characters.
        invalidXMLCharacterSet = [[XMLCharacterSet invertedSet] retain];
        [XMLCharacterSet release];
    }
    
    // Are there any invalid characters in this string?
    NSRange range = [self rangeOfCharacterFromSet:invalidXMLCharacterSet];
    
    // If not, just return self unaltered.
    if (range.length == 0)
        return self;
    
    // Otherwise go through and remove any illegal XML characters from a copy of the string.
    NSMutableString *cleanedString = [self mutableCopy];
    
    while (range.length > 0)
    {
        [cleanedString deleteCharactersInRange:range];
        range = [cleanedString rangeOfCharacterFromSet:invalidXMLCharacterSet];
    }
    
    return (NSString *)[cleanedString autorelease];
}

- (NSString *)stringByConvertingHTMLToPlainText {
    
    // Pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Character sets
    NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]; /**/
    
    // Scan and find all tags
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner setCaseSensitive:YES];
    NSString *str = nil, *tagName = nil;
    BOOL dontReplaceTagWithSpace = NO;
    do {
        
        // Scan up to the start of a tag or whitespace
        if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
            [result appendString:str];
            str = nil; // reset
        }
        
        // Check if we've stopped at a tag/comment or whitespace
        if ([scanner scanString:@"<" intoString:NULL]) {
            
            // Stopped at a comment or tag
            if ([scanner scanString:@"!--" intoString:NULL]) {
                
                // Comment
                [scanner scanUpToString:@"-->" intoString:NULL];
                [scanner scanString:@"-->" intoString:NULL];
                
            } else {
                
                // Tag - remove and replace with space unless it's
                // a closing inline tag then dont replace with a space
                if ([scanner scanString:@"/" intoString:NULL]) {
                    
                    // Closing tag - replace with space unless it's inline
                    tagName = nil; dontReplaceTagWithSpace = NO;
                    if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
                        tagName = [tagName lowercaseString];
                        dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
                                                   [tagName isEqualToString:@"b"] ||
                                                   [tagName isEqualToString:@"i"] ||
                                                   [tagName isEqualToString:@"q"] ||
                                                   [tagName isEqualToString:@"span"] ||
                                                   [tagName isEqualToString:@"em"] ||
                                                   [tagName isEqualToString:@"strong"] ||
                                                   [tagName isEqualToString:@"cite"] ||
                                                   [tagName isEqualToString:@"abbr"] ||
                                                   [tagName isEqualToString:@"acronym"] ||
                                                   [tagName isEqualToString:@"label"]);
                    }
                    
                    // Replace tag with string unless it was an inline
                    if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                    
                }
                
                // Scan past tag
                [scanner scanUpToString:@">" intoString:NULL];
                [scanner scanString:@">" intoString:NULL];
                
            }
            
        } else {
            
            // Stopped at whitespace - replace all whitespace and newlines with a space
            if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
            }
            
        }
        
    } while (![scanner isAtEnd]);
    
    // Cleanup
    [scanner release];
    
    // Decode HTML entities and return
    NSString *retString = [[result stringByDecodingHTMLEntities] retain];
    [result release];
    
    // Drain
    [pool drain];
    
    // Return
    return [retString autorelease];
    
}

// Decode all HTML entities using GTM
- (NSString *)stringByDecodingHTMLEntities {
    // gtm_stringByUnescapingFromHTML can return self so create new string ;)
    return [NSString stringWithString:[self gtm_stringByUnescapingFromHTML]];
}

// Encode all HTML entities using GTM
- (NSString *)stringByEncodingHTMLEntities {
    // gtm_stringByUnescapingFromHTML can return self so create new string ;)
    return [NSString stringWithString:[self gtm_stringByEscapingForAsciiHTML]];
}

// Replace newlines with <br /> tags
- (NSString *)stringWithNewLinesAsBRs {
    
    // Pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Strange New lines:
    // Next Line, U+0085
    // Form Feed, U+000C
    // Line Separator, U+2028
    // Paragraph Separator, U+2029
    
    // Scanner
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *temp;
    NSCharacterSet *newLineCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                         [NSString stringWithFormat:@"\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    // Scan
    do {
        
        // Get non new line characters
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        temp = nil;
        
        // Add <br /> s
        if ([scanner scanString:@"\r\n" intoString:nil]) {
            
            // Combine \r\n into just 1 <br />
            [result appendString:@"<br />"];
            
        } else if ([scanner scanCharactersFromSet:newLineCharacters intoString:&temp]) {
            
            // Scan other new line characters and add <br /> s
            if (temp) {
                for (int i = 0; i < temp.length; i++) {
                    [result appendString:@"<br />"];
                }
            }
            
        }
        
    } while (![scanner isAtEnd]);
    
    // Cleanup & return
    [scanner release];
    NSString *retString = [[NSString stringWithString:result] retain];
    [result release];
    
    // Drain
    [pool drain];
    
    // Return
    return [retString autorelease];
    
}

// Remove newlines and white space from strong
- (NSString *)stringByRemovingNewLinesAndWhitespace {
    
    // Pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Strange New lines:
    // Next Line, U+0085
    // Form Feed, U+000C
    // Line Separator, U+2028
    // Paragraph Separator, U+2029
    
    // Scanner
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *temp;
    NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                                      [NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    // Scan
    while (![scanner isAtEnd]) {
        
        // Get non new line or whitespace characters
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // Replace with a space
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@" "];
        }
        
    }
    
    // Cleanup
    [scanner release];
    
    // Return
    NSString *retString = [[NSString stringWithString:result] retain];
    [result release];
    
    // Drain
    [pool drain];
    
    // Return
    return [retString autorelease];
    
}

// Strip HTML tags
// DEPRECIATED - Please use NSString stringByConvertingHTMLToPlainText
- (NSString *)stringByStrippingTags {
    
    // Pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Find first & and short-cut if we can
    NSUInteger ampIndex = [self rangeOfString:@"<" options:NSLiteralSearch].location;
    if (ampIndex == NSNotFound) {
        return [NSString stringWithString:self]; // return copy of string as no tags found
    }
    
    // Scan and find all tags
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableSet *tags = [[NSMutableSet alloc] init];
    NSString *tag;
    do {
        
        // Scan up to <
        tag = nil;
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&tag];
        
        // Add to set
        if (tag) {
            NSString *t = [[NSString alloc] initWithFormat:@"%@>", tag];
            [tags addObject:t];
            [t release];
        }
        
    } while (![scanner isAtEnd]);
    
    // Strings
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    NSString *finalString;
    
    // Replace tags
    NSString *replacement;
    for (NSString *t in tags) {
        
        // Replace tag with space unless it's an inline element
        replacement = @" ";
        if ([t isEqualToString:@"<a>"] ||
            [t isEqualToString:@"</a>"] ||
            [t isEqualToString:@"<span>"] ||
            [t isEqualToString:@"</span>"] ||
            [t isEqualToString:@"<strong>"] ||
            [t isEqualToString:@"</strong>"] ||
            [t isEqualToString:@"<em>"] ||
            [t isEqualToString:@"</em>"]) {
            replacement = @"";
        }
        
        // Replace
        [result replaceOccurrencesOfString:t
                                withString:replacement
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, result.length)];
    }
    
    // Remove multi-spaces and line breaks
    finalString = [[result stringByRemovingNewLinesAndWhitespace] retain];
    
    // Cleanup
    [result release];
    [tags release];
    
    // Drain
    [pool drain];
    
    // Return
    return [finalString autorelease];
    
}

- (NSString *)stringByRemovingControlCharacters{

    NSCharacterSet * charactersToRemove = [[NSCharacterSet characterSetWithCharactersInString:@" {}[]()áéíóúäëïöüÄËÏÖÜÁÉÍÓÚ'\"ñÑ·$%&/=¿?!¡Ç+*<>:;,-_|@#.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSString *trimmedReplacement =[[self componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
    return trimmedReplacement;
}


- (NSString *) stringByConvertingUSDateToESDate{

    //Mon Apr 11 02:17:50 CEST 2011
    self = [self stringByReplacingOccurrencesOfString:@"CEST" withString:@""];
    self = [self stringByReplacingOccurrencesOfString:@"CET" withString:@""];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];
  
    NSLocale *localeUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:localeUS];
    [localeUS release];

    NSDate *dateFromString = [dateFormatter dateFromString:self];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:dateFromString];
    
    return newDateString;
}

- (NSString *) stringByConvertingUSDateToESDateWithHour{
    
    //Mon Apr 11 02:17:50 CEST 2011
    self = [self stringByReplacingOccurrencesOfString:@"CEST" withString:@""];
    self = [self stringByReplacingOccurrencesOfString:@"CET" withString:@""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];
    
    NSLocale *localeUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:localeUS];
    [localeUS release];
    
    NSDate *dateFromString = [dateFormatter dateFromString:self];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *newDateString = [dateFormatter stringFromDate:dateFromString];
    
    return newDateString;
}

@end
