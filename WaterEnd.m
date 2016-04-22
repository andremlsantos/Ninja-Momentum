//
//  WaterEnd.m
//  NinjaMomentum
//
//  Created by Hugo on 21/04/16.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "WaterEnd.h"


@implementation WaterEnd

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"waterEnd";
}

@end
