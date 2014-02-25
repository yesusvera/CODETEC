//
//  EstantesController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "EstantesController.h"
#import "EstanteLivrosController.h"
#import "ConexaoEstante.h"

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
    [estanteLivros setEstanteResponse:self.conexaoEstante.estanteResponse];
    
    
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
    NSString *urlObterEstante = @"http://www.ibracon.com.br/idr/ws/ws_estantes.php?";
    
     _conexaoEstante = [[ConexaoEstante alloc] init];
    
    
    //Cliente
    urlObterEstante = [urlObterEstante stringByAppendingString:@"cliente="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:self.registrarLivroResponse.codCliente]];

    urlObterEstante = [urlObterEstante stringByAppendingString:@"&documento="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:self.txtDocumento]];
    
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&dispositivo="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:self.registrarLivroResponse.codDispositivo]];
    
    
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&keyword="];
    //urlObterEstante = [urlObterEstante stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtSenha.text]];

    urlObterEstante = [urlObterEstante stringByAppendingString:@"&senha="];
    urlObterEstante = [urlObterEstante stringByAppendingString: [self urlEncodeUsingEncoding:self.txtSenha]];
    
    [_conexaoEstante conectarObterEstante:urlObterEstante];
    
    
}




@end
