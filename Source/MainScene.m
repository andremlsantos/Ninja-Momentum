#import "MainScene.h"

@implementation MainScene

OALSimpleAudio *audio;

// default config
- (void)didLoadFromCCB
{
    // access audio object
    audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"main_menu.mp3" loop:YES];
    [audio preloadEffect:@"slow_motion.mp3"];
    [audio preloadEffect:@"throw_knife.wav"];
    [audio preloadEffect:@"knife_stab.mp3"];


    NSString* dateString;
    dateString = @"";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    dateString = [dateString stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]];
    dateString = [dateString stringByAppendingString:@".txt"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:dateString];
    NSString *rootFile = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"currentLog.txt"];
    
    NSString *temp = @"Log for this session";
    [temp writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [filePath writeToFile:rootFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void) play
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MapLevels"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) reset
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (void) unblock
{
    NSString *unbloquedLevels = @"YES";
    [[NSUserDefaults standardUserDefaults] setObject:unbloquedLevels forKey:@"unbloquedLevels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) goToCodex
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"WeaponsCodex"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) goToLater
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/LevelTest"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) options
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Options"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) credits
{
        
}

/*
 NIVEIS
 */


@end
