//
//  PerguntaListas.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "PerguntaListas.h"

@interface PerguntaListas ()

@end

@implementation PerguntaListas

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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    LivroDetalhesView *livroDetalhesView = [[LivroDetalhesView alloc]init];
//    livroDetalhesView.livroResponse = [listaLivros objectAtIndex:indexPath.row];
//    livroDetalhesView.registrarDispositivoResponse = registrarDispositivoResponse;
//    
//    [self.navigationController pushViewController:livroDetalhesView animated:YES];
}


@end
