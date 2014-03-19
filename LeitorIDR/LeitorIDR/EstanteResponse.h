//
//  EstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 24/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstanteResponse : NSObject{
    NSMutableArray *listaDeLivros;
    NSNumber *qtdLivrosParaBaixar;
    NSNumber *qtdLivrosBaixados;
    NSNumber *qtdLivrosDeDireito;
}
@property (nonatomic, retain) NSMutableArray *listaDeLivros;
@property (nonatomic, retain) NSNumber *qtdLivrosParaBaixar;
@property (nonatomic, retain) NSNumber *qtdLivrosBaixados;
@property (nonatomic, retain) NSNumber *qtdLivrosDeDireito;
@end
