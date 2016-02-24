//
//  NSArray+Allocation.h
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ObjectConstraint)(NSObject *object);

@interface NSArray (Allocation)

+ (NSMutableArray *)arrayOfSize:(NSUInteger)size withCreationBlock:(id (^)(NSUInteger index))creationBlock;
- (NSMutableArray *)arrayWithCreationBlock:(id (^)(id object))creationBlock;

- (NSMutableArray *)subarrayWithObjectsOfClass:(Class)class;
- (NSMutableArray *)subarrayWithObjectsPassingConstraint:(ObjectConstraint)constraintBlock;

- (NSArray *)arrayWithKVCSelector:(SEL)selector;
- (NSArray *)arrayWithValueForKeyPath:(NSString *)keyPath;
// Default value for distinct - NO
- (NSArray *)arrayWithValueForKeyPath:(NSString *)keyPath distinct:(BOOL)valuesAreDistinct;

@end
