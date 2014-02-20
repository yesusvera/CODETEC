//
//  DeDireitoResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeDireitoResponse : NSObject{
    LivroResponse *livroDeDireito;
}
@property (nonatomic,retain) LivroResponse *livroDeDireito;

@end
