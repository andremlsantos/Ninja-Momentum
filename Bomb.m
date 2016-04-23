//
//  Bomba.m
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"bomb";
    
    self.scaleX = 0.6f;
    self.scaleY = 0.6f;
}

@end
