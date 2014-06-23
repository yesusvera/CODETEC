//
//  DetalheIndiceViewController.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 22/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "DetalheIndiceViewController.h"
#import "ItemDoIndice.h"

@interface DetalheIndiceViewController ()

@end

@implementation DetalheIndiceViewController{
    
}
@synthesize detalheIndice;

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
    self.title = @"Indice";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(detalheIndice == nil){
        return 0;
    }else{
        return detalheIndice.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
    ItemDoIndice *itemIndice = [detalheIndice objectAtIndex:indexPath.row];

    cell.textLabel.text = itemIndice.capitulo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[detalheIndice objectAtIndex:indexPath.row] listaItens]){
        DetalheIndiceViewController *detalhesFilho = [[DetalheIndiceViewController alloc]init];
        detalhesFilho.detalheIndice = [[detalheIndice objectAtIndex:indexPath.row] listaItens];
        [self.navigationController pushViewController:detalhesFilho animated:YES];
    }else{
        
    }

}

@end
