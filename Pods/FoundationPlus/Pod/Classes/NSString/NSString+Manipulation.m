//
//  NSString+Manipulation.m
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "NSString+Manipulation.h"

@implementation NSString (Manipulation)

- (NSArray *)rangesOfString:(NSString *)searchString
{
    NSMutableArray *ranges = [NSMutableArray new];
    NSRange range = NSMakeRange(0, self.length);
    while(range.location != NSNotFound)
    {
        range = [self rangeOfString:searchString options:0 range:range];
        if(range.location != NSNotFound)
        {
            [ranges addObject:[NSValue valueWithRange:range]];
            range = NSMakeRange(range.location + range.length, self.length - (range.location + range.length));
        }
    }
    return ranges.copy;
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSArray *)splitIntoCharacters
{
    return [self componentsSeparatedByString:@""];
}

- (NSString *)numbersOnlyString{return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet]] componentsJoinedByString:@""];}

@end
