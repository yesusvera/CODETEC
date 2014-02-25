//
//  EstantesController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarLivroResposta.h"
#import "ConexaoEstante.h"


@interface EstantesController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *estantes;
}

@property (nonatomic, retain) RegistrarLivroResposta *registrarLivroResponse;
@property (nonatomic, retain) ConexaoEstante *conexaoEstante;
@property (nonatomic, retain) NSString *txtCodCliente;
@property (nonatomic, retain) NSString *txtDocumento;
@property (nonatomic, retain) NSString *txtSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblDispositivo;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
- (IBAction) obterEstante:(id)sender;

@end
