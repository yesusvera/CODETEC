//
//  IndiceViewController.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 22/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "IndiceViewController.h"
#import "DetalheIndiceViewController.h"

@interface IndiceViewController ()

@end

@implementation IndiceViewController
@synthesize indiceDoLivro, livro;

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
    
    self.title= @"Indice";
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
        cell.textLabel.text = @"Parte A";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"Parte B";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetalheIndiceViewController *detalhesIndice = [[DetalheIndiceViewController alloc]init];
    detalhesIndice.viewLivro = self.viewLivro;
    
    if (indexPath.row == 0) {
        detalhesIndice.detalheIndice = indiceDoLivro.parteA;
        [self.navigationController pushViewController:detalhesIndice animated:YES];
        
    }else if (indexPath.row == 1){
        detalhesIndice.detalheIndice = indiceDoLivro.parteB;
        [self.navigationController pushViewController:detalhesIndice animated:YES];
    }
    
}



@end
