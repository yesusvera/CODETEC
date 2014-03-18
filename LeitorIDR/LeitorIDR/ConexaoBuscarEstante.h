//
//  ObterEstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivroResponse.h"
#import "EstanteResponse.h"
#import "RegistrarDispositivoResponse.h"

@interface ConexaoBuscarEstante : NSObject<NSXMLParserDelegate>{
    EstanteResponse *estanteResponse;
    NSMutableString *valorNoAtual;
    LivroResponse *livro;
    NSString *erro;
    NSString *msgErro;
}
-(EstanteResponse *)conectarObterEstante:(RegistrarDispositivoResponse *) registrarDispositivoResponse;
-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
//@property (nonatomic, retain) EstanteResponse *estanteResponse;
-(EstanteResponse *)conectarObterEstanteLocal:(RegistrarDispositivoResponse *) registrarDispositivoResponse;

@end
