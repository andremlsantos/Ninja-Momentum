//
//  Water.m
//  NinjaMomentum
//
//  Created by Hugo on 21/04/16.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "Water.h"

@implementation Water

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"water";
}

@end

