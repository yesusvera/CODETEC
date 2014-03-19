//
//  ConnectionIbracon.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 02/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrarDispositivoResponse.h"
#import "DadosCliente.h"
#import "DadosDispositivo.h"

@interface ConexaoRegistrarDispositivo : NSObject <NSXMLParserDelegate>{
    RegistrarDispositivoResponse *registrarDispositivoResponse;
    NSMutableString *valorElementoAtual;
}
- (void)registrarDispositivo:(UIActivityIndicatorView *)indicadorAtividade controller:(UIViewController *)controlador comDadosCliente:(DadosCliente *) dadosCliente comDadosDispositivo:(DadosDispositivo *) dadosDispositivo;
- (BOOL) buscarRegistroLocal;
@property (nonatomic, retain) RegistrarDispositivoResponse *registrarDispositivoResponse;
@end
