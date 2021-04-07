
#import <UIKit/UIKit.h>

@interface PagingEngine : NSObject
/**
 *  文本分割
 *
 *  @param contentString 需要分割的文本内容
 *  @param contentSize   每个页面的大小
 *  @param textAttribute 文本的格式属性
 *
 *  @return 分割之后的文本数组
 */

+ (NSArray *)pagingwithContentString:(NSString *)contentString contentSize:(CGSize)contentSize textAttribute:(NSDictionary *)textAttribute;

+ (NSArray *)coreTextPaging:(NSAttributedString *)str textFrame:(CGRect)textFrame;

@end
