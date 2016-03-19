//
//  RainScene.m
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-19.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "RainScene.h"
#import "QuartzCore/QuartzCore.h"
@implementation RainScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //self.backgroundColor = [SKColor clearColor];
        
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Rain" ofType:@"sks"];
        SKEmitterNode *rain = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        rain.position = CGPointMake(self.size.width, self.size.height);

        rain.name = @"particleRain";
        rain.targetNode = self.scene;
        [self addChild:rain];
    }
    return self;
}

@end
