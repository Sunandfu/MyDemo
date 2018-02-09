function hello(){
    alert("hello");
}

function callNativeApp() {
    try {
        webkit.messageHandlers.callbackHandler.postMessage({"av":"jd"});
        //webkit.messageHandlers.callbackHandler.postMessage('字符串参数');
    } catch(err) {
        console.log('The native context does not exist yet');
    }
}

function redHeader(text) {
    
    document.querySelector('h1').style.color = text;
    return "颜色改变成功";
}