//
//  LSYAlbumCatalog.m
//  AlbumPicker
//
//  Created by okwei on 15/7/24.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAlbumCatalog.h"
#import "LSYDelegateDataSource.h"
#import "LSYAlbumPicker.h"
@interface LSYAlbumCatalog ()<UITableViewDelegate,LSYAlbumPickerDelegate>
@property (nonatomic,strong) UITableView *albumTabView;
@property (nonatomic,strong) LSYDelegateDataSource *albumDelegateDataSource;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation LSYAlbumCatalog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"照片";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.albumTabView];
    [[LSYAlbum sharedAlbum] setupAlbumGroups:^(NSMutableArray *groups) {
        self.dataArray = groups;
        self.albumDelegateDataSource.albumCatalogDataArray = groups;
        [self.albumTabView reloadData];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backMainView)];
    
}
-(void)backMainView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(UITableView *)albumTabView
{
    if (!_albumTabView) {
        _albumTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, ViewSize(self.view).width, ViewSize(self.view).height-15) style:UITableViewStylePlain];
        _albumTabView.delegate = self;
        _albumTabView.dataSource = self.albumDelegateDataSource;
        _albumTabView.rowHeight = 70;
        _albumTabView.tableFooterView = [[UIView alloc] init];
    }
    return _albumTabView;
}
-(LSYDelegateDataSource *)albumDelegateDataSource
{
    if (!_albumDelegateDataSource) {
        _albumDelegateDataSource = [[LSYDelegateDataSource alloc] init];
    }
    return _albumDelegateDataSource;
}
#pragma mark -LSYAlbumPickerDelegate
-(void)AlbumPickerDidFinishPick:(NSArray *)assets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumDidFinishPick:)]) {
        [self.delegate AlbumDidFinishPick:assets];
        [self backMainView];
    }
}
#pragma mark -UITabViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSYAlbumPicker *albumPicker = [[LSYAlbumPicker alloc] init];
    albumPicker.group = self.dataArray[indexPath.row];
    albumPicker.delegate = self;
    if (self.maximumNumberOfSelectionPhoto) {
        albumPicker.maxminumNumber = self.maximumNumberOfSelectionPhoto;
    }else if(self.maximumNumberOfSelectionMedia){
        albumPicker.maxminumNumber = self.maximumNumberOfSelectionMedia;
    }
    [self.navigationController pushViewController:albumPicker animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)setMaximumNumberOfSelectionMedia:(NSInteger)maximumNumberOfSelectionMedia
{
    _maximumNumberOfSelectionMedia = maximumNumberOfSelectionMedia;
    [LSYAlbum sharedAlbum].assstsFilter = [ALAssetsFilter allAssets];
}
-(void)setMaximumNumberOfSelectionPhoto:(NSInteger)maximumNumberOfSelectionPhoto
{
    _maximumNumberOfSelectionPhoto = maximumNumberOfSelectionPhoto;
    [LSYAlbum sharedAlbum].assstsFilter = [ALAssetsFilter allPhotos];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
