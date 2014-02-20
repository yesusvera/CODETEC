//
//  EstantesController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarLivroResponse.h"
#import "ObterEstanteResponse.h"


@interface EstantesController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>{
    ObterEstanteResponse *obterEstanteResponse;
    NSString *erro;
    NSString *msgErro;
    BOOL *isParaBaixar;
    BOOL *isBaixados;
    BOOL *isDeDireito;
    
    NSMutableString *valorElementoAtual;
    NSArray *estantes;
}

@property (nonatomic, retain) RegistrarLivroResponse *registrarLivroResponse;
@property (weak, nonatomic) IBOutlet UITextField *txtCodCliente;
@property (weak, nonatomic) IBOutlet UITextField *txtDocumento;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblDispositivo;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
@property BOOL *isParaBaixar;
@property BOOL *isBaixados;
@property BOOL *isDeDireito;

@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;
- (IBAction) obterEstante:(id)sender;
-(void)obterEstante:(NSString *)_url indicadorCarregando:(UIActivityIndicatorView *)indicadorAtividade controller:(UIViewController *)controlador;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicadorAtividade;

@end
