#import "GetXIBTableViewCell.h"
#import "UIView+ZHView.h"

#import "ZHStoryboardManager.h"

#import "MBProgressHUD.h"

@interface GetXIBTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *creatCodeButton;
@property (nonatomic,weak)GetXIBCellModel *dataModel;
@end

@implementation GetXIBTableViewCell


- (void)refreshUI:(GetXIBCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
	self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];
    
    self.creatCodeButton.hidden=dataModel.noFile;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconImageView cornerRadiusWithFloat:20];
    
    self.creatCodeButton.titleLabel.numberOfLines=0;
    self.creatCodeButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.creatCodeButton.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.5];
    [self.creatCodeButton setTintColor:[UIColor whiteColor]];
    [self.creatCodeButton cornerRadiusWithFloat:10];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.creatCodeButton addTarget:self action:@selector(creatCodeAction) forControlEvents:1<<6];
}

- (void)creatCodeAction{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[self getViewController].view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在生成代码!";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 处理耗时操作的代码块...
        ZHStoryboardManager *manager=[ZHStoryboardManager new];
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:self.dataModel.filePath]==NO) {
            hud.labelText =@"路径不存在";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:[self getViewController].view animated:YES];
            });
            return ;
        }
        
        [manager Xib_To_Masonry:self.dataModel.filePath];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.labelText=@"生成成功";
            //回调或者说是通知主线程刷新，
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:[self getViewController].view animated:YES];
            });
        });
        
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

@end
