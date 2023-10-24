import Foundation
import UIKit
import Photos

private struct AssetManager: Hashable {
    
    internal var size: CGSize
    
    internal let manager = PHCachingImageManager.init()
    
    var hashValue: Int {
        return size.width.hashValue ^ size.height.hashValue
    }
}

public struct Assets {
    
    public struct PreheatRequest {
        
        public let entries: [Entry]
        
        public struct Entry {
            
            public let asset: PHAsset
            
            public let size: CGSize
            
            public init (asset: PHAsset, size: CGSize) {
                self.asset = asset
                self.size = size
            }
            
        }
        
        public class SizedAssetGroup {
            
            let size: CGSize
            
            var assets: [PHAsset] = []
            
            public init(size: CGSize) {
                self.size = size
            }
            
        }
        
        public var sizedAssetGroups: [SizedAssetGroup] {
            
            var groups: [SizedAssetGroup] = []
            
            func provideGroup(size: CGSize) -> SizedAssetGroup {
                if let group = groups.first(where: {$0.size == size}) {
                    return group
                }
                let newGroup = SizedAssetGroup.init(size: size)
                groups.append(newGroup)
                return newGroup
            }
            
            for entry in entries {
                let group = provideGroup(size: entry.size)
                group.assets.append(entry.asset)
            }
            
            return groups
        }
        
    }
    
    private static var cacheManagers: [AssetManager] = []
    
    public static func cacheManager(size: CGSize) -> PHCachingImageManager {
        if let managerEntry = cacheManagers.first(where: {$0.size == size}) {
            return managerEntry.manager
        }
        
        let newEntry = AssetManager.init(size: size)
        newEntry.manager.allowsCachingHighQualityImages = false
        DispatchQueue.main.async {
            cacheManagers.append(newEntry)
        }
        return newEntry.manager
    }
    
    /// Requests access to the user's contacts
    ///
    /// - Parameter requestGranted: Result as Bool
    public static func requestAccess(_ requestGranted: @escaping (PHAuthorizationStatus) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            requestGranted(status)
        }
    }
    
    /// Result Enum
    ///
    /// - Success: Returns Array of PHAsset
    /// - Error: Returns error
    public enum FetchResults {
        case success(response: [PHAsset])
        case error(error: Error)
    }
    
    public enum OriginalFetchResults {
        case success(result: PHFetchResult<PHAsset>)
        case error(error: Error)
    }
    
    
    public static func fetchOriginal(_ completion: @escaping (OriginalFetchResults)-> Void ) {
        
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            let error: NSError = NSError(domain: "PhotoLibrary Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "No PhotoLibrary Access"])
            completion(OriginalFetchResults.error(error: error))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
            
            DispatchQueue.main.async {
                completion(.success(result: fetchResult))
            }
        }
        
    }
    
    public static func fetch(_ completion: @escaping (FetchResults) -> Void) {
        
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            let error: NSError = NSError(domain: "PhotoLibrary Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "No PhotoLibrary Access"])
            completion(FetchResults.error(error: error))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
            
            // MARK: Is it ok we don't call completion if there is no photo in library?
            if fetchResult.count > 0 {
                
                let assets = fetchResult.dlg_assets
                
                DispatchQueue.main.async {
                    completion(FetchResults.success(response: assets))
                }
            }
        }
    }
    
    /// Result Enum
    ///
    /// - Success: Returns UIImage
    /// - Error: Returns error
    public enum ResolveResult {
        case success(response: UIImage?)
        case error(error: Error)
    }
    
    public static func preheat(request: PreheatRequest) {
        
        for group in request.sizedAssetGroups {
            let manager = cacheManager(size: group.size)
            manager.startCachingImages(for: group.assets, targetSize: group.size, contentMode: .aspectFill, options: defaultImageRequestOptions)
        }
    }
    
    public static func resolve(asset: PHAsset, size: CGSize = PHImageManagerMaximumSize, cacheAllowed: Bool = true, completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let manager: PHImageManager = cacheAllowed ? cacheManager(size: size) : PHImageManager.default()
            
            let requestOptions = defaultImageRequestOptions
            
            manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    public static func resolveVideo(asset: PHAsset, size: CGSize = PHImageManagerMaximumSize, cacheAllowed: Bool = true, completion: @escaping (_ image: URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let manager: PHImageManager = cacheAllowed ? cacheManager(size: size) : PHImageManager.default()
            
            let options: PHVideoRequestOptions = defaultVideoRequestOptions
            
            manager.requestAVAsset(forVideo: asset, options: options) { (asset, audioMix, info) in
                DispatchQueue.main.async {
                    if let urlAsset = asset as? AVURLAsset {
                        completion(urlAsset.url)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    private static var defaultVideoRequestOptions: PHVideoRequestOptions {
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .original
        options.isNetworkAccessAllowed = true
        return options
    }
    
    private static var defaultImageRequestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true
        return options
    }
    
    /// Result Enum
    ///
    /// - Success: Returns Array of UIImage
    /// - Error: Returns error
    public enum ResolveResults {
        case success(response: [UIImage])
        case error(error: Error)
    }
    
    public static func resolve(assets: [PHAsset], size: CGSize = CGSize(width: 720, height: 1280), completion: @escaping (_ images: [UIImage]) -> Void) -> [UIImage] {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        var images = [UIImage]()
        for asset in assets {
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, _ in
                if let image = image {
                    images.append(image)
                }
            }
        }
        
        DispatchQueue.main.async {
            completion(images)
        }
        
        return images
    }
}
