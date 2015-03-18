//
//  RegistroNaoAssociadoController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "RegistroNaoAssociadoController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "EstantesController.h"
#import "DadosCliente.h"
#import "DadosDispositivo.h"
#import "ConexaoRegistrarDispositivo.h"
#import "NSstringMask.h"
#import "CWSBrasilValidate.h"
#import "GLB.h"

@interface RegistroNaoAssociadoController ()
@end

@implementation RegistroNaoAssociadoController

@synthesize tipoPessoa;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return TRUE;
}

- (IBAction)incluirMascaraDoCEP:(UITextField *)sender {
    if(sender.text.length == 2){
        [sender setText:[sender.text stringByAppendingString:@"."]];
    }else if(sender.text.length == 6){
        [sender setText:[sender.text stringByAppendingString:@"-"]];
    }
    NSRange range = NSMakeRange(0,10);
    if(sender.text.length == 11){
        [sender setText:[sender.text substringWithRange:range]];
    }
    
}

- (IBAction)incluirMascaraTel:(UITextField *)sender {
    if(sender.text.length == 1){
        [sender setText:[@"(" stringByAppendingString:sender.text]];
    }else if(sender.text.length == 3){
        [sender setText:[sender.text stringByAppendingString:@") "]];
    }else if(sender.text.length == 9){
        [sender setText:[sender.text stringByAppendingString:@"-"]];
    }
    NSRange range = NSMakeRange(0,14);
    if(sender.text.length == 15){
        [sender setText:[sender.text substringWithRange:range]];
    }
}

- (IBAction)editarDocComMascara:(UITextField *)sender {
    if (tipoPessoa.selectedSegmentIndex == 0) {
        
        if(sender.text.length == 3 || sender.text.length == 7){
            [sender setText:[sender.text stringByAppendingString:@"."]];
        }else if(sender.text.length == 11){
            [sender setText:[sender.text stringByAppendingString:@"-"]];
        }
        NSRange range = NSMakeRange(0,14);
        if(sender.text.length == 15){
            [sender setText:[sender.text substringWithRange:range]];
        }
        
    }else{
        if(sender.text.length == 2 || sender.text.length == 6){
            [sender setText:[sender.text stringByAppendingString:@"."]];
        }else if(sender.text.length == 10){
            [sender setText:[sender.text stringByAppendingString:@"/"]];
        }else if(sender.text.length == 15){
            [sender setText:[sender.text stringByAppendingString:@"-"]];
        }
        NSRange range = NSMakeRange(0,18);
        if(sender.text.length == 19){
            [sender setText:[sender.text substringWithRange:range]];
        }
    }

}

- (IBAction)defineTipoPessoa:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.txtDocumento setText:@""];
        self.txtDocumento.placeholder = [NSStringMask maskString:@"" withPattern:@"(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})" placeholder:@"0"];
    }else{
        [self.txtDocumento setText:@""];
        self.txtDocumento.placeholder =[NSStringMask maskString:@"" withPattern:@"(\\d{2}).(\\d{3}).(\\d{3})/(\\d{4})-(\\d{2})" placeholder:@"0"];
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Registro - Não associado";
    self.indicadorAtividade.hidden = TRUE;
    
    [scroller setScrollEnabled:true];
    [scroller setContentSize:CGSizeMake(320, 1800)];
   
    ufArray = [[NSArray alloc] initWithObjects:@"AC", @"AL", @"AM", @"AP", @"BA", @"CE", @"DF", @"ES", @"GO",@"MA", @"MG", @"MS", @"MT", @"PA", @"PB", @"PE", @"PI",@"PR", @"RJ", @"RN", @"RO", @"RR", @"RS", @"RS", @"SC", @"SE", @"SP",@"TO", nil];
    
    //Inicializando UITextField
    
    self.txtDocumento.placeholder = [NSStringMask maskString:@"" withPattern:@"(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})" placeholder:@"0"];
    
    self.txtCEP.placeholder = [NSStringMask maskString:@"" withPattern:@"(\\d{2}).(\\d{3})-(\\d{3})" placeholder:@"0"];
    
    self.txtTelefone.placeholder = [NSStringMask maskString:@"" withPattern:@"\\((\\d{2})\\) (\\d{4})-(\\d{4})" placeholder:@"0"];
    
    
    [self.lblIP  setText: [self getIPAddress]];
    [self.lblMacAdress setText: [self getMacAddress]];
    [self.lblSerial setText: [[UIDevice currentDevice] description]];
    [self.lblDispositivo setText: [[UIDevice currentDevice] localizedModel]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


- (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

- (IBAction)registrarDispositivo:(id)sender {
    DadosCliente *dadosCliente = [[DadosCliente alloc] init];
    
    dadosCliente.ehAssociado      = @"n";
    
    
    NSString *docSemMask = [[[self.txtDocumento.text stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    dadosCliente.documento        = self.txtDocumento.text;
    dadosCliente.nomeRazao = self.txtNomeRazaoSocial.text;
    dadosCliente.senha            = self.txtSenha.text;
    dadosCliente.palavraChave     = @"";
    dadosCliente.endereco = self.txtEndereco.text;
    dadosCliente.numero = self.txtNumero.text;
    dadosCliente.complemento = self.txtComplemento.text;
    dadosCliente.bairro = self.txtBairro.text;
    dadosCliente.cidade = self.txtCidade.text;
    dadosCliente.uf = [ufArray objectAtIndex:[self.ufPicker selectedRowInComponent:0]];
    dadosCliente.email = self.txtEmail.text;
    
//    
//    BOOL cepValido = [CWSBrasilValidate validarCEP:self.txtCEP.text];
//    
//    if(!cepValido){
//        [GLB showMessage:@"CEP Inválido!"];
//        return;
//    }
    
    
    dadosCliente.cep = self.txtCEP.text;
    dadosCliente.telefone = self.txtTelefone.text;
    
    if([dadosCliente.nomeRazao length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campo obrigatório "
                                                        message:@"O campo Nome/Razão Social é de preenchimento obrigatório."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ];
        [alert show];
        return;
    }
    
    
//    if([dadosCliente.senha length]==0){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campo obrigatório "
//                                                        message:@"O campo senha é de preenchimento obrigatório."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil
//                              ];
//        [alert show];
//        return;
//    }
    
    
    if([dadosCliente.documento length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campo obrigatório "
                                                        message:@"O campo Documento é de preenchimento obrigatório."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ];
        [alert show];
        return;
    }
    
    if (tipoPessoa.selectedSegmentIndex == 0) {
        BOOL valido = [CWSBrasilValidate validarCPF:docSemMask];
        if (!valido) {
            [GLB showMessage:@"CPF Inválido!"];
            return;
        }
    }else{
        BOOL valido = [CWSBrasilValidate validarCNPJ:docSemMask];
        if (!valido) {
            [GLB showMessage:@"CNPJ Inválido!"];
            return;
        }
    }


    
    DadosDispositivo *dadosDispositivo = [[DadosDispositivo alloc]init];
    
    dadosDispositivo.dispositivo  = self.lblDispositivo.text;
    dadosDispositivo.ip           = self.lblIP.text;
    dadosDispositivo.macAdress    = self.lblMacAdress.text;
    dadosDispositivo.serial       = self.lblSerial.text;
    
    self.btnRegistrar.enabled = false;
    
    ConexaoRegistrarDispositivo *solicitarRegistroDispositivo =[[ConexaoRegistrarDispositivo alloc]init];
    [solicitarRegistroDispositivo registrarDispositivo: self.indicadorAtividade controller:self comDadosCliente:dadosCliente comDadosDispositivo:dadosDispositivo botaoRegistrar:self.btnRegistrar];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [ufArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [ufArray objectAtIndex:row];
}
@end
