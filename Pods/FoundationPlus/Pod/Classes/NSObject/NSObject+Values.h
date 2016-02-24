//
//  NSObject+Values.h
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#define VARIABLE_NAME(arg) (@""#arg)

#import <Foundation/Foundation.h>

@interface NSObject (Values)

+ (instancetype)initializeWithKeyPathsAndValues:(NSDictionary *)valuesDictionary;

// Will deprecate soon
- (NSArray *)propertyList;
- (NSDictionary *)propertyDictionary;

- (NSString *)modelDescription;
- (NSString *)modelDescriptionWithTypes:(BOOL)shouldShowTypes;
- (NSString *)modelDescriptionWithTypes:(BOOL)shouldShowTypes hidingNullValues:(BOOL)shouldHideNullValues;

- (id)valueForSelector:(SEL)selector;
- (id)valueForName:(const void *)name;
- (void)setValue:(id)value forSelector:(SEL)selector;
- (void)setValue:(id)value forName:(const void *)name;

- (void)copyValuesFromObject:(NSObject *)object;
- (void)copyValuesFromObject:(NSObject *)object includingNil:(BOOL)setsNil;

// For primitives, wrap in NSNumber or NSValue
// The selector should be the getter method for properties
// Only use this for properties
- (instancetype)returnAfterSettingValue:(id)value forSelector:(SEL)selector;

@end
