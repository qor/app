import Foundation
import Alamofire
import SwiftyJSON

typealias APIHandler = (model: BaseModel) -> Void

class APIClient: NSObject {
    static let sharedClient = APIClient()

    var base = "http://127.0.0.1:7000"
    var manager: Alamofire.Manager!
    
    func createManager() {
        let configuration = Alamofire.Manager.sharedInstance.session.configuration
        manager = Alamofire.Manager(
            configuration: configuration,
            serverTrustPolicyManager: serverTrustPolicyManager()
        )
        
        var headers = manager.session.configuration.HTTPAdditionalHeaders!
        headers["Accept"] = "application/json"
        manager.session.configuration.HTTPAdditionalHeaders = headers
        
        print("Created APIClient: \(self.base)")
    }

    func get(path path: String, modelClass: BaseModel.Type, accessToken: String? = nil, handler: APIHandler) {
        request(.GET, path: path, modelClass: modelClass, accessToken: accessToken, parameters: nil, handler: handler)
    }

    func get(path path: String, modelClass: BaseModel.Type, accessToken: String? = nil, parameters: [String: AnyObject]? = nil, handler: APIHandler? = nil) {
        request(.GET, path: path, modelClass: modelClass, accessToken: accessToken, parameters: parameters, handler: handler)
    }

    func post(path path: String, modelClass: BaseModel.Type, accessToken: String? = nil, parameters: [String: AnyObject]? = nil, handler: APIHandler? = nil) {
        request(.POST, path: path, modelClass: modelClass, accessToken: accessToken, parameters: parameters, handler: handler)
    }

    func put(path path: String, modelClass: BaseModel.Type, accessToken: String? = nil, parameters: [String: AnyObject]? = nil, handler: APIHandler? = nil) {
        request(.PUT, path: path, modelClass: modelClass, accessToken: accessToken, parameters: parameters, handler: handler)
    }

    private func request(method: Alamofire.Method, path: String, modelClass: BaseModel.Type, accessToken: String? = nil, parameters: [String: AnyObject]? = nil, handler: APIHandler?) {
        let request = buildRequest(method, path: path, accessToken: accessToken, parameters: parameters)

        manager.request(request).response { (_, response, data, error) in
            guard let handler = handler else {
                return
            }

            if let response = response, data = data where (response.allHeaderFields["Content-Type"] ?? "").hasPrefix("application/json") {
                let json = JSON(data: data)
//                print("got json: \(json)")
                
                if response.statusCode == 200 {
                    let model: BaseModel = modelClass.init(json: json)
                    handler(model: model)
                } else {
                    var model = Error(json: json)
                    model.statusCode = response.statusCode
                    handler(model: model)
                }
                return
            } else {
                var message = "Failed to connect to server"
                if let error = error {
                    message += " " + error.localizedDescription
                }
                print("Error: access \(self.base)/api\(path) \(message)")
                if let data = data {
                    print("Response: \(String(data: data, encoding: NSUTF8StringEncoding))!")
                }
                let json: JSON = ["error": message, "statusCode": response?.statusCode ?? 500]
                handler(model: Error(json: json))
            }
        }
    }

    private func buildRequest(method: Alamofire.Method, path: String, accessToken: String? = nil, parameters: [String: AnyObject]? = nil) -> NSURLRequest {
        let urlString = "\(base)/api\(path)"
        let URL = NSURL(string: urlString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)

        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.HTTPShouldHandleCookies = false

        let paramEncoding: ParameterEncoding
        switch method {
        case .GET, .HEAD, .DELETE:
            paramEncoding = .URL
        default:
            paramEncoding = .JSON
        }

        return paramEncoding.encode(mutableURLRequest, parameters: parameters).0
    }
}

// MARK: - Alamofire Manager

private extension APIClient {
    
    func serverTrustPolicyManager() -> ServerTrustPolicyManager {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            host(): .DisableEvaluation
        ]
        return ServerTrustPolicyManager(policies: serverTrustPolicies)
    }

    func host() -> String {
        let url = NSURL(string: base)!
        return url.host!
    }
}
