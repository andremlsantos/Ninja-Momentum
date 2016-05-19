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
    self.physicsBody.collisionCategories= @[@"knife"];
    self.physicsBody.collisionMask = @[@"enemy"];
    self.scaleX = 0.29f;
    self.scaleY = 0.29f;
}

- (void) update:(CCTime)delta
{
    self.rotation += 50.0f;
}

@end
