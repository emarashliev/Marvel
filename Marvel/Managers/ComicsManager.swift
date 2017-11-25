//
//  ComicsManager.swift
//  Marvel
//
//  Created by Emil Marashliev on 11/2/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import Foundation
import Nuke

struct ComicsManager {

    static var comicses: [Comics] = [] {
        didSet {
           _ = observers.map { _, closure in
                closure()
            }
        }
    }

    private static var observers: [String : () -> Void]  = [:]
    private static let preheater = Preheater()


    //MARK: - Comicses observation
    
    static func addObserver(_ observerClosure: @escaping () -> Void) -> String {
        let key =  NSUUID().uuidString
        observers[key] = observerClosure
        return key
    }

    static func removeObserver(with key: String) {
        observers.removeValue(forKey: key)
    }

    //МАРК: - 

    static func fetchComicsesIfNeeded(`for` indexPaths: [IndexPath],
                                      with networkManager: NetworkManager) {
        
        if indexPaths.contains(where: { $0.row + 2 > comicses.endIndex }) {
            networkManager.getComics(offset:comicses.endIndex,
                                     completionHandler: { comicses, success in
                                        if success {
                                            ComicsManager.comicses.append(contentsOf: comicses)
                                        }
            })
        }
    }
    //MARK: - Comicses cover prefetchig

    static func startImagePreheating( _ indexPaths: [IndexPath]) {
         preheater.startPreheating( with: requestsForIndexPaths(indexPaths))
    }

    static func stopImagePreheating( _ indexPaths: [IndexPath]) {
        preheater.stopPreheating( with: requestsForIndexPaths(indexPaths))
    }
    
    private static func requestsForIndexPaths( _ indexPaths: [IndexPath] ) -> [Nuke.Request] {
        let requests = indexPaths.map { (indexPath) -> Nuke.Request?  in
            let comics = ComicsManager.comicses[indexPath.row]
            if let thumbnail = comics.thumbnail, let url = URL(string: thumbnail) {
                return Nuke.Request(url: url)
            }
            return nil
            }.filter { $0 != nil }
        return requests as! [Nuke.Request]
    }

}
