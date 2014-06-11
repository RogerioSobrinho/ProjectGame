//
//  MyScene.h
//  Drac
//
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property SKSpriteNode *dragao;
@property SKSpriteNode *fundo;
@property NSArray *dragaoFrames;

@end
