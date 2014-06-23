//
//  DetalheIndiceViewController.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 22/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPDFViewController.h"

@interface DetalheIndiceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *detalheIndice;
}

@property (nonatomic, retain) NSMutableArray *detalheIndice;
@property (nonatomic, retain) RDPDFViewController *viewLivro;

@end
