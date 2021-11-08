# !/bin/bash

app_name="QQ"
framework_name="libQQRedPackHelper"
app_extra_name="libsubstitute"
app_bundle_path="/Applications/${app_name}.app/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.dylib"
extra_path="${app_bundle_path}/${app_extra_name}.dylib"
# 备份QQ原始可执行文件
if [ -f "$app_executable_backup_path" ]
then
rm "$app_executable_path"
rm -rf "$framework_path"
rm -rf "$extra_path"
mv "$app_executable_backup_path" "$app_executable_path"
echo "\n\t卸载成功"
else
echo "\n\t未发现QQ红包助手"
fi
