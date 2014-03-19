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
bool flagConexaoLocal;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EstanteLivrosController *estanteLivrosController = [[EstanteLivrosController alloc]init];
    estanteLivrosController.nomeEstante = [estantes objectAtIndex:indexPath.row];
    estanteLivrosController.registrarDispositivoResponse = registrarDispositivoResponse;
    estanteLivrosController.estanteResponse = estanteResponse;
    
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
    estanteResponse = [conexaoBuscarEstante conectarObterEstante:registrarDispositivoResponse];

}

-(void)viewDidAppear:(BOOL)animated{
    
    if(flagConexaoLocal){
        ConexaoBuscarEstante *conexaoBuscarEstante2 = [[ConexaoBuscarEstante alloc]init];
        estanteResponse = [conexaoBuscarEstante2 conectarObterEstanteLocal:registrarDispositivoResponse];
    }
    flagConexaoLocal = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
