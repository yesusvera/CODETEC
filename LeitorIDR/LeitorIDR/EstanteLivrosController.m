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

@interface EstanteLivrosController ()

@end

@implementation EstanteLivrosController
@synthesize estanteResponse;

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


//IMPLEMENTANDO O DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //estantes = @[@"Visão Geral", @"Disponíveis", @"Direito de uso", @"Minha Biblioteca"];
    if([_nomeEstante isEqualToString:@"Disponíveis"]){
        return estanteResponse.self.listaDeLivrosParaBaixar.count;
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        return estanteResponse.self.listaDeLivrosDeDireito.count;
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        return estanteResponse.self.listaDeLivrosBaixados.count;
    }else{
        return estanteResponse.self.listaDeLivrosParaBaixar.count + estanteResponse.self.listaDeLivrosDeDireito.count + estanteResponse.self.listaDeLivrosBaixados.count;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"livro"];
    NSString *tituloLivro;
    NSString *linkFotoLivro;
    
    if([_nomeEstante isEqualToString:@"Disponíveis"]){
        LivroResponse *livro = [estanteResponse.self.listaDeLivrosParaBaixar objectAtIndex:indexPath.row];
        [estanteResponse.listaDeLivros addObject:livro];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        LivroResponse *livro = [estanteResponse.self.listaDeLivrosDeDireito objectAtIndex:indexPath.row];
        [estanteResponse.listaDeLivros addObject:livro];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        LivroResponse *livro = [estanteResponse.self.listaDeLivrosBaixados objectAtIndex:indexPath.row];
        [estanteResponse.listaDeLivros addObject:livro];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }else{
        LivroResponse *livro = [estanteResponse.self.listaDeLivros objectAtIndex:indexPath.row];
        tituloLivro = livro.titulo;
        linkFotoLivro = livro.foto;
    }
    cell.textLabel.text = tituloLivro;
    if([UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:linkFotoLivro]] ]){
        cell.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:linkFotoLivro]] ];
    }else{
        cell.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile: [self downloadSavePathFor:linkFotoLivro.lastPathComponent] ]];
    }
    return cell;

}


//implementando o DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LivroResponse *livro;

    if([_nomeEstante isEqualToString:@"Disponíveis"]){
        livro = [estanteResponse.self.listaDeLivrosParaBaixar objectAtIndex:indexPath.row];
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
         livro = [estanteResponse.self.listaDeLivrosDeDireito objectAtIndex:indexPath.row];
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
         livro = [estanteResponse.self.listaDeLivrosBaixados objectAtIndex:indexPath.row];
    }else{
        livro =[estanteResponse.self.listaDeLivros objectAtIndex:indexPath.row];
    }
    
    LivroDetalhesView *livroDetalhesView = [[LivroDetalhesView alloc]init];
    livroDetalhesView.livroResponse = livro;
    livroDetalhesView.registroDispositivoResponse = self.registrarDispositivoResponse;
    
    
    [self.navigationController pushViewController:livroDetalhesView animated:YES];
}

-(NSString *) downloadSavePathFor:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:filename];
}


@end
