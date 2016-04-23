//
//  WeaponsCodex.m
//  NinjaMomentum
//
//  Created by Gonçalo Delgado on 23/04/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "WeaponsCodex.h"

@implementation WeaponsCodex
-(void) ninjato {
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/NinjatoEntry"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void) granade {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GranadeEntry"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}
-(void) gHook {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/HookEntry"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}
-(void) kunai {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CodexEntries/KunaiEntry"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}
@end
