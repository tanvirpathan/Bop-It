//
//  NSArray+Function.h
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Function)

- (void)makeObjectsPerformBlock:(void (^)(id object))block;

@end
