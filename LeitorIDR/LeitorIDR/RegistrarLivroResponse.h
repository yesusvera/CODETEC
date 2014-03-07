//
//  RegistrarLivroResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 06/03/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrarLivroResponse : NSObject{
    NSString *codLivro;
    NSString *status;
    NSString *erro;
    NSString *msgErro;
}

@property(nonatomic, retain) NSString *codLivro;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *erro;
@property(nonatomic, retain) NSString *msgErro;

@end
