//
//  NSArray+Function.m
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "NSArray+Function.h"

@implementation NSArray (Function)

- (void)makeObjectsPerformBlock:(void (^)(id))block
{
    if(!block)return;
    for(id object in self)block(object);
}

@end
