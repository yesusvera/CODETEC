//
//  IndiceViewController.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 22/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndiceLivroResponse.h"
#import "LivroResponse.h"
#import "RDPDFViewController.h"

@interface IndiceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IndiceLivroResponse *indiceDoLivro;
}

@property (nonatomic, retain) IndiceLivroResponse *indiceDoLivro;
@property (nonatomic, retain) LivroResponse *livro;
@property (nonatomic, retain) RDPDFViewController *viewLivro;

@end
