//
//  ObterEstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParaBaixarResponse.h"
#import "BaixadosResponse.h"   
#import "DeDireitoResponse.h"

@interface ObterEstanteResponse : NSObject{
    ParaBaixarResponse *paraBaixar;
    BaixadosResponse *baixados;
    DeDireitoResponse *deDireito;
}
@property(nonatomic, retain) ParaBaixarResponse *paraBaixar;
@property(nonatomic, retain) BaixadosResponse *baixados;
@property(nonatomic, retain) DeDireitoResponse *deDireito;
@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;

@end
