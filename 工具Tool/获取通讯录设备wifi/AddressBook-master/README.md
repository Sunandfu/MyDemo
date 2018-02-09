# AddressBook
通讯录获取,获取联系人,联系人,通讯录



[GitHub: https://github.com/Zws-China/AddressBook](https://github.com/Zws-China/AddressBook)  


# How To Use

```ruby

//请求用户获取通讯录权限
[WSAddressBook requestAddressBookAuthorization];

//获取没有经过排序的联系人模型
[WSAddressBook getOriginalAddressBook:^(NSArray<WSPersonModel *> *addressBookArray) {

    NSLog(@"通讯录Model数组为%@",addressBookArray);

} authorizationFailure:^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}];



```