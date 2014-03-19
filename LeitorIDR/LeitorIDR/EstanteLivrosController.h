//
//  EstanteLivrosController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 04/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarDispositivoResponse.h"
#import "EstanteResponse.h"


@interface EstanteLivrosController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nomeEstanteLabel;
@property (nonatomic, retain) NSString *nomeEstante;
@property (nonatomic, retain) RegistrarDispositivoResponse *registrarDispositivoResponse;
@property (nonatomic, retain) EstanteResponse *estanteResponse;

@end
