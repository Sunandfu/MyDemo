//
//  QQHelperDependent.h
//  QQRedPackHelper
//
//  Created by tangxianhai on 2018/3/8.
//  Copyright © 2018年 tangxianhai. All rights reserved.
//

#ifndef QQHelperDependent_h
#define QQHelperDependent_h

@interface QQMessageRevokeEngine: NSObject
- (id)getProcessor;
@end

@interface RecallProcessor : NSObject
- (id)getRecallMessageContent:(void *)arg1; // (struct RecallModel *)arg1
@end

#endif /* QQHelperDependent_h */
