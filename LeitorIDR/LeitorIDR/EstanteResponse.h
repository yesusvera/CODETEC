//
//  EstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 24/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstanteResponse : NSObject{
    NSMutableArray *listaLivrosVisaoGeral;
    NSMutableArray *listaLivrosDisponiveis;
    NSMutableArray *listaLivrosDeDireito;
    NSMutableArray *listaLivrosBaixados;
    
    BOOL conectouEstante;

}
@property (nonatomic, retain) NSMutableArray *listaLivrosVisaoGeral;
@property (nonatomic, retain) NSMutableArray *listaLivrosDisponiveis;
@property (nonatomic, retain) NSMutableArray *listaLivrosDeDireito;
@property (nonatomic, retain) NSMutableArray *listaLivrosBaixados;
@property BOOL conectouEstante;

@end
