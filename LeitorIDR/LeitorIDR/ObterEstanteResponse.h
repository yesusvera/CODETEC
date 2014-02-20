//
//  ObterEstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObterEstanteResponse : NSObject{
    NSMutableArray *listaDeLivrosParaBaixar;
    NSMutableArray *listaDeLivrosBaixados;
    NSMutableArray *listaDeLivrosDeDireito;
}

@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;
@property(nonatomic, retain) NSMutableArray *listaDeLivrosParaBaixar;
@property(nonatomic, retain) NSMutableArray *listaDeLivrosBaixados;
@property(nonatomic, retain) NSMutableArray *listaDeLivrosDeDireito;

@end
