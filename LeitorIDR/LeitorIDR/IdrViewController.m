//
//  ViewController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 17/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "IdrViewController.h"
#import "RegistroAssociadoController.h"
#import "RegistroNaoAssociadoController.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface IdrViewController ()

@end

@implementation IdrViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //DANDO ALERTA DE BOAS VINDAS
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"IBRACON DIGITAL READER" message:@"SEJA BEM VINDO!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alert show];
    
    self.title = @"IBRACON DIGITAL READER";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//-(IBAction)enviaNome{
//    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Mensagem" message:txtDispositivo.text delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alert show];
//    [txtDispositivo setText: @"" ];
//}


@end
