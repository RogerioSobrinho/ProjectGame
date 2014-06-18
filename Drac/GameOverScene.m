//
//  GameOverScene.m
//  Drac
//
//  Created by LUCAS SOTIN PLACHI ANDELOCI on 18/06/14.
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import "GameOverScene.h"


@implementation GameOverScene

-(id)initWithSize:(CGSize)size jogadorPerdeu:(BOOL)Perdeu {
    
    self = [super initWithSize:size];
    
    if(self) {
        
        //Cria fundo
        SKSpriteNode* teladeFundo = [SKSpriteNode spriteNodeWithImageNamed:@"613354.png"];
        teladeFundo.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:teladeFundo];
        
        //Cria a Label para ser a mensagem que aparecera na tela para o usuario
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Comic Sans"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.fontColor = [UIColor blackColor];
        gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height - 100);
        gameOverLabel.text = @"Game Over !";
       [self addChild:gameOverLabel];
        
        
        SKLabelNode *pontuacaoLabel = [SKLabelNode labelNodeWithFontNamed:@"Comic Sans"];
        pontuacaoLabel.fontSize = 32;
        pontuacaoLabel.fontColor = [UIColor blackColor];
        pontuacaoLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [[Pontos pontos]pontuacao];
        pontuacaoLabel.text = [NSString stringWithFormat:@"Pontos: %i", MAX(0, [[Pontos pontos]pontuacao])];
        [self addChild:pontuacaoLabel];

        
    }
    
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Cria a cena de game over
    MyScene *jogarNovamente=[[MyScene alloc]initWithSize:self.size];
    
    //Pede para a MyScene acessar a view e apresentar o Game Over
    [self.view presentScene:jogarNovamente];

}


@end
