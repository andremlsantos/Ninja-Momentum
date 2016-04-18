#import "MainScene.h"

@implementation MainScene

- (void) play
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level1"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
