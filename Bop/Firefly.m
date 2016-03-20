//
//  Firefly.m
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-19.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "Firefly.h"
#import "QuartzCore/QuartzCore.h"
@implementation Firefly

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //self.backgroundColor = [SKColor clearColor];
        
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Firefly" ofType:@"sks"];
        SKEmitterNode *firefly = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        firefly.position = CGPointMake(200, -100);
        
        firefly.name = @"particleRain";
        firefly.targetNode = self.scene;
        [self addChild:firefly];
    }
    return self;
}
@end
