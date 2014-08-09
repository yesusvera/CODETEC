//
//  IndiceLivroResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivroResponse.h"

@interface IndiceLivroResponse : NSObject{
    NSMutableArray *indice;
    NSString *erro;
    NSString *msgErro;
}

@property(nonatomic, retain) NSMutableArray *indice;
@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;

@end
