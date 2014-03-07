//
//  RegistrarLivroResponse.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 04/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DadosCliente.h"

@interface RegistrarDispositivoResponse : NSObject{
    NSString *codCliente;
    NSString *codDispositivo;
    NSString *status;
    NSString *appVersion;
    NSString *erro;
    NSString *msgErro;
}

@property(nonatomic, retain) NSString *codCliente;
@property(nonatomic, retain) NSString *codDispositivo;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *appVersion;
@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;
@property(nonatomic, retain) DadosCliente *dadosCliente;

@end
