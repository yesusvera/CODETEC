//
//  EstanteLivrosController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 04/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarLivroResponse.h"


@interface EstanteLivrosController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nomeEstanteLabel;
@property (nonatomic, retain) NSString *nomeEstante;
@property (nonatomic, retain) RegistrarLivroResponse *registrarLivroResponse;
@end
