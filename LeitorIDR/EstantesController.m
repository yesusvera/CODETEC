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
#import "AFHTTPRequestOperationManager.h"

@interface EstantesController ()
   
@end

@implementation EstantesController

@synthesize registrarDispositivoResponse;
//bool flagConexaoLocal;
EstanteLivrosController *estanteLivrosController;

- (void)viewDidLoad
{
//    estantes = @[@"Visão Geral", @"Disponíveis", @"Direito de uso", @"Minha Biblioteca"];
    estantes = @[@"Disponíveis", @"Direito de uso", @"Minha Biblioteca"];

    [super viewDidLoad];

    self.title= @"IBRACON - Estantes";
//    
//    ConexaoBuscarEstante *conexaoBuscarEstante = [[ConexaoBuscarEstante alloc]init];
//
//    estanteLivrosController = [[EstanteLivrosController alloc]init];
//    estanteLivrosController.registrarDispositivoResponse = registrarDispositivoResponse;
//    estanteResponse = [conexaoBuscarEstante conectarObterEstante:registrarDispositivoResponse];
}


-(void)viewDidAppear:(BOOL)animated{
    
    if(_removeNavigationBar){
        self.navigationController.navigationBarHidden = TRUE;
    }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return TRUE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return estantes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemEstante"];
    cell.textLabel.text = [estantes objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
          
            NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
            networkQueue.maxConcurrentOperationCount = 5;
            
            NSURL *url = [NSURL URLWithString:[conexaoBuscarEstante montarUrlParaObterEstante:registrarDispositivoResponse]];
            NSLog(@"%@", url);
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
                NSLog(@"%@", respostaXML);
                
                NSData *respDataXML = [respostaXML dataUsingEncoding:NSISOLatin1StringEncoding];
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
                [parser setDelegate:conexaoBuscarEstante];
                
                if(![parser parse]){
                    NSLog(@"Erro ao realizar o parse");
                }else{
                    NSLog(@"Ok Parse");
                   // estanteResponse = [conexaoBuscarEstante estanteResponse];
                    estanteLivrosController.registrarDispositivoResponse = registrarDispositivoResponse;
                    estanteLivrosController.estanteResponse = [conexaoBuscarEstante estanteResponse];
                    
                    [self.navigationController pushViewController:estanteLivrosController animated:YES];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
                
            
            }];
            
            [networkQueue addOperation:operation];
        
        }
    }
}


@end
