//
//  SmokeScene.m
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-19.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "SmokeScene.h"
#import "QuartzCore/QuartzCore.h"
@implementation SmokeScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //self.backgroundColor = [SKColor clearColor];
        
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Smoke" ofType:@"sks"];
        SKEmitterNode *smoke = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        smoke.position = CGPointMake(400,20);
        smoke.particleSpeed = 60;
        smoke.name = @"particleSmoke";
        smoke.targetNode = self.scene;
        [self addChild:smoke];
    }
    return self;
}

@end
