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
@synthesize estanteResponse;


bool flagConexaoLocal;
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
    
    EstanteLivrosController *estanteLivrosController = [[EstanteLivrosController alloc]init];
    estanteLivrosController.nomeEstante = [estantes objectAtIndex:indexPath.row];
    estanteLivrosController.registrarDispositivoResponse = self.registrarDispositivoResponse;
    estanteLivrosController.estanteResponse = self.estanteResponse;
    
    [self.navigationController pushViewController:estanteLivrosController animated:YES];
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
    
    ConexaoBuscarEstante *conexaoBuscarEstante = [[ConexaoBuscarEstante alloc]init];
    self.estanteResponse = [conexaoBuscarEstante conectarObterEstante:self.registrarDispositivoResponse];

}

-(void)viewDidAppear:(BOOL)animated{

//
    // Falta sobrepor a estante e manter o vaor do registrarLivroResponse
    //if([conexaoRegistrarLivro.registrarLivroResponse.erro isEqualToString:@"0"]){
    if(flagConexaoLocal){
        ConexaoBuscarEstante *conexaoBuscarEstante2 = [[ConexaoBuscarEstante alloc]init];
        self.estanteResponse = [conexaoBuscarEstante2 conectarObterEstanteLocal:self.registrarDispositivoResponse];
    }
    
     flagConexaoLocal = true;
    //}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
