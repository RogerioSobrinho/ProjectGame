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
//@property SKSpriteNode *chao;


@property NSArray *dragaoFrames;





@end
