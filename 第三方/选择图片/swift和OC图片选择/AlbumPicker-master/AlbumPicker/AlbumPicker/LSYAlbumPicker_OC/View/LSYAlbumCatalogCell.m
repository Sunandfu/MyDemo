//
//  LSYAlbumCatalogCell.m
//  AlbumPicker
//
//  Created by okwei on 15/7/24.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAlbumCatalogCell.h"
@interface LSYAlbumCatalogCell ()

@end
@implementation LSYAlbumCatalogCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)setGroup:(ALAssetsGroup *)group
{
    _group = group;
    self.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    [self setupGroupTitle];
    
}
-(void)setupGroupTitle
{
    NSDictionary *groupTitleAttribute = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    NSDictionary *numberOfAssetsAttribute = @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
    NSString *groupTitle = [_group valueForProperty:ALAssetsGroupPropertyName];
    long numberOfAssets = _group.numberOfAssets;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%ld）",groupTitle,numberOfAssets] attributes:numberOfAssetsAttribute];
    [attributedString addAttributes:groupTitleAttribute range:NSMakeRange(0, groupTitle.length)];
    [self.textLabel setAttributedText:attributedString];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
