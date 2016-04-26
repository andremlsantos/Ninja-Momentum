//
//  Ninja.h
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Ninja : CCSprite

typedef enum ninjaActions
{
    IDDLE,
    JUMP,
    KNIFE,
    BOMB,
    /*
    WATER,          // TIRAR
    JUMPONWATER,*/    // TIRAR
    GRAPPLING,
} ninjaActions;

/*
 PROPRIEDADES
 */
@property int action;
@property bool canJump;
@property bool initialJump;

/*
 FORCAS
 */
@property float jumpForce;
@property float verticalJumpForce;
@property float waterJumpForce;

@property float knifeForce;
@property float waterForce;

/*
 ACOES
 */
- (void) action:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY;

- (void) jump:(float)angleX withAngleY:(float)angleY;
- (void) verticalJump;

- (void) shootKnife:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY;
- (void) shootBomb:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY;

/*
- (void) pushNinjaInWater:(CCPhysicsNode *)physicsWorld;
- (void) jumpInWater:(float)angleX withAngleY:(float)angleY withPower:(float) maxPower;
*/
- (bool) canShoot;


/* 
 MIRA
 */
- (void) initAim:(CCPhysicsNode *)physicsWorld;
- (void) positionAimAt:(CGPoint) point;
- (void) updateAim:(float)rotation withScale:(float)scale;
- (void) enableAim:(BOOL) value;
//- (void) resetAim;


@end
