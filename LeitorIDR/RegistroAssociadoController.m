 //
//  RegistroAssociadoController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "RegistroAssociadoController.h"
#import "ConexaoRegistrarDispositivo.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "EstantesController.h"
#import "DadosCliente.h"
#import "DadosDispositivo.h"
#import "NSStringMask.h"
#import "CWSBrasilValidate.h"
#import "GLB.h"

@interface RegistroAssociadoController ()

@end

@implementation RegistroAssociadoController
@synthesize tipoPessoa;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return TRUE;
}

- (IBAction)defineTipoPessoa:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.txtCPFCNPJ setText:@""];
        self.txtCPFCNPJ.placeholder = [NSStringMask maskString:@"" withPattern:@"(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})" placeholder:@"0"];
    }else{
        [self.txtCPFCNPJ setText:@""];
        self.txtCPFCNPJ.placeholder =[NSStringMask maskString:@"" withPattern:@"(\\d{2}).(\\d{3}).(\\d{3})/(\\d{4})-(\\d{2})" placeholder:@"0"];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"Registro - Sou associado";
    
    self.indicadorAtividade.hidden = TRUE;
    
    self.txtCPFCNPJ.hidden = NO;
    
    //Inicializando UITextField
    //[self.txtCPFCNPJ setText:@"338.804.908-48"];
    
    self.txtCPFCNPJ.placeholder = [NSStringMask maskString:@"" withPattern:@"(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})" placeholder:@"0"];

    [self.lblIP  setText: [self getIPAddress]];
    [self.lblMacAdress setText: [self getMacAddress]];
    [self.lblSerial setText: [[UIDevice currentDevice] description]];
    [self.lblDispositivo setText: [[UIDevice currentDevice] localizedModel]];
    
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
    
    dadosCliente.ehAssociado      = @"s";
    dadosCliente.registroNacional = self.txtRegistroNacional.text;
    
    
    NSString *docSemMask = [[[self.txtCPFCNPJ.text stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];

    
    dadosCliente.documento        = self.txtCPFCNPJ.text;
    

    
    NSLog(@"documento: %@", dadosCliente.documento);
    
    dadosCliente.senha            = self.txtSenha.text;
    dadosCliente.palavraChave     = @"";
    
    
    
    if([dadosCliente.registroNacional length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campo obrigatório "
                                                        message:@"O campo Registro Nacional é de preenchimento obrigatório."
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

- (IBAction)tipoPEssoa:(id)sender {
}
- (IBAction)tipoPessoa:(UISegmentedControl *)sender {
}
@end
