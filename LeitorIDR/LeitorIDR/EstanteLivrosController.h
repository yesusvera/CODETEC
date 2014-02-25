//
//  EstanteLivrosController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 04/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarLivroResposta.h"
#import "EstanteResponse.h"


@interface EstanteLivrosController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
      EstanteResponse *estanteResponse;
} 

@property (weak, nonatomic) IBOutlet UILabel *nomeEstanteLabel;
@property (nonatomic, retain) NSString *nomeEstante;
@property (nonatomic, retain) RegistrarLivroResposta *registrarLivroResponse;
@property (nonatomic, retain) EstanteResponse *estanteResponse;

@end
