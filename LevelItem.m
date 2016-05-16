//
//  Leveltem.m
//  NinjaMomentum
//
//  Created by andre on 16/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "LevelItem.h"

@implementation LevelItem
{
    CCNode *star1;
    CCNode *star2;
    CCNode *star3;
    
    CCButton *level_item;
}

- (void) setTitle:(NSString *)title
{
    level_item.title = title;
}

- (void) setZeroStar
{
    star1.opacity = 0.0f;
    star2.opacity = 0.0f;
    star3.opacity = 0.0f;
}

- (void) setOneStar
{
    star1.opacity = 1.0f;
    star2.opacity = 0.0f;
    star3.opacity = 0.0f;
}

- (void) setTwoStar
{
    star1.opacity = 1.0f;
    star2.opacity = 1.0f;
    star3.opacity = 0.0f;
}

- (void) setThreeStar
{
    star1.opacity = 1.0f;
    star2.opacity = 1.0f;
    star3.opacity = 1.0f;
}

- (void) selectLevel
{
    //level 1
    if([level_item.title  isEqual: @"1"])
    {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level1"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
    //level 2
    else if([level_item.title  isEqual: @"2"])
    {
        
    }
    //level 3
    else if([level_item.title  isEqual: @"3"])
    {
        
    }
    //level 4
    else if([level_item.title  isEqual: @"4"])
    {
        
    }
    //level 5
    else if([level_item.title  isEqual: @"5"])
    {
        
    }
    //level 6
    else if([level_item.title  isEqual: @"6"])
    {
        
    }
    //level 7
    else if([level_item.title  isEqual: @"7"])
    {
        
    }
    //level 8
    else if([level_item.title  isEqual: @"8"])
    {
        
    }
    //level 9
    else if([level_item.title  isEqual: @"9"])
    {
        
    }
    //level 10
    else if([level_item.title  isEqual: @"10"])
    {
        
    }
}

- (void) disable
{
    level_item.label.opacity = 0.2;
    level_item.userInteractionEnabled = NO;
    
    [self setZeroStar];
}

- (void) enable
{
    level_item.label.opacity = 1.0;
    level_item.userInteractionEnabled = YES;
}

@end
