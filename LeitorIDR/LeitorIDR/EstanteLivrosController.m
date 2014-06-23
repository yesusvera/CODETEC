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
#import "LivrosBaixadosDAO.h"
@interface EstanteLivrosController ()

@end

@implementation EstanteLivrosController

@synthesize estanteResponse,registrarDispositivoResponse,listaLivros;

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
    
    if([_nomeEstante isEqualToString:@"Visão Geral"]){
       self.listaLivros = self.estanteResponse.listaLivrosVisaoGeral;
    }else if([_nomeEstante isEqualToString:@"Disponíveis"]){
        self.listaLivros =self.estanteResponse.listaLivrosDisponiveis;
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        self.listaLivros = self.estanteResponse.listaLivrosDeDireito;
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        //self.listaLivros = self.estanteResponse.listaLivrosBaixados;
        LivrosBaixadosDAO *livroBaixadosDAO = [[LivrosBaixadosDAO alloc] init];
        self.listaLivros = [livroBaixadosDAO listaLivros];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(listaLivros == nil){
        return 0;
    }else{
        return listaLivros.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"livro"];
    NSString *tituloLivro;
    NSString *linkFotoLivro;
    
    LivroResponse *livro = [listaLivros objectAtIndex:indexPath.row];
    tituloLivro = livro.titulo;
    linkFotoLivro = livro.foto;
    
    cell.textLabel.text = tituloLivro;
    if([UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:linkFotoLivro]] ]){
        cell.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:linkFotoLivro]] ];
    }else{
        cell.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile: [GLB downloadSavePathFor:linkFotoLivro.lastPathComponent] ]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LivroDetalhesView *livroDetalhesView = [[LivroDetalhesView alloc]init];
    livroDetalhesView.livroResponse = [listaLivros objectAtIndex:indexPath.row];
    livroDetalhesView.registrarDispositivoResponse = registrarDispositivoResponse;
    
    [self.navigationController pushViewController:livroDetalhesView animated:YES];
}

@end
