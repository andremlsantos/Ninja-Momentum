//
//  Enemy.m
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.collisionCategories= @[@"enemy"];
    self.physicsBody.collisionMask = @[@"ground",@"ninja",@"knife",@"platform"];
}

@end
