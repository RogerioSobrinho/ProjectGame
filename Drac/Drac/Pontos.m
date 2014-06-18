//
//  Pontos.m
//  Drac
//
//  Created by LUCAS SOTIN PLACHI ANDELOCI on 18/06/14.
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import "Pontos.h"

@implementation Pontos

+ (Pontos *) pontos
{
    static Pontos *pontos = nil;
    if (!pontos)
    {
        pontos = [[super allocWithZone:nil] init];
    }
    
    return pontos;
}

+ (id)allocWithZone: (struct _NSZone *)zone
{
    return [self pontos];
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
