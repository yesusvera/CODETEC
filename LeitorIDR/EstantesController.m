//
//  EstantesController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "EstantesController.h"
#import "EstanteLivrosController.h"
#import "ConexaoBuscarEstante.h"

@interface EstantesController ()
   
@end

@implementation EstantesController

@synthesize registrarDispositivoResponse;
//bool flagConexaoLocal;
EstanteLivrosController *estanteLivrosController;

- (void)viewDidLoad
{
    estantes = @[@"Visão Geral", @"Disponíveis", @"Direito de uso", @"Minha Biblioteca"];

    [super viewDidLoad];

    self.title= @"Estantes";
    
    ConexaoBuscarEstante *conexaoBuscarEstante = [[ConexaoBuscarEstante alloc]init];

    estanteLivrosController = [[EstanteLivrosController alloc]init];
    estanteLivrosController.registrarDispositivoResponse = registrarDispositivoResponse;
    estanteResponse = [conexaoBuscarEstante conectarObterEstante:registrarDispositivoResponse];
}


-(void)viewDidAppear:(BOOL)animated{
    ConexaoBuscarEstante *conexaoBuscarEstante = [[ConexaoBuscarEstante alloc]init];
    
    estanteLivrosController = [[EstanteLivrosController alloc]init];
    estanteLivrosController.registrarDispositivoResponse = registrarDispositivoResponse;
    estanteResponse = [conexaoBuscarEstante conectarObterEstante:registrarDispositivoResponse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = false;
    
    estanteLivrosController.nomeEstante = [estantes objectAtIndex:indexPath.row];
    estanteLivrosController.estanteResponse = estanteResponse;
    
    if ([estanteLivrosController.nomeEstante isEqualToString:@"Direito de uso"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Seja bem vindo ao IDR - Ibracon Digital Reader" message:@"Por favor, informar a palavra chave e senha:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Prosseguir", nil];
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"Palavra-chave"];
        [[alertView textFieldAtIndex:1] setPlaceholder:@"Senha"];
        
        [alertView show];
    }else{
        [self.navigationController pushViewController:estanteLivrosController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return estantes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemEstante"];
    cell.textLabel.text = [estantes objectAtIndex:indexPath.row];
    return cell;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *palavrachave = [alertView textFieldAtIndex:0];
        
        UITextField *senha = [alertView textFieldAtIndex:1];
        
        registrarDispositivoResponse.dadosCliente.senha = senha.text;
        NSLog(@"password: %@", senha.text);
        registrarDispositivoResponse.dadosCliente.palavraChave = palavrachave.text;
        NSLog(@"username: %@", palavrachave.text);


        if(registrarDispositivoResponse.dadosCliente.palavraChave != nil &&
           registrarDispositivoResponse.dadosCliente.senha != nil){
            
            ConexaoBuscarEstante *conexaoBuscarEstante = [[ConexaoBuscarEstante alloc]init];
            estanteLivrosController.registrarDispositivoResponse = registrarDispositivoResponse;
            estanteResponse = [conexaoBuscarEstante conectarObterEstante:registrarDispositivoResponse];
            estanteLivrosController.estanteResponse = estanteResponse;
            
            [self.navigationController pushViewController:estanteLivrosController animated:YES];
        }
    }
}


@end
