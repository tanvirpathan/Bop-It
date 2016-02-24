//
//  NSString+Manipulation.h
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Manipulation)

// Search
- (NSArray *)rangesOfString:(NSString *)string;

// NSURL
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)stringByStrippingHTML;

// Formatting
- (NSArray *)splitIntoCharacters;
- (NSString *)numbersOnlyString;

@end
