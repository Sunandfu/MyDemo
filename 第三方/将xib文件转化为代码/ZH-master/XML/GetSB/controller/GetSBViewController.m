#import "GetSBViewController.h"

#import "GetSBTableViewCell.h"
#import "GetXIBTableViewCell.h"

#import "TabBarAndNavagation.h"

#import "ZHFileManager.h"

#import "MBProgressHUD.h"

@interface GetSBViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;

@property (nonatomic,strong)NSMutableArray *recordArr;

@property (nonatomic,strong)NSTimer *timer;

@end


@implementation GetSBViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}
- (void)viewDidLoad{
	[super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
    self.tableView.tableFooterView=[UIView new];
	self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [TabBarAndNavagation setTitleColor:[UIColor blackColor] forNavagationBar:self];
    self.title=@"SB XIB 生成Masonry";
    
    [self loadData];
    
    [self.timer fire];
}

- (void)loadData{
    
    NSString *mainPath=[ZHFileManager getMacHomeDirectorInIOS];
    mainPath=[mainPath stringByAppendingPathComponent:@"Desktop"];
    
    if ([ZHFileManager fileExistsAtPath:mainPath]==NO) {
        return;
    }
    
    NSArray *filesArr=[ZHFileManager contentsOfDirectoryAtPath:mainPath];
    
    NSMutableArray *filesXIB=[NSMutableArray array];
    NSMutableArray *filesSB=[NSMutableArray array];
    
    NSMutableArray *recoderArrM=[NSMutableArray array];
    
    for (NSString *filePath in filesArr) {
        if ([filePath hasSuffix:@".xib"]) {
            GetXIBCellModel *GetXIBModel=[GetXIBCellModel new];
            [recoderArrM addObject:filePath];
            GetXIBModel.title=filePath;
            GetXIBModel.filePath=[mainPath stringByAppendingPathComponent:filePath];
            GetXIBModel.iconImageName=@"xib.png";
            [filesXIB addObject:GetXIBModel];
        }else if ([filePath hasSuffix:@"storyboard"]){
            GetSBCellModel *GetSBModel=[GetSBCellModel new];
            GetSBModel.filePath=[mainPath stringByAppendingPathComponent:filePath];
            GetSBModel.title=filePath;
            [recoderArrM addObject:filePath];
            GetSBModel.iconImageName=@"sb.png";
            [filesSB addObject:GetSBModel];
        }
    }
    
    if ([recoderArrM isEqualToArray:self.recordArr]) {
        return;
    }else{
        self.recordArr=recoderArrM;
    }
    
    if (filesSB.count==0&&filesXIB.count==0) {
        self.promoteLabel.text=@"桌面上没有StroyBoard 和xib 文件";
        self.promoteLabel.backgroundColor=[UIColor redColor];
    }else{
        self.promoteLabel.text=@"数据来源于桌面,StroyBoard 和xib 文件";
        self.promoteLabel.backgroundColor=[UIColor grayColor];
    }
    
    if (filesSB.count==0) {
        GetSBCellModel *GetSBModel=[GetSBCellModel new];
        GetSBModel.title=@"桌面无StroyBoard文件";
        GetSBModel.iconImageName=@"sb.png";
        GetSBModel.noFile=YES;
        [filesSB addObject:GetSBModel];
    }
    if (filesXIB.count==0) {
        GetXIBCellModel *GetXIBModel=[GetXIBCellModel new];
        GetXIBModel.title=@"桌面无Xib文件";
        GetXIBModel.iconImageName=@"xib.png";
        GetXIBModel.noFile=YES;
        [filesXIB addObject:GetXIBModel];
    }
    
    [self.dataArr removeAllObjects];
    
    [self.dataArr addObject:filesSB];
    [self.dataArr addObject:filesXIB];
    
    [self.tableView reloadData];
}
#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.dataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.section][indexPath.row];
	if ([modelObjct isKindOfClass:[GetSBCellModel class]]){
		GetSBTableViewCell *GetSBCell=[tableView dequeueReusableCellWithIdentifier:@"GetSBTableViewCell"];
		GetSBCellModel *model=modelObjct;
		[GetSBCell refreshUI:model];
		return GetSBCell;
	}
	if ([modelObjct isKindOfClass:[GetXIBCellModel class]]){
		GetXIBTableViewCell *GetXIBCell=[tableView dequeueReusableCellWithIdentifier:@"GetXIBTableViewCell"];
		GetXIBCellModel *model=modelObjct;
		[GetXIBCell refreshUI:model];
		return GetXIBCell;
	}
	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"选择了某一行");
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"storyboard";
    }else if (section==1){
        return @"xib";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
@end