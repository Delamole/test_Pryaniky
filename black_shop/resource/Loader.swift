import Foundation
import UIKit
import Alamofire
import AlamofireImage
import Bond

class LoadModel: NSObject {
    
    static var shared = LoadModel()
    
    func loadTopList(completion: @escaping (CategoryModel) -> Void){
        Loader().fetch(structData: CategoryModel.self, url: "https://pryaniky.com/static/json/sample.json", httpMethod: HttpMethod.get, parameters: nil, completion: { (tabak) in
            DispatchQueue.main.async {
                completion(tabak)
            }
            print("data: \(tabak)")
        },
        completionError: {
            (errorReq) in
            print("errorReq: \(errorReq)")
            
        })
    }
    
    func loadImage(icon: String, completion: @escaping (UIImage) -> Void){
        AF.request(icon).responseImage { response in
            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
}

