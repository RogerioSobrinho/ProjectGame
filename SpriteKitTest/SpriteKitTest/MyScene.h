//
//  MyScene.h
//  SpriteKitTest
//

//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const UInt32 flappyCategory = 0x1 << 0;
static const UInt32 canosCategory  = 0x1 << 1;
static const UInt32 chaoCategory   = 0x1 << 2;

@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    int fraseOffset;
    double canoTimer;
    bool contouPonto;
}

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property NSArray *flappyFrames;

@property SKSpriteNode *flappy;
@property SKSpriteNode *chao;
@property SKSpriteNode *fundo;

@property SKLabelNode *pontuacao;

@property int pontos;

@property BOOL perdeu;
@property BOOL jogando;

@end