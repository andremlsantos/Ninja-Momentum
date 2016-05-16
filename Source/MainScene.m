#import "MainScene.h"

@implementation MainScene

- (void) play
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MapLevels"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) goToCodex
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"WeaponsCodex"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
- (void) goToLater
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/LevelLater"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


/*
 NIVEIS
 */


@end
