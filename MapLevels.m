//
//  MapLevels.m
//  NinjaMomentum
//
//  Created by andre on 16/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "MapLevels.h"
#import <Foundation/Foundation.h>
#import "LevelItem.h"

//TENTATIVAS
int numberLevels = 8;
NSArray *levels;

//templates nomes
NSString * templateTries = @"triesLevel";
NSString * templateEnded = @"endedLevel";
NSString * templateUNBlocked = @"unblockedLevel";

@implementation MapLevels
{
    //BOTOES NIVEIS
    LevelItem *level1;
    LevelItem *level2;
    LevelItem *level3;
    LevelItem *level4;
    LevelItem *level5;
    LevelItem *level6;
    LevelItem *level7;
    LevelItem *level8;
}

//inicializar tentativas ao maximo para nao ter estrelas
- (void)didLoadFromCCB
{
    int index = 1;
    
    levels = [NSArray arrayWithObjects:level1, level2, level3, level4, level5, level6, level7, level8, nil];
    
    //METER NIVEL1 DESBLOQUEADO
    NSString *unbloqued1 = @"YES";
    [[NSUserDefaults standardUserDefaults] setObject:unbloqued1 forKey:@"unblockedLevel1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for(LevelItem * level in levels)
    {
        [self configLevel:level withIndex:index];
        index++;
    }
}

- (void) update:(CCTime)delta
{
}

- (void) _return
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}

- (void) configLevel:(LevelItem*) level withIndex:(int) index
{
    [level setTitle:[NSString stringWithFormat:@"%d", index]];
    
    NSString * unbloquedLevels = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"unbloquedLevels", index]];
    NSString * unbloqued = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"unblockedLevel%d", index]];
    if(unbloqued)
        [level enable];
    else
        [level disable];
    
    NSString * ended = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"endedLevel%d", index]];
    if (ended)
    {
        //ver tries
        CCLOG(@"nivel %d esta acabado", index);
        NSString * triesString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"triesLevel%d", index]];
        
        int triesLevel = [triesString intValue];
        
        CCLOG(@"nivel %d tem %d tries", index, triesLevel);
        
        if(triesLevel == 0)
        {
            [level setThreeStar];
        }
        else if(triesLevel >= 1 && triesLevel <=4)
        {
            [level setTwoStar];
        }
        else if(triesLevel >= 5)
        {
            [level setOneStar];
        }
    }
    else if(unbloquedLevels)
    {
        [level enable];
        [level setZeroStar];
    }
}

@end
