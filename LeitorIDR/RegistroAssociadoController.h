//
//  RegistroAssociadoController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistroAssociadoController : UIViewController
- (IBAction)registrarDispositivo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtRegistroNacional;
@property (weak, nonatomic) IBOutlet UITextField *txtCPFCNPJ;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblDispositivo;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicadorAtividade;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistrar;
@end