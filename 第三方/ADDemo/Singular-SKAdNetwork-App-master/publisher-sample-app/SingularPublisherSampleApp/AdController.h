//
//  AdController.h
//  SingularPublisherSampleApp
//
//  Created by Eyal Rabinovich on 24/06/2020.
//

#import <UIKit/UIKit.h>

//重要提示：不要忘记导入“SKStoreProductViewController”标题
#import <StoreKit/SKStoreProductViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdController : SKStoreProductViewController {
    NSDictionary* productParameters;
}

- (id)initWithProductParameters:(NSDictionary*)productParameters;
@end

NS_ASSUME_NONNULL_END
