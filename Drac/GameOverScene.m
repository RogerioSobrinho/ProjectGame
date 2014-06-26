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
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.fontColor = [UIColor blackColor];
        gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height - 100);
        gameOverLabel.text = @"Game Over !";
       [self addChild:gameOverLabel];
        
        //Cria a pontuacao do jogo
        SKLabelNode *pontuacaoLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        pontuacaoLabel.fontSize = 32;
        pontuacaoLabel.fontColor = [UIColor blackColor];
        pontuacaoLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [[Pontos pontos]pontuacao];
        pontuacaoLabel.text = [NSString stringWithFormat:@"Pontos: %i", MAX(0, [[Pontos pontos]pontuacao])];
        [self addChild:pontuacaoLabel];
        
        //Botao Restart
        self.botaoRestart = [SKSpriteNode spriteNodeWithImageNamed:@"btnres.png"];
        self.botaoRestart.position = CGPointMake(self.size.width/2, self.size.height - 270);
        [self addChild:self.botaoRestart];
        
        //Cria o Highscore
        SKLabelNode *highscoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        highscoreLabel.fontSize = 32;
        highscoreLabel.fontColor = [UIColor blackColor];
        highscoreLabel.position = CGPointMake(self.size.width/2, self.size.height - 210);
        [[Pontos pontos]highScore];
        highscoreLabel.text = [NSString stringWithFormat:@"HighScore: %i", MAX(0, [[Pontos pontos]highScore])];
        [self addChild:highscoreLabel];
        
        if ([[Pontos pontos] highScore] != nil) {
            if ([[Pontos pontos]pontuacao] > [[Pontos pontos]highScore]) {
                [[Pontos pontos]salvarPontuacao];
                highscoreLabel.text = [NSString stringWithFormat:@"HighScore: %i", MAX(0, [[Pontos pontos]pontuacao])];
            }
        }else{
            [[Pontos pontos]salvarPontuacao];
            
        }
        
       
        self.botaoRestart.name = botaoCategoryName;
        
    }
    
    return self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact{



}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{


    UITouch* touch =[touches anyObject];
    
    //Pega a posicao do toque na tela
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKNode * node = [self nodeAtPoint:touchLocation];
    
    if ([node.name isEqualToString:@"botaoRestart"]) {
        
        //Cria a cena de game over
        MyScene *jogarNovamente=[[MyScene alloc]initWithSize:self.size];
        //Pede para a MyScene acessar a view e apresentar o Game Over
        [self.view presentScene:jogarNovamente];

    }


}


@end
