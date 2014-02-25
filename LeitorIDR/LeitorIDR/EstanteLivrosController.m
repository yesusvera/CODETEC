//
//  EstanteLivrosController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 04/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "EstanteLivrosController.h"
#import "LivroResponse.h"

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
    
    self.nomeEstanteLabel.text = self.nomeEstante;
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
    NSString *textLabelCelula = @"Livro nao encontrado";
    
    if([_nomeEstante isEqualToString:@"Disponíveis"]){
        LivroResponse *livro = [estanteResponse.self.listaDeLivrosParaBaixar objectAtIndex:indexPath.row];
        textLabelCelula = livro.titulo;
    }else if([_nomeEstante isEqualToString:@"Direito de uso"]){
        LivroResponse *livro = [estanteResponse.self.listaDeLivrosDeDireito objectAtIndex:indexPath.row];
        textLabelCelula = livro.titulo;
    }else if([_nomeEstante isEqualToString:@"Minha Biblioteca"]){
        LivroResponse *livro = [estanteResponse.self.listaDeLivrosBaixados objectAtIndex:indexPath.row];
        textLabelCelula = livro.titulo;
    }else{
        textLabelCelula = @"";
    }
    cell.textLabel.text = textLabelCelula;
    
    return cell;

}


//implementando o DELEGATE
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   
//}


@end
