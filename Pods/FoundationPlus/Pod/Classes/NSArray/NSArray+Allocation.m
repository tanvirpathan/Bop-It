//
//  NSArray+Allocation.m
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "NSArray+Allocation.h"

@implementation NSArray (Allocation)

+ (NSMutableArray *)arrayOfSize:(NSUInteger)size withCreationBlock:(id (^)(NSUInteger))creationBlock
{
    if(!creationBlock)return nil;
    
    NSMutableArray *newArray = [NSMutableArray new];
    for(NSUInteger index = 0; index < size; index++)
    {
        [newArray addObject:creationBlock(index)];
    }
    return newArray;
}

- (NSArray *)arrayWithCreationBlock:(id (^)(id object))creationBlock
{
    if(!creationBlock)return nil;
    
    NSMutableArray *newArray = [NSMutableArray new];
    for(id object in self)
    {
        [newArray addObject:creationBlock(object)];
    }
    return newArray;
}

- (NSMutableArray *)subarrayWithObjectsOfClass:(Class)class
{
    return [self subarrayWithObjectsPassingConstraint:^BOOL(NSObject *object)
            {
                return ([object isKindOfClass:class]);
            }];
}

- (NSMutableArray *)subarrayWithObjectsPassingConstraint:(ObjectConstraint)constraintBlock
{
    if(!constraintBlock)return nil;
    NSMutableArray *newArray = [NSMutableArray new];
    for(NSObject *object in self)
    {
        if(constraintBlock(object))
        {
            [newArray addObject:object];
        }
    }
    return newArray;
}

// Same method
- (NSArray *)arrayWithKVCSelector:(SEL)selector{return [self arrayWithValueForKeyPath:NSStringFromSelector(selector)];}
- (NSArray *)arrayWithValueForKeyPath:(NSString *)keyPath{return [self arrayWithValueForKeyPath:keyPath distinct:NO];}
- (NSArray *)arrayWithValueForKeyPath:(NSString *)keyPath distinct:(BOOL)valuesAreDistinct
{
    return [self valueForKeyPath:[NSString stringWithFormat:@"@%@.%@", (valuesAreDistinct ? @"distinctUnionOfObjects" : @"unionOfObjects"), keyPath]];
}

@end
