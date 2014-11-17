//
//  RegistroNaoAssociadoController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistroNaoAssociadoController:UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray *ufArray;
    __weak IBOutlet UIScrollView *scroller;
}
- (IBAction)registrarDispositivo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDispositivo;
@property (weak, nonatomic) IBOutlet UILabel *lblMacAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblIP;
@property (weak, nonatomic) IBOutlet UILabel *lblSerial;

@property (weak, nonatomic) IBOutlet UITextField *txtNomeRazaoSocial;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (weak, nonatomic) IBOutlet UITextField *txtDocumento;
@property (weak, nonatomic) IBOutlet UITextField *txtEndereco;
@property (weak, nonatomic) IBOutlet UITextField *txtNumero;
@property (weak, nonatomic) IBOutlet UITextField *txtComplemento;
@property (weak, nonatomic) IBOutlet UITextField *txtBairro;
@property (weak, nonatomic) IBOutlet UITextField *txtCidade;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtTelefone;
@property (weak, nonatomic) IBOutlet UITextField *txtCEP;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicadorAtividade;
@property (weak, nonatomic) IBOutlet UIPickerView *ufPicker;
@property (nonatomic,retain) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistrar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipoPessoa;


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end
