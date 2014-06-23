//
//  ListaAnotacoesViewController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 22/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivroResponse.h"

@interface ListaAnotacoesViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *listaAnotacoes;
@property (nonatomic, retain) LivroResponse *livro;


@end
