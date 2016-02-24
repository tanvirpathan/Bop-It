//
//  NSObject+Values.m
//  Pods
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Values.h"

static int paddingLevel = 0;

@implementation NSObject (Values)

+ (instancetype)initializeWithKeyPathsAndValues:(NSDictionary *)valuesDictionary
{
    id object = (typeof(self))[self new];
    
    for(NSString *keyPath in valuesDictionary.allKeys)
    {
        if([object respondsToSelector:NSSelectorFromString(keyPath)])
        {
            [(NSObject *)object setValue:valuesDictionary[keyPath] forKeyPath:keyPath];
        }
    }
    
    return (id)object;
}

- (id)objectTag
{
    return [self valueForSelector:@selector(objectTag)];
}

- (void)setObjectTag:(id)objectTag
{
    [self setValue:objectTag forSelector:@selector(objectTag)];
}

- (NSString *)paddingString
{
    return [[NSString new] stringByPaddingToLength:paddingLevel * 4
                                        withString:@" "
                                   startingAtIndex:0];
}

- (void)appendLogString:(NSString *)logString toString:(NSMutableString *)currentString
{
    [currentString appendFormat:@"%@%@", [self paddingString], logString];
}

- (NSString *)typeDescriptionForProperty:(objc_property_t)property
{
    NSArray *attributes = [[[NSString alloc] initWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","];
    
    NSString *typeDescription = attributes.firstObject;
    if(typeDescription.length < 1)return @"";
    
    NSString *type = nil;
    char typeCharacter = [typeDescription characterAtIndex:1];
    switch(typeCharacter)
    {
        case '@':
        {
            NSString *typeName = [[typeDescription stringByReplacingOccurrencesOfString:@"\"" withString:@""] componentsSeparatedByString:@"@"].lastObject;
            if(!typeName.length)type = @"id";
            else if([typeName characterAtIndex:0] == '?')type = @"block";
            else type = [NSString stringWithFormat:@"%@ *", typeName];
            break;
        }
        case 'i':
        {
            type = @"int";
            break;
        }
        case 'f':
        {
            type = @"float";
            break;
        }
        case 'd':
        {
            type = @"double";
            break;
        }
        case 'B':
        {
            type = @"bool";
            break;
        }
        case 'c':
        {
            // TODO - 'c' is used for both char and BOOL, but BOOL is more common. Consider using bool ('B') for debugging purposes.
            type = @"BOOL";
            //type = @"char";
            break;
        }
        case 'l':
        {
            type = @"long";
            break;
        }
        case 's':
        {
            type = @"short";
            break;
        }
        case 'I':
        {
            type = @"unsigned";
            break;
        }
        case '^':
        {
            if([typeDescription characterAtIndex:2] != '?')return @"";
            type = @"block";
            break;
        }
        case '{':
        {
            type = [[typeDescription componentsSeparatedByString:@"{"].lastObject componentsSeparatedByString:@"="].firstObject;
            break;
        }
            
        default: return @"";
    }
    
    return [NSString stringWithFormat:@" (%@)", type];
}

- (NSString *)modelDescription
{
    return [self modelDescriptionWithTypes:NO];
}

- (NSArray *)propertyList
{
    u_int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:propertyCount];
    for(int i = 0; i < propertyCount; i++)
    {
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(properties[i])];
        [propertyArray addObject:propertyName];
    }
    free(properties);
    
    return propertyArray;
}

- (NSDictionary *)propertyDictionary
{
    NSArray *propertyList = [self propertyList];
    NSMutableDictionary *propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:propertyList.count];
    for(NSString *propertyName in propertyList)
    {
        if([self respondsToSelector:@selector(selector)])
        {
            propertyDictionary[propertyName] = ([self valueForKeyPath:propertyName] ? : [NSNull null]);
        }
    }
    return propertyDictionary.copy;
}

- (NSString *)modelDescriptionWithTypes:(BOOL)shouldShowTypes
{
    return [self modelDescriptionWithTypes:shouldShowTypes hidingNullValues:NO];
}

- (NSString *)modelDescriptionWithTypes:(BOOL)shouldShowTypes hidingNullValues:(BOOL)shouldHideNullValues
{
    NSMutableString *descriptionString = [NSMutableString new];
    
    if([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *selfDictionary = (NSDictionary *)self;
        
        if(selfDictionary.count)
        {
            [descriptionString appendString:@"\n"];
            [self appendLogString:@"{\n" toString:descriptionString];
            paddingLevel++;
            
            for(NSString *key in [selfDictionary allKeys])
            {
                id value = selfDictionary[key];
                [self appendLogString:[NSString stringWithFormat:@"%@ : %@\n", key, ([value respondsToSelector:@selector(modelDescription)] ? [value modelDescriptionWithTypes:shouldShowTypes hidingNullValues:shouldHideNullValues] : value)]
                             toString:descriptionString];
            }
            
            paddingLevel--;
            [self appendLogString:@"}" toString:descriptionString];
        }
        else [descriptionString appendString:@"{}"];
    }
    
    else if([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]])
    {
        NSArray *selfArray = (NSArray *)self;
        
        if(selfArray.count)
        {
            [descriptionString appendString:@"\n"];
            [self appendLogString:@"[\n" toString:descriptionString];
            paddingLevel++;
            
            for(id value in selfArray)
            {
                [self appendLogString:[NSString stringWithFormat:@"%@\n", ([value respondsToSelector:@selector(modelDescription)] ? [value modelDescriptionWithTypes:shouldShowTypes hidingNullValues:shouldHideNullValues] : value)]
                             toString:descriptionString];
            }
            
            paddingLevel--;
            [self appendLogString:@"]" toString:descriptionString];
        }
        else [descriptionString appendString:@"[]"];
    }
    
    else
    {
        //if(!paddingLevel)[descriptionString appendString:@"\n"];
        [descriptionString appendString:self.description];
        
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        if(propertyCount)
        {
            [descriptionString appendString:@"\n"];
            [self appendLogString:@"{\n" toString:descriptionString];
            paddingLevel++;
            for(int i = 0; i < propertyCount; i++)
            {
                NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(properties[i])];
                NSString *type = (shouldShowTypes ? [self typeDescriptionForProperty:properties[i]] : @"");
                @try
                {
                    id value = [self valueForKey:propertyName];
                    if(value || !shouldHideNullValues)[self appendLogString:[NSString stringWithFormat:@"%@%@ : %@\n", propertyName, type, ([value respondsToSelector:@selector(modelDescription)] ? [value modelDescriptionWithTypes:shouldShowTypes hidingNullValues:shouldHideNullValues] : value)]
                                                                   toString:descriptionString];
                }
                @catch (NSException *exception)
                {
                    NSLog(@"Error getting '%@' from '%@'", propertyName, self.description);
                    NSLog(@"%@", exception.description);
                    [self appendLogString:[NSString stringWithFormat:@"%@ : <%@>\n", propertyName, exception.name] toString:descriptionString];
                }
            }
            paddingLevel--;
            [descriptionString appendString:@"\n"];
            [self appendLogString:@"}" toString:descriptionString];
        }
        free(properties);
    }
    
    return descriptionString;
}

- (id)valueForSelector:(SEL)selector
{
    return [self valueForName:selector];
}

- (id)valueForName:(const void *)name
{
    return objc_getAssociatedObject(self, name);
}

- (void)setValue:(id)value forSelector:(SEL)selector
{
    [self setValue:value forName:selector];
}

- (void)setValue:(id)value forName:(const void *)name
{
    objc_setAssociatedObject(self, name, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)copyValuesFromObject:(NSObject *)object
{
    [self copyValuesFromObject:object includingNil:YES];
}

- (void)copyValuesFromObject:(NSObject *)object includingNil:(BOOL)setsNil
{
    if(![self isKindOfClass:object.class])
    {
        NSLog(@"Error: Trying to copy %@ to %@", NSStringFromClass(object.class), NSStringFromClass(self.class));
        return;
    }
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    if(propertyCount)
    {
        for(int i = 0; i < propertyCount; i++)
        {
            NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(properties[i])];
            @try
            {
                id value = [object valueForKey:propertyName];
                if(value || setsNil)
                {
                    if([value conformsToProtocol:@protocol(NSCopying)])value = [value copy];
                    [self setValue:value forKeyPath:propertyName];
                }
            }
            @catch (NSException *exception)
            {
                NSLog(@"Could not set '%@' from '%@'", propertyName, object.description);
                NSLog(@"%@", exception.description);
            }
        }
    }
    free(properties);
}

- (instancetype)returnAfterSettingValue:(id)value forSelector:(SEL)selector
{
    @try
    {
        [self setValue:value forKey:NSStringFromSelector(selector)];
    }
    @catch(NSException *exception)
    {
        NSLog(@"Failed to set %@ on %@", NSStringFromSelector(selector), NSStringFromClass([self class]));
    }
    @finally
    {
        return self;
    }
}

@end
