//
//  ViewController.swift
//  Ladder
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Aofei Sheng. All rights reserved.
//

import Alamofire
import Eureka
import KeychainAccess
import NetworkExtension
import SafariServices

class ViewController: FormViewController {
    let mainKeychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Ladder", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icons/Info"), style: .plain, target: self, action: #selector(openPost))
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 80 / 255, green: 140 / 255, blue: 240 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        form
            +++ Section(header: NSLocalizedString("General", comment: ""), footer: "") { section in
                section.tag = "General"
                section.header?.height = { 30 }
                section.footer?.height = { .leastNonzeroMagnitude }
            }
            <<< SwitchRow { row in
                row.tag = "General - Hide VPN Icon"
                row.title = NSLocalizedString("Hide VPN Icon", comment: "")
                row.value = mainKeychain["general_hide_vpn_icon"] == "true"
            }
            <<< URLRow { row in
                row.tag = "General - PAC URL"
                row.title = "PAC URL"
                row.placeholder = NSLocalizedString("Enter PAC URL here", comment: "")
                row.value = URL(string: mainKeychain["general_pac_url"] ?? "https://aofei.org/pac?proxies=SOCKS5+127.0.0.1%3A1081%3B+SOCKS+127.0.0.1%3A1081%3B+DIRECT%3B")
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a PAC URL.", comment: "")))
                row.add(rule: RuleURL(allowsEmpty: false, requiresProtocol: true, msg: NSLocalizedString("Please enter a valid PAC URL.", comment: "")))
            }
            <<< IntRow { row in
                row.tag = "General - PAC Max Age"
                row.title = NSLocalizedString("PAC Max Age", comment: "")
                row.placeholder = NSLocalizedString("Enter PAC max age here", comment: "")
                row.value = Int(mainKeychain["general_pac_max_age"] ?? "3600")
                row.formatter = NumberFormatter()
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a PAC max age.", comment: "")))
                row.add(rule: RuleGreaterOrEqualThan(min: 0, msg: NSLocalizedString("PAC max age must greater than or equal to 0.", comment: "")))
                row.add(rule: RuleSmallerOrEqualThan(max: 86400, msg: NSLocalizedString("PAC max age must smaller than or equal to 86400.", comment: "")))
            }
            
            +++ Section(header: NSLocalizedString("Shadowsocks", comment: ""), footer: "") { section in
                section.tag = "Shadowsocks"
                section.header?.height = { 30 }
                section.footer?.height = { .leastNonzeroMagnitude }
            }
            <<< TextRow { row in
                row.tag = "Shadowsocks - Server Address"
                row.title = NSLocalizedString("Server Address", comment: "")
                row.placeholder = NSLocalizedString("Enter server address here", comment: "")
                row.value = mainKeychain["shadowsocks_server_address"]
                row.cell.textField.keyboardType = .asciiCapable
                row.cell.textField.autocapitalizationType = .none
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a Shadowsocks server address.", comment: "")))
            }
            <<< IntRow { row in
                row.tag = "Shadowsocks - Server Port"
                row.title = NSLocalizedString("Server Port", comment: "")
                row.placeholder = NSLocalizedString("Enter server port here", comment: "")
                if let shadowsocksServerPort = mainKeychain["shadowsocks_server_port"] {
                    row.value = Int(shadowsocksServerPort)
                }
                row.formatter = NumberFormatter()
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a Shadowsocks server port.", comment: "")))
                row.add(rule: RuleGreaterOrEqualThan(min: 0, msg: NSLocalizedString("Shadowsocks server port must greater than or equal to 0.", comment: "")))
                row.add(rule: RuleSmallerOrEqualThan(max: 65535, msg: NSLocalizedString("Shadowsocks server port must smaller than or equal to 65535.", comment: "")))
            }
            <<< TextRow { row in
                row.tag = "Shadowsocks - Local Address"
                row.title = NSLocalizedString("Local Address", comment: "")
                row.placeholder = NSLocalizedString("Enter local address here", comment: "")
                row.value = mainKeychain["shadowsocks_local_address"] ?? "127.0.0.1"
                row.cell.textField.keyboardType = .asciiCapable
                row.cell.textField.autocapitalizationType = .none
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a Shadowsocks local address.", comment: "")))
            }
            <<< IntRow { row in
                row.tag = "Shadowsocks - Local Port"
                row.title = NSLocalizedString("Local Port", comment: "")
                row.placeholder = NSLocalizedString("Enter local port here", comment: "")
                row.value = Int(mainKeychain["shadowsocks_local_port"] ?? "1081")
                row.formatter = NumberFormatter()
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a Shadowsocks local port.", comment: "")))
                row.add(rule: RuleGreaterOrEqualThan(min: 0, msg: NSLocalizedString("Shadowsocks local port must greater than or equal to 0.", comment: "")))
                row.add(rule: RuleSmallerOrEqualThan(max: 65535, msg: NSLocalizedString("Shadowsocks local port must smaller than or equal to 65535.", comment: "")))
            }
            <<< PasswordRow { row in
                row.tag = "Shadowsocks - Password"
                row.title = NSLocalizedString("Password", comment: "")
                row.placeholder = NSLocalizedString("Enter password here", comment: "")
                row.value = mainKeychain["shadowsocks_password"]
                
                row.add(rule: RuleRequired(msg: NSLocalizedString("Please enter a Shadowsocks password.", comment: "")))
            }
            <<< ActionSheetRow<String> { row in
                row.tag = "Shadowsocks - Method"
                row.title = NSLocalizedString("Method", comment: "")
                row.selectorTitle = NSLocalizedString("Shadowsocks Method", comment: "")
                row.options = ["AES-128-CFB", "AES-192-CFB", "AES-256-CFB", "ChaCha20", "Salsa20", "RC4-MD5"]
                row.value = mainKeychain["shadowsocks_method"] ?? "AES-256-CFB"
                row.cell.detailTextLabel?.textColor = .black
            }
            
            +++ Section(header: "", footer: "") { section in
                section.tag = "Configure"
                section.header?.height = { 30 }
                section.footer?.height = { .leastNonzeroMagnitude }
            }
            <<< ButtonRow { row in
                row.tag = "Configure - Configure"
                row.title = NSLocalizedString("Configure", comment: "")
                }.onCellSelection { _, _ in
                    let configuringAlertController = UIAlertController(
                        title: NSLocalizedString("Configuring...", comment: ""),
                        message: nil,
                        preferredStyle: .alert
                    )
                    self.present(configuringAlertController, animated: true)
                    
                    if !Alamofire.NetworkReachabilityManager(host: "8.8.8.8")!.isReachable {
                        let alertController = UIAlertController(
                            title: NSLocalizedString("Configuration Failed", comment: ""),
                            message: NSLocalizedString("Please check your network settings and allow Ladder to access your wireless data in the system's \"Settings - Cellular\" option (remember to check the \"WLAN & Cellular Data\").", comment: ""),
                            preferredStyle: .alert
                        )
                        if let openSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            alertController.addAction(UIAlertAction(
                                title: NSLocalizedString("Settings", comment: ""),
                                style: .default,
                                handler: { _ in
                                    UIApplication.shared.openURL(openSettingsURL)
                            }
                            ))
                        }
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                        configuringAlertController.dismiss(animated: true) {
                            self.present(alertController, animated: true)
                        }
                        return
                    } else if let firstValidationError = self.form.validate().first {
                        let alertController = UIAlertController(
                            title: NSLocalizedString("Configuration Failed", comment: ""),
                            message: firstValidationError.msg,
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                        configuringAlertController.dismiss(animated: true) {
                            self.present(alertController, animated: true)
                        }
                        return
                    }
                    
                    NETunnelProviderManager.loadAllFromPreferences { providerManagers, _ in
                        var providerManager = NETunnelProviderManager()
                        if let providerManagers = providerManagers, providerManagers.count > 0 {
                            providerManager = providerManagers[0]
                            if providerManagers.count > 1 {
                                for index in 1 ..< providerManagers.count {
                                    providerManagers[index].removeFromPreferences()
                                }
                            }
                        }
                        
                        let generalHideVPNIcon = (self.form.rowBy(tag: "General - Hide VPN Icon") as! SwitchRow).value!
                        let generalPACURL = (self.form.rowBy(tag: "General - PAC URL") as! URLRow).value!
                        let generalPACMaxAge = (self.form.rowBy(tag: "General - PAC Max Age") as! IntRow).value!
                        let shadowsocksServerAddress = (self.form.rowBy(tag: "Shadowsocks - Server Address") as! TextRow).value!
                        let shadowsocksServerPort = (self.form.rowBy(tag: "Shadowsocks - Server Port") as! IntRow).value!
                        let shadowsocksLocalAddress = (self.form.rowBy(tag: "Shadowsocks - Local Address") as! TextRow).value!
                        let shadowsocksLocalPort = (self.form.rowBy(tag: "Shadowsocks - Local Port") as! IntRow).value!
                        let shadowsocksPassword = (self.form.rowBy(tag: "Shadowsocks - Password") as! PasswordRow).value!
                        let shadowsocksMethod = (self.form.rowBy(tag: "Shadowsocks - Method") as! ActionSheetRow<String>).value!
                        
                        Alamofire.request(generalPACURL).responseString { response in
                            if response.response?.statusCode != 200 || response.value == nil {
                                let alertController = UIAlertController(
                                    title: NSLocalizedString("Configuration Failed", comment: ""),
                                    message: NSLocalizedString("Unable to download data from the PAC URL.", comment: ""),
                                    preferredStyle: .alert
                                )
                                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                                configuringAlertController.dismiss(animated: true) {
                                    self.present(alertController, animated: true)
                                }
                                return
                            }
                            
                            let providerConfiguration = NETunnelProviderProtocol()
                            providerConfiguration.serverAddress = "Ladder"
                            providerConfiguration.providerConfiguration = [
                                "general_hide_vpn_icon": generalHideVPNIcon,
                                "general_pac_url": generalPACURL.absoluteString,
                                "general_pac": response.value!,
                                "general_pac_max_age": TimeInterval(generalPACMaxAge),
                                "shadowsocks_server_address": shadowsocksServerAddress,
                                "shadowsocks_server_port": UInt16(shadowsocksServerPort),
                                "shadowsocks_local_address": shadowsocksLocalAddress,
                                "shadowsocks_local_port": UInt16(shadowsocksLocalPort),
                                "shadowsocks_password": shadowsocksPassword,
                                "shadowsocks_method": shadowsocksMethod,
                            ]
                            
                            providerManager.localizedDescription = NSLocalizedString("Ladder", comment: "")
                            providerManager.protocolConfiguration = providerConfiguration
                            providerManager.isEnabled = true
                            providerManager.saveToPreferences { error in
                                if error == nil {
                                    self.mainKeychain["general_hide_vpn_icon"] = generalHideVPNIcon ? "true" : "false"
                                    self.mainKeychain["general_pac_url"] = generalPACURL.absoluteString
                                    self.mainKeychain["general_pac_max_age"] = String(generalPACMaxAge)
                                    self.mainKeychain["shadowsocks_server_address"] = shadowsocksServerAddress
                                    self.mainKeychain["shadowsocks_server_port"] = String(shadowsocksServerPort)
                                    self.mainKeychain["shadowsocks_local_address"] = shadowsocksLocalAddress
                                    self.mainKeychain["shadowsocks_local_port"] = String(shadowsocksLocalPort)
                                    self.mainKeychain["shadowsocks_password"] = shadowsocksPassword
                                    self.mainKeychain["shadowsocks_method"] = shadowsocksMethod
                                    providerManager.loadFromPreferences { error in
                                        if error == nil {
                                            providerManager.connection.stopVPNTunnel()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                try? providerManager.connection.startVPNTunnel()
                                            }
                                        }
                                    }
                                }
                                configuringAlertController.dismiss(animated: true) {
                                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                                    if error != nil {
                                        alertController.title = NSLocalizedString("Configuration Failed", comment: "")
                                        alertController.message = NSLocalizedString("Please try again.", comment: "")
                                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                                    } else {
                                        alertController.title = NSLocalizedString("Configured!", comment: "")
                                    }
                                    self.present(alertController, animated: true) {
                                        if error == nil {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                alertController.dismiss(animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
        }
    }
    
    @objc func openPost() {
        present(SFSafariViewController(url: URL(string: "https://aofei.org/posts/2018-04-05-immersive-wallless-experience")!), animated: true)
    }
}
