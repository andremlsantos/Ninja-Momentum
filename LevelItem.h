//
//  Leveltem.h
//  NinjaMomentum
//
//  Created by andre on 16/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface LevelItem : CCNode

- (void) setTitle:(NSString *)title;

- (void) setZeroStar;
- (void) setOneStar;
- (void) setTwoStar;
- (void) setThreeStar;

- (void) disable;
- (void) enable;

@end
