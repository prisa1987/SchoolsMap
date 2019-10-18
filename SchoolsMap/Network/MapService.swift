
import Foundation


struct WebServices {
    
    func performNetworkTask<T: Codable>(endpoint: SchoolsMapAPI,
                                        type: T.Type,
                                        completion: ((_ response: T) -> Void)?
    ) {
        
        let url = endpoint.baseURL?.appendingPathComponent(endpoint.path)
        guard let urlWithQuery = url else { return }
        
        let urlRequest = URLRequest(url: urlWithQuery)
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard error == nil, let data = data else { return }
            let response = Response(data: data)
            guard let decoded = response.decode(type) else { return }
            completion?(decoded)
        }

        urlSession.resume()
    }
}
