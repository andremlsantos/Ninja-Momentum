#import "MainScene.h"

@implementation MainScene

- (void) play
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level1"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) goToCodex
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"WeaponsCodex"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
