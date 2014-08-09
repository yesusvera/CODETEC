//
//  PerguntaListas.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "PerguntaListas.h"
#import "MontadorDeIncideDoLivro.h"
#import "DetalheIndiceViewController.h"
#import "ListaAnotacoesViewController.h"
@interface PerguntaListas ()

@end

@implementation PerguntaListas
@synthesize livro;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lista"];

    if(indexPath.row == 0){
        cell.textLabel.text = @"Índice...";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"Anotações...";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        MontadorDeIncideDoLivro *montadorIndice = [[MontadorDeIncideDoLivro alloc]init];

        
        DetalheIndiceViewController *detalheIndice = [[DetalheIndiceViewController alloc]init];
        
        
        detalheIndice.livro = livro;
        [detalheIndice setIndiceDoLivro:[montadorIndice montarIndiceDoLivro:livro.indiceXML]];
        
        detalheIndice.detalheIndice = detalheIndice.indiceDoLivro.indice;
        
        detalheIndice.viewLivro = self.viewLivro;
        
        [self.navigationController pushViewController:detalheIndice animated:YES];
        
        
        

        
    }else if (indexPath.row == 1){
        ListaAnotacoesViewController *listaAnotacoesViewController = [[ListaAnotacoesViewController alloc]init];
        listaAnotacoesViewController.livro = livro;
        listaAnotacoesViewController.viewLivro = self.viewLivro;
        [self.navigationController pushViewController:listaAnotacoesViewController animated:YES];
    }

}


@end
