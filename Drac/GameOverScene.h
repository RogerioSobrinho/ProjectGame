//
//  GameOverScene.h
//  Drac
//
//  Created by LUCAS SOTIN PLACHI ANDELOCI on 18/06/14.
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"
#import "Pontos.h"

static const uint32_t botaoRestartCategory   = 0x1 << 0;
static NSString* botaoCategoryName = @"botaoRestart";

@interface GameOverScene : SKScene

@property SKSpriteNode *botaoRestart;


-(id)initWithSize:(CGSize)size jogadorPerdeu:(BOOL)Perdeu;



@end
