//
//  MyScene.h
//  Drac
//
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

static const UInt32 dragaoCategory = 0x1 << 0;
static const UInt32 flechaCategory = 0x1 << 1;
static const UInt32 diamanteCategory = 0x1 << 2;


#import <SpriteKit/SpriteKit.h>
#import "GameOverScene.h"
#import "Pontos.h"

@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    double flechaTimer;
}

@property (nonatomic) NSTimeInterval ultimoSpawnDiamante;
@property (nonatomic) NSTimeInterval ultimoSpawnTimeInterval;
@property (nonatomic) NSTimeInterval ultimoUpdateTimeInterval;

@property SKSpriteNode *flecha;
@property SKSpriteNode *dragao;
@property SKSpriteNode *diamante;
@property SKSpriteNode *coracao1;
@property SKSpriteNode *coracao2;
@property SKSpriteNode *coracao3;

@property int vida;
@property int pontos;
@property SKLabelNode *pontuacao;


@property NSArray *dragaoFrames;





@end
