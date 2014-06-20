//
//  LivrosBaixadosDAO.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 19/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivroResponse.h"

@interface LivrosBaixadosDAO : NSObject


- (BOOL)salvarAtualizarLivroBaixado:(LivroResponse *) livroBaixado;
- (BOOL)existeLivro:(LivroResponse *) livroBaixado;
- (NSMutableArray *) listaLivros;
@end

