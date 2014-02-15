//
//  EstantesController.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrarLivroResponse.h"


@interface EstantesController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *estantes;
}

@property (nonatomic, retain) RegistrarLivroResponse *registrarLivroResponse;

@end
