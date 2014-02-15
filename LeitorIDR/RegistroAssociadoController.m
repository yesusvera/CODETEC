//
//  RegistroAssociadoController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "RegistroAssociadoController.h"
#import "ConnectionIbracon.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface RegistroAssociadoController ()

@end

@implementation RegistroAssociadoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Sou associado";
    
    self.indicadorAtividade.hidden = TRUE;
    
    //Inicializando UITextField
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
    //    NSString *urlRegistrarDisp = @"http://www.ibracon.com.br/idr/ws/ws_registrar.php?endereco=GUARA&senha=1234&numero=23&serial=W892913L644&cidade=BRASILIA&ip=192.168.1.10&cliente=YESUS&dispositivo=MacBook-Pro-de-Yesus.local&macadress=00-26-08-E5-4F-01&registro=RN001&uf=DF&email=yesusvera%40gmail.com&cep=&documento=001&associado=n&telefone=111&bairro=GUARA+II&complemento=123";
    
    // TESTE DE COMMIT DE ALTERACAO - YESUS / JONATHAN
    NSString *urlRegistrarDisp = @"http://www.ibracon.com.br/idr/ws/ws_registrar.php?";
    ConnectionIbracon *connectionIbra =[ConnectionIbracon alloc];
    
    
    //Cliente Associado
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"associado=s"];
    
    //DADOS DO FORMULARIO
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&registro="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtRegistroNacional.text]];
    
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&documento="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtCPFCNPJ.text]];
   
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&senha="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtSenha.text]];
    
    
    //DADOS DO DISPOSITIVO
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&dispositivo="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.lblDispositivo.text]];
    
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&ip="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.lblIP.text]];
    
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&macadress="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.lblMacAdress.text]];
    
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString:@"&serial="];
    urlRegistrarDisp = [urlRegistrarDisp stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.lblSerial.text]];

    
    [connectionIbra registrarDispositivo:urlRegistrarDisp indicadorCarregando:self.indicadorAtividade controller:self];
}


@end
