//
//  DadosCliente.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 07/03/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DadosCliente : NSObject

@property(nonatomic, retain) NSString *ehAssociado;
@property(nonatomic, retain) NSString *registroNacional;
@property(nonatomic, retain) NSString *documento;
@property(nonatomic, retain) NSString *senha;
@property(nonatomic, retain) NSString *palavraChave;

@property(nonatomic, retain) NSString *nomeRazao;
@property(nonatomic, retain) NSString *endereco;
@property(nonatomic, retain) NSString *numero;
@property(nonatomic, retain) NSString *complemento;
@property(nonatomic, retain) NSString *bairro;
@property(nonatomic, retain) NSString *cidade;
@property(nonatomic, retain) NSString *uf;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *telefone;
@property(nonatomic, retain) NSString *cep;

@end
