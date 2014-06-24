//
//  Pontos.h
//  Drac
//
//  Created by LUCAS SOTIN PLACHI ANDELOCI on 18/06/14.
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pontos : NSObject

+ (Pontos *) pontos;

- (void)salvarPontuacao;
- (void)pegarPontuacao;

@property int pontuacao;

@property int highScore;

@end
