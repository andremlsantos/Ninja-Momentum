//
//  Faca.m
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Knife.h"

@implementation Knife

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"knife";
}

@end
