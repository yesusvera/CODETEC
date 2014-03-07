//
//  ConexaoRegistrarLivro.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 06/03/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrarDispositivoResponse.h"
#import "LivroResponse.h"
#import "RegistrarLivroResponse.h"

@interface ConexaoRegistrarLivro : NSObject<NSXMLParserDelegate>{
     RegistrarLivroResponse *registrarLivroResponse;
     NSMutableString *valorElementoAtual;
}

@property (nonatomic, retain) RegistrarLivroResponse *registrarLivroResponse;
-(void)registrarLivroBaixado:(RegistrarDispositivoResponse *) registrarLivroResponse comLivroResponse:(LivroResponse *) livroResponse;

@end
