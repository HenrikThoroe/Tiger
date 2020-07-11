//
//  ScannedLink.swift
//  Tiger
//
//  Created by Henrik Thoroe on 26.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI
import FavIcon
import CoreData

extension ScannedLink {
    
    static var example: ScannedLink {
        let example = ScannedLink()
        
        example.href = "https://example.com/long/scanned/path"
        example.icon = UIImage(named: "Demo")!
        example.id = UUID()
        example.scanned = Date()
        
        return example
    }
    
    convenience init(context: NSManagedObjectContext, href: String) {
        self.init(context: context)
        self.href = href.lowercased()
        self.scanned = Date()
        self.id = UUID()
        
        self.downloadIcon {
            try? context.save()
        }
        
        try? context.save()
    }
    
    var icon: UIImage {
        get {
            guard let data = icon_ else {
                return UIImage(systemName: "xmark.octagon")!
            }
            
            return UIImage(data: data) ?? UIImage(systemName: "xmark.octagon")!
        }
        
        set {
            icon_ = newValue.pngData() ?? icon_
        }
    }
    
    var href: String {
        get {
            guard var newHref = href_ else {
                return ""
            }
            
            if newHref.starts(with: "http://") {
                newHref = newHref.replacingOccurrences(of: "http://", with: "https://")
            }
            
            if !newHref.starts(with: "https://") {
                newHref = "https://\(newHref)"
            }
            
            return newHref
        }
        set { href_ = newValue }
    }
    
    var id: UUID {
        get { id_ ?? UUID() }
        set { id_ = newValue }
    }
    
    var scanned: Date {
        get { scanned_ ?? Date() }
        set { scanned_ = newValue }
    }
    
    var name: String {
        get {
            guard let url = self.url else {
                return href
            }
            
            return url.host ?? href
        }
    }
    
    var url: URL? {
        return URL(string: href)
    }
    
}

// MARK: - SwiftUI

extension ScannedLink {
    
    var thumbnail: Image {
        Image(uiImage: icon)
    }
    
}

// MARK: - Private Methods

private extension ScannedLink {
    
    func downloadIcon(onComplete: @escaping () -> Void) {
        icon = UIImage(named: "Demo")!
        
        let handleError = { (error: Error?) in
            print(error as Any)
        }
        
        do {
            try FavIcon.downloadPreferred(href, width: 500, height: 500) { result in
                if case let .success(image) = result {
                    self.icon = image
                    onComplete()
                } else if case let .failure(error) = result {
                    handleError(error)
                }
            }
        } catch {
            handleError(error)
        }
    }
    
}

// MARK: - API

extension ScannedLink {
    
    func open() {
        guard let url = self.url else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
