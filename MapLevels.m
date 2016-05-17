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
int numberLevels = 30;
int tries[30];

@implementation MapLevels
{
    //BOTOES NIVEIS
    LevelItem *level1;
    LevelItem *level2;
    LevelItem *level3;
    LevelItem *level4;
    LevelItem *level5;
}

//inicializar tentativas ao maximo para nao ter estrelas
- (void)didLoadFromCCB
{
    for(int i=0; i<numberLevels; i++)
    {
        tries[i] = -1;
    }
    
    [level1 setOneStar];
    [level1 setTitle:@"1"];
    
    [level2 setTitle:@"2"];
    [level2 disable];
    
    [level3 setTitle:@"3"];
    [level3 disable];
    
    [level4 setTitle:@"4"];
    [level4 disable];

    [level5 setTitle:@"5"];
    [level5 disable];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *resultURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
}

- (void) update:(CCTime)delta
{
}

@end
