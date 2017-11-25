//
//  NetworkManager.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/28/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NetworkManager {

    private lazy var sessionManager : Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.`default`
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(configuration: configuration)
        let adapter = Adapter()
        manager.adapter = adapter
        return manager
    }()

    func getComics(offset: Int = 0,
                   limit: Int = 20,
                   completionHandler: @escaping (_ comicses: [Comics], _ success: Bool) -> Void ) {
        let request = Router.comics(parameters: [ "offset"  : offset,
                                                  "limit"   : limit,
                                                  "orderBy" : "onsaleDate"])
        sessionManager.request(request)
            .responseData(queue: DispatchQueue.global(qos: .background)) { response in
                var comicses = [Comics]()
                switch response.result {
                case .success(let value):
                    let json = JSON(data: value)
                    let decoder = JSONDecoder()
                    for jsonComics in json["data"]["results"].arrayValue {
                        do {
                            let dataComics = try jsonComics.rawData()
                            let comics = try decoder.decode(Comics.self, from: dataComics)
                            comicses.append(comics)
                        } catch(let error) {
                            print(error)
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(comicses, true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completionHandler(comicses, false)
                        print(error)
                    }
                }
        }
    }
}

// MARK: - Authentication
private class Adapter: RequestAdapter {
    private let publicKey = ""._2.d.f._7._2._0._6._4.e._2.c.c._1._6._3.f._4._0._2.b.d._0.f.b._4._1._5.d.d._0._9._8
    private let privateKey = ""._9._8._7.a.c._8._7.f._3._1.e.e.e._1.e._3._7._6._8._2.a.c._3.f.c.e._2._9._6.b._8._4._5._4.c._8.b.e._8._2

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Router.baseURLString) {
            let ticks = String(Date().timeIntervalSince1970)
            let parameters = ["ts" : ticks,
                              "apikey" : publicKey,
                              "hash" : "\(ticks)\(privateKey)\(publicKey)".md5()]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }

}
