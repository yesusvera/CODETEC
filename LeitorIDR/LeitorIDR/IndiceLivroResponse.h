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
    NSMutableArray *parteA;
    NSMutableArray *parteB;
    NSString *erro;
    NSString *msgErro;
}

@property(nonatomic, retain) NSMutableArray *parteA;
@property(nonatomic, retain) NSMutableArray *parteB;
@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;

@end
