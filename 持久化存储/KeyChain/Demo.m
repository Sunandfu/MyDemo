

/**********************************存储数据***************************************/
// 存储数据
BOOL save = [KeyChainManager keyChainSaveData:@"思念诉说，眼神多像云朵" withIdentifier:Keychain];
if (save) {
    NSLog(@"存储成功");
}else {
    NSLog(@"存储失败");
}
/**********************************获取数据***************************************/
// 获取数据
NSString * readString = [KeyChainManager keyChainReadData:Keychain];
NSLog(@"获取得到的数据:%@",readString);
/**********************************更新数据***************************************/
// 更新数据
BOOL updata = [KeyChainManager keyChainUpdata:@"长发落寞，我期待的女孩" withIdentifier:Keychain];
if (updata) {
    NSLog(@"更新成功");
}else{
    NSLog(@"更新失败");
}
// 读取数据
NSString * readUpdataString = [KeyChainManager keyChainReadData:Keychain];
NSLog(@"获取更新后得到的数据:%@",readUpdataString);
/**********************************删除数据***************************************/
// 删除数据
[KeyChainManager keyChainDelete:Keychain];
// 读取数据
NSString * readDeleteString = [KeyChainManager keyChainReadData:Keychain];
NSLog(@"获取删除后得到的数据:%@",readDeleteString);
/*******************************************************************************/
