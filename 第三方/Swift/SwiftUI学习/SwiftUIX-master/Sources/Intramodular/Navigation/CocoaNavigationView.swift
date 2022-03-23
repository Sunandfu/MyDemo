//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

#if os(iOS) || targetEnvironment(macCatalyst)

public struct CocoaNavigationView<Content: View>: View {
    private let content: Content
    private var configuration = _Body.Configuration()
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(navigationBarHidden: Bool, @ViewBuilder content: () -> Content) {
        self.init(content: content)
        
        self.configuration.isNavigationBarHidden = navigationBarHidden
    }
    
    public var body: some View {
        _Body(content: content, configuration: configuration)
            .edgesIgnoringSafeArea(.all)
    }
    
    public func navigationBarHidden(_ hidden: Bool) -> some View {
        then({ $0.configuration.isNavigationBarHidden = hidden })
    }
}

extension CocoaNavigationView {
    struct _Body: UIViewControllerRepresentable {
        struct Configuration {
            var isNavigationBarHidden: Bool = false
        }
        
        class UIViewControllerType: UINavigationController {
            var configuration = Configuration() {
                didSet {
                    if configuration.isNavigationBarHidden != oldValue.isNavigationBarHidden {
                        if configuration.isNavigationBarHidden != isNavigationBarHidden {
                            self.setNavigationBarHidden(configuration.isNavigationBarHidden, animated: true)
                        }
                    }
                }
            }
            
            override func viewWillAppear(_ animated: Bool) {
                self.view.backgroundColor = nil
                
                super.viewWillAppear(animated)
                
                setNavigationBarHidden(configuration.isNavigationBarHidden, animated: false)
            }
            
            override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
                guard hidden != isNavigationBarHidden else {
                    return
                }
                
                super.setNavigationBarHidden(configuration.isNavigationBarHidden, animated: animated)
            }
            
            override func pushViewController(_ viewController: UIViewController, animated: Bool) {
                super.pushViewController(viewController, animated: true)
            }
        }
        
        let content: Content
        let configuration: Configuration
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let viewController = UIViewControllerType()
            
            viewController.setViewControllers([CocoaHostingController(mainView: _ChildContainer(parent: viewController, rootView: content))], animated: false)
            
            viewController.configuration = configuration
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            uiViewController.configuration = configuration
            
            if let controller = uiViewController.viewControllers.first as? CocoaHostingController<_ChildContainer> {
                controller.mainView = .init(parent: uiViewController, rootView: content)
            }
        }
    }
    
    struct _ChildContainer: View {
        weak var parent: UINavigationController?
        
        var rootView: AnyView
        
        init<T: View>(parent: UINavigationController, rootView: T) {
            self.parent = parent
            self.rootView = rootView.eraseToAnyView()
        }
        
        var body: some View {
            rootView
                .environment(\.navigator, parent.map(_UINavigationControllerNavigatorAdaptorBox.init))
        }
    }
}

#endif
