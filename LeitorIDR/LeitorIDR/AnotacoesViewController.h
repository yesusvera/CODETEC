//
//  AnotacoesViewController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nota.h"
#import "NotasDAO.h"


@interface AnotacoesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTituloPagina;
@property (weak, nonatomic) IBOutlet UITextField *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtNota;
@property (weak, nonatomic) IBOutlet UIButton *salvarNota;
- (IBAction)salvarAnotacao:(id)sender;

@property (nonatomic, retain) Nota *nota;
@property (nonatomic, retain) NotasDAO *notasDAO;

@end
