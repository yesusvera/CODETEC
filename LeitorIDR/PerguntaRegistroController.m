//
//  PerguntaRegistroController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "PerguntaRegistroController.h"
#import "RegistroNaoAssociadoController.h"
#import "RegistroAssociadoController.h"


@interface PerguntaRegistroController ()

@end

@implementation PerguntaRegistroController

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
    self.title = @"IDR - Ibracon";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)redirecionaAssociado:(id)sender {
    RegistroAssociadoController *r = [[RegistroAssociadoController alloc] init];
    [self.navigationController pushViewController:r animated:YES];
}


- (IBAction)redirecionaNaoAssociado:(id)sender {
    RegistroNaoAssociadoController *r = [[RegistroNaoAssociadoController alloc] init];
    [self.navigationController pushViewController:r animated:YES];
    
}

@end
