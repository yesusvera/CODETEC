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
@synthesize detalheIndice,viewLivro;

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
    if ([[detalheIndice objectAtIndex:indexPath.row] listaItens]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = itemIndice.capitulo;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[detalheIndice objectAtIndex:indexPath.row] listaItens]){
        DetalheIndiceViewController *detalhesFilho = [[DetalheIndiceViewController alloc]init];
        detalhesFilho.detalheIndice = [[detalheIndice objectAtIndex:indexPath.row] listaItens];
        detalhesFilho.viewLivro     = self.viewLivro;
        [self.navigationController pushViewController:detalhesFilho animated:YES];
    }else{
        
        RDPDFViewController *m_pdf = self.viewLivro;
        if( m_pdf == nil )
        {
            m_pdf = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController"bundle:nil];
        }
        
        NSString *documentName = [m_pdf.livro.arquivomobile.lastPathComponent stringByRemovingPercentEncoding];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];
        
        NSLog(@"Abrindo o arquivo: %@",fullPath);
        
        int result = [m_pdf PDFOpen: fullPath:@"ibracon%2014"];
        
        if(result == 1)
        {
            UINavigationController *nav = self.navigationController;
            m_pdf.hidesBottomBarWhenPushed = YES;
            int pageno = [[detalheIndice objectAtIndex:indexPath.row] paginareal].intValue - 1;
            
            [m_pdf PDFGoto:pageno];
            [nav popToViewController:m_pdf animated:YES];
            [m_pdf PDFThumbNailinit:pageno];
            
        }
    }
}

@end
