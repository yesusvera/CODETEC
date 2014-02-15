//
//  EstantesController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "EstantesController.h"
#import "EstanteLivrosController.h"

@interface EstantesController ()

@end

@implementation EstantesController


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EstanteLivrosController *estanteLivros = [[EstanteLivrosController alloc]init];
    estanteLivros.nomeEstante = [estantes objectAtIndex:indexPath.row];
    [estanteLivros setRegistrarLivroResponse:self.registrarLivroResponse];
    [self.navigationController pushViewController:estanteLivros animated:YES];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
