//
//  ListaAnotacoesViewController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 22/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "ListaAnotacoesViewController.h"
#import "Nota.h"
#import "NotasDAO.h"
#import "AnotacoesViewController.h"

@interface ListaAnotacoesViewController ()

@end

@implementation ListaAnotacoesViewController
@synthesize listaAnotacoes, livro;

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
    
    NotasDAO *notasDAO = [[NotasDAO alloc]init];
    listaAnotacoes = [notasDAO listaNotasPorCodLivro:livro.codigolivro];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listaAnotacoes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lista"];
    
    Nota *nota = [listaAnotacoes objectAtIndex:indexPath.row];
    cell.textLabel.text = nota.titulo;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnotacoesViewController *anotacoesViewController = [[AnotacoesViewController alloc] init];
    
    anotacoesViewController.nota = [listaAnotacoes objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:anotacoesViewController animated:YES];
}


@end
