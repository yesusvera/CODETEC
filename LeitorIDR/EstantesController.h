//
//  EstantesController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarLivroResponse.h"
#import "ObterEstanteIbracon.h"


@interface EstantesController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *estantes;
}

@property (nonatomic, retain) RegistrarLivroResponse *registrarLivroResponse;
@property (nonatomic, retain) ObterEstanteIbracon *obterEstanteResponse;
@property (weak, nonatomic) IBOutlet UITextField *txtCodCliente;
@property (weak, nonatomic) IBOutlet UITextField *txtDocumento;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblDispositivo;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
- (IBAction) obterEstante:(id)sender;

@end
