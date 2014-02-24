//
//  LivroResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivroResponse : NSObject{
    NSString *codigolivro;
    NSString *titulo;
    NSString *versao;
    NSString *codigoloja;
    NSString *foto;
    NSString *arquivo;
}

@property(nonatomic, retain) NSString *codigolivro;
@property(nonatomic, retain) NSString *titulo;
@property(nonatomic, retain) NSString *versao;
@property(nonatomic, retain) NSString *codigoloja;
@property(nonatomic, retain) NSString *foto;
@property(nonatomic, retain) NSString *arquivo;

@end
