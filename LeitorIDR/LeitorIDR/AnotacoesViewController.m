//
//  AnotacoesViewController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "AnotacoesViewController.h"
#import "NotasDAO.h"
#import "Nota.h"

@interface AnotacoesViewController ()


@end

@implementation AnotacoesViewController
@synthesize nota,notasDAO;

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
    
    self.lblTituloPagina.text =[NSString stringWithFormat:@"Anotação página %@", nota.pagina];
    
    notasDAO =[[NotasDAO alloc] init];
    Nota *notaTmp = [notasDAO pesquisarNotaPorPagina:nota.pagina eCodigoDoLivro:nota.pagina];
    
    if(notaTmp!=nil){
        nota = notaTmp;
    }
    
    self.txtTitulo.text = nota.titulo;
    self.txtNota.text = nota.nota;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)salvarAnotacao:(id)sender {
    nota.titulo = self.txtTitulo.text;
    nota.nota = self.txtNota.text;
    
    [notasDAO salvarAtualizarNota:nota];
}
@end
