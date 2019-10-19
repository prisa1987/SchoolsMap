
import Foundation


struct MapServices {
    
    func performNetworkTask<T: Codable>(endpoint: SchoolsMapAPI,
                                        type: T.Type,
                                        httpMethod: NetworkMethod,
                                        body: Data?,
                                        completion: ((_ response: T) -> Void)?
    ) {
        
        let url = endpoint.baseURL?.appendingPathComponent(endpoint.path)
        guard let urlWithQuery = url else { return }
        
        var urlRequest = URLRequest(url: urlWithQuery)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            urlRequest.httpBody = body
        }
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard error == nil, let data = data else { return }
            let response = Response(data: data)
            guard let decoded = response.decode(type) else { return }
            completion?(decoded)
        }

        urlSession.resume()
    }
    
}

enum NetworkMethod: String {
    case GET
    case POST
}
