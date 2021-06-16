import Foundation

class Loader {
    
    func fetch<T: Decodable>(structData: T.Type, url: String, httpMethod: HttpMethod, parameters: [String: Any]?, completion: @escaping (T) -> Void, completionError: ((ErrorModel) -> Void)? = nil) {
        
        let session = URLSession.shared
        
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request)
        
        if let body = parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else { return }
            request.httpBody = httpBody
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("error calliing on \(url)")
                return
            }
            
            guard let data = data else {
                print("there was an error with the data")
                return
            }
            
            do {
                if let model = try? JSONDecoder().decode(T.self, from: data){
                    DispatchQueue.main.async {
                        completion(model)
                        print ("model \(model)")
                    }
                }
                if let model = try? JSONDecoder().decode(ErrorModel.self, from: data), let completionError=completionError {
                    DispatchQueue.main.async {
                        completionError(model)
                        print ("ErrorModel \(model)")
                    }
                }
            } catch _ {
                print("failed to decode, \(String(describing: error))")
            }
        }
        task.resume()
    }
}

