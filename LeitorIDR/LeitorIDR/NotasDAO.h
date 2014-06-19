//
//  NotasDAO.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 19/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nota.h"

@interface NotasDAO : NSObject

- (BOOL)salvarAtualizarNota:(Nota *) nota;
- (BOOL)existeNota:(Nota *) nota;
- (NSMutableArray *) listaNotasPorCodLivro: (NSString *) codigoLivro;
- (Nota *) pesquisarNotaPorPagina:(NSString *)pagina eCodigoDoLivro:(NSString *) codLivro;

@end
