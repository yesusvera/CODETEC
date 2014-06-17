//
//  EstanteLivrosController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 04/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "EstanteLivrosController.h"
#import "LivroResponse.h"
#import "LivroDetalhesView.h"
#import "GLB.h"
@interface EstanteLivrosController ()

@end

@implementation EstanteLivrosController
@synthesize estanteResponse,registrarDispositivoResponse;

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
    self.title = self.nomeEstante;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([_nomeEstante isEqualToString:@"Visão Geral"]){
        return self.estanteResponse.listaLivrosVisaoGeral.count;
    }else if([_nomeEstante isEqualToString:@"Disponíveis"]){
        return self.estanteResponse.listaLivrosDisponiveis.count;
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        return self.estanteResponse.listaLivrosDeDireito.count;
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        return self.estanteResponse.listaLivrosBaixados.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"livro"];
    NSString *tituloLivro;
    NSString *linkFotoLivro;
    
    if([_nomeEstante isEqualToString:@"Visão Geral"]){
        LivroResponse *livro = [estanteResponse.self.listaLivrosVisaoGeral objectAtIndex:indexPath.row];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }else if([_nomeEstante isEqualToString:@"Disponíveis"]){
        LivroResponse *livro = [estanteResponse.self.listaLivrosDisponiveis objectAtIndex:indexPath.row];
               tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        LivroResponse *livro = [estanteResponse.self.listaLivrosDeDireito objectAtIndex:indexPath.row];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        LivroResponse *livro = [estanteResponse.self.listaLivrosBaixados objectAtIndex:indexPath.row];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }
    
    cell.textLabel.text = tituloLivro;
    if([UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:linkFotoLivro]] ]){
        cell.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:linkFotoLivro]] ];
    }else{
        cell.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile: [GLB downloadSavePathFor:linkFotoLivro.lastPathComponent] ]];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LivroDetalhesView *livroDetalhesView = [[LivroDetalhesView alloc]init];
    if([_nomeEstante isEqualToString:@"Visão Geral"]){
        livroDetalhesView.livroResponse = [estanteResponse.listaLivrosVisaoGeral objectAtIndex:indexPath.row];
    }else if([_nomeEstante isEqualToString:@"Disponíveis"]){
        livroDetalhesView.livroResponse = [estanteResponse.listaLivrosDisponiveis objectAtIndex:indexPath.row];
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        livroDetalhesView.livroResponse = [estanteResponse.listaLivrosDeDireito objectAtIndex:indexPath.row];
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        livroDetalhesView.livroResponse = [estanteResponse.listaLivrosBaixados objectAtIndex:indexPath.row];
    }

    livroDetalhesView.registrarDispositivoResponse = registrarDispositivoResponse;
    
    [self.navigationController pushViewController:livroDetalhesView animated:YES];
}

@end
