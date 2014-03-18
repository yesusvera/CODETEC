//
//  EstantesController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarDispositivoResponse.h"
#import "ConexaoBuscarEstante.h"
#import "EstanteResponse.h"


@interface EstantesController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *estantes;
    EstanteResponse *estanteResponse;
}

@property (nonatomic, retain) RegistrarDispositivoResponse *registrarDispositivoResponse;
@property (nonatomic, retain) NSString *txtCodCliente;
@property (nonatomic, retain) NSString *txtDocumento;
@property (nonatomic, retain) NSString *txtSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblDispositivo;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
@property (nonatomic, retain) EstanteResponse *estanteResponse;

@end
