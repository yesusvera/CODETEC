//
//  EstantesController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "EstantesController.h"
#import "EstanteLivrosController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ObterEstanteIbracon.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface EstantesController ()

@end

@implementation EstantesController

-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EstanteLivrosController *estanteLivros = [[EstanteLivrosController alloc]init];
    estanteLivros.nomeEstante = [estantes objectAtIndex:indexPath.row];
    [estanteLivros setRegistrarLivroResponse:self.registrarLivroResponse];
    [self.navigationController pushViewController:estanteLivros animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return estantes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemEstante"];
    cell.textLabel.text = [estantes objectAtIndex:indexPath.row];
    return cell;
}


- (void)viewDidLoad
{
    estantes = @[@"Visão Geral", @"Disponíveis", @"Direito de uso", @"Minha Biblioteca"];

    [super viewDidLoad];

    self.title= @"Estantes";
    [self obterEstante:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) obterEstante:(id)sender {
    //    NSString *urlRegistrarDisp = @"http://www.ibracon.com.br/idr/ws/ws_registrar.php?endereco=GUARA&senha=1234&numero=23&serial=W892913L644&cidade=BRASILIA&ip=192.168.1.10&cliente=YESUS&dispositivo=MacBook-Pro-de-Yesus.local&macadress=00-26-08-E5-4F-01&registro=RN001&uf=DF&email=yesusvera%40gmail.com&cep=&documento=001&associado=n&telefone=111&bairro=GUARA+II&complemento=123";
    
    // MAIS UM TESTES DE COMMIT - YESUS
    NSString *urlObterEstante = @"http://www.ibracon.com.br/idr/ws/ws_estantes.php?";
    
    ObterEstanteIbracon *obterEstanteIbracon = [[ObterEstanteIbracon alloc] init];
    
    
    //Cliente Associado
    urlObterEstante = [urlObterEstante stringByAppendingString:@"cliente="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:@"1373"]];
    
    //DADOS DO FORMULARIO - JONATHAN
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&documento="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:@"338.804.908-48"]];
    
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&dispositivo="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:@"54"]];
    
    
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&keyword="];
    //urlObterEstante = [urlObterEstante stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtSenha.text]];
    
    
    //DADOS DO DISPOSITIVO
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&senha="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:@"teste"]];
    
    [obterEstanteIbracon conectarObterEstante:urlObterEstante];
}




@end
