# 定义安装目录位置的变量
qqsh_path='sh /Applications/QQ.app/Contents/MacOS/injectionQQ.sh'
# 定义要在profile中搜索的行
new_alias1="alias qq='$qqsh_path'"
new_alias2="alias QQ='$qqsh_path'"
# 将搜索行中转为正则表达式
reg_str="^\s*alias\s*QQ='$qqsh_path'"
# 先用grep查找profile是否已经有了指定的语句，如果有，则就不需要再添加了
if grep -q $reg_str /etc/profile
then
echo "\033[34m 1. 已存在别名无需再次添加 \033[0m"
echo "\033[34m 2. 重新打开控制台--------然后输入QQ或qq直接运行应用程序 \033[0m"
echo "\033[34m 3. 此种方式运行注入后的QQ没有改QQ的签名校验，所以运行后不会出现签名版和未签名版消息历史记录不一致和本地保存的自定义表情不一致问题！ \033[0m"
else
    # 直接在profile末尾添加新行
    echo ${new_alias1} >> /etc/profile
    echo ${new_alias2} >> /etc/profile
    open /etc/profile
    echo "\033[34m 1. 恭喜配置写入/etc/profile成功 \033[0m"
    echo "\033[34m 2. 重新打开控制台--------然后输入QQ或qq直接运行应用程序 \033[0m"
    echo "\033[34m 3. 此种方式运行注入后的QQ没有改QQ的签名校验，所以运行后不会出现签名版和未签名版消息历史记录不一致和本地保存的自定义表情不一致问题！ \033[0m"
fi