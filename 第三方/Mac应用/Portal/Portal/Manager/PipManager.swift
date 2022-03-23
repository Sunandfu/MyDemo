//
//  PipManager.swift
//  Portal
//
//  Created by wang ya on 2020/6/3.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa
import WebKit

class PipManager: NSObject {
    private static var bilibiliPipScript: String {
        return "var theater = document.querySelector(\".player-wrap\");"
            + "var isTheater = theater ? theater.style.height !== \"auto\" : true;"
            + "if (!isTheater && document.querySelector(\".bilibili-player-video-btn-widescreen\")) {document.querySelector(\".bilibili-player-video-btn-widescreen\").click();};"
            + "var wrapper = document.querySelector(\".bilibili-player-video-wrap\");"
            + "if (document.querySelector(\"#player_module\") && !document.querySelector(\".plp-l\")) {"
            + "document.querySelector(\"#player_module\").style.width = \"100%\";"
            + "document.querySelector(\"#player_module\").style.height = \"100%\";"
            + "document.querySelector(\"#player_module\").style.position = \"fixed\";"
            + "document.querySelector(\".media-wrapper\").style.display = \"none\";"
            + "document.querySelector(\".plp-r\").style.display = \"none\";"
            + "Object.defineProperty(document.querySelector(\"#player_module\").style, \"width\", {get: function(){return  \"100%\"}, set: function(){}});"
            + "Object.defineProperty(document.querySelector(\"#player_module\").style, \"height\", {get: function(){return  \"100%\"}, set: function(){}});"
            + "}"
            + "wrapper.style.position = \"fixed\";"
            + "wrapper.style.left=\"0\";"
            + "wrapper.style.top=\"0\";"
            + "wrapper.style.zIndex = \"9999\";"
            + "wrapper.style.width=\"100%\";"
            + "wrapper.style.height=\"100%\";"
            + "document.body.style.overflow = \"hidden\";"
            + "document.querySelector(\".bili-header-m\").style.display = \"none\";"
    }

    public static func makePip(for webView: WKWebView) {
        var pipScript: String?

        if let urlString = webView.url?.absoluteString {
            if urlString.contains("bilibili") {
                pipScript = bilibiliPipScript
            }
        }

        guard let script = pipScript else { return }

        webView.evaluateJavaScript(script) { (obj, error) in

        }
    }

}
