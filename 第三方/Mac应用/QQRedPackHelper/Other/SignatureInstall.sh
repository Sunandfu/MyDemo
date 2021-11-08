app_name="QQ"
qq_path="/Applications/QQ.app"
shell_path="$(dirname "$0")"
dylib_path="${shell_path}/Products/libQQRedPackHelper.dylib"
tool_lib_path="${shell_path}/Tools/libsubstitute.dylib"
app_bundle_path="/Applications/QQ.app/Contents/MacOS"
cp ${dylib_path} ${app_bundle_path}
cp ${tool_lib_path} ${app_bundle_path}
cp "${shell_path}/Tools/injectionQQ.sh" ${app_bundle_path}
sh ${shell_path}/Tools/install.sh