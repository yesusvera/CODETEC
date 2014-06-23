//
//  PerguntaListas.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 21/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivroResponse.h"
#import "RDPDFViewController.h"

@interface PerguntaListas : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) LivroResponse *livro;
@property (nonatomic, retain) RDPDFViewController *viewLivro;

@end
