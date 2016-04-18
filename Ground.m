//
//  Ground.m
//  NinjaMomentum
//
//  Created by andre on 10/04/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Ground.h"

@implementation Ground

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"ground";
}

@end
