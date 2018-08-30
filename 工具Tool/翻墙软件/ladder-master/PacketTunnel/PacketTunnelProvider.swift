//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Aofei Sheng. All rights reserved.
//

import Alamofire
import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    var shadowsocks: Shadowsocks?
    
    override func startTunnel(options _: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        guard let providerConfiguration = (self.protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration,
            let generalHideVPNIcon = providerConfiguration["general_hide_vpn_icon"] as? Bool,
            let generalPACURL = URL(string: (providerConfiguration["general_pac_url"] as? String) ?? ""),
            let generalPAC = providerConfiguration["general_pac"] as? String,
            let generalPACMaxAge = providerConfiguration["general_pac_max_age"] as? TimeInterval,
            let shadowsocksServerAddress = providerConfiguration["shadowsocks_server_address"] as? String,
            let shadowsocksServerPort = providerConfiguration["shadowsocks_server_port"] as? UInt16,
            let shadowsocksLocalAddress = providerConfiguration["shadowsocks_local_address"] as? String,
            let shadowsocksLocalPort = providerConfiguration["shadowsocks_local_port"] as? UInt16,
            let shadowsocksPassword = providerConfiguration["shadowsocks_password"] as? String,
            let shadowsocksMethod = providerConfiguration["shadowsocks_method"] as? String else {
                completionHandler(nil)
                return
        }
        
        let proxySettings = NEProxySettings()
        proxySettings.autoProxyConfigurationEnabled = true
        if generalPACMaxAge == 0 {
            proxySettings.proxyAutoConfigurationURL = generalPACURL
        } else {
            proxySettings.proxyAutoConfigurationJavaScript = generalPAC
        }
        proxySettings.excludeSimpleHostnames = true
        proxySettings.matchDomains = [""]
        
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        networkSettings.proxySettings = proxySettings
        networkSettings.ipv4Settings = NEIPv4Settings(addresses: [generalHideVPNIcon ? "0.0.0.0" : "10.0.0.1"], subnetMasks: ["255.0.0.0"])
        networkSettings.mtu = 1500
        
        setTunnelNetworkSettings(networkSettings) { error in
            if error == nil && self.shadowsocks == nil {
                do {
                    self.shadowsocks = Shadowsocks(
                        serverAddress: shadowsocksServerAddress,
                        serverPort: shadowsocksServerPort,
                        localAddress: shadowsocksLocalAddress,
                        localPort: shadowsocksLocalPort,
                        password: shadowsocksPassword,
                        method: shadowsocksMethod
                    )
                    try self.shadowsocks?.start()
                } catch let error {
                    completionHandler(error)
                    return
                }
                
                if generalPACMaxAge > 0 {
                    self.updatePACPeriodically()
                }
            }
            completionHandler(error)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        if reason != .none {
            shadowsocks?.stop()
        }
        completionHandler()
    }
    
    func updatePACPeriodically() {
        guard var providerConfiguration = (self.protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration,
            let generalPACURL = URL(string: (providerConfiguration["general_pac_url"] as? String) ?? ""),
            let generalPAC = providerConfiguration["general_pac"] as? String,
            let generalPACMaxAge = providerConfiguration["general_pac_max_age"] as? TimeInterval else {
                return
        }
        
        Alamofire.request(generalPACURL).responseString { response in
            if response.response?.statusCode == 200, let pac = response.value, pac != generalPAC {
                providerConfiguration["general_pac"] = pac
                
                self.stopTunnel(with: .none) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.startTunnel(options: nil) { _ in }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + generalPACMaxAge) {
                self.updatePACPeriodically()
            }
        }
    }
}
