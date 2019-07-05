import Foundation
// Encoding
protocol EndPointType {
    var baseUrl: URL { get }
    var basePath: String { get }
    var HTTPMethods: HTTPMethod { get }
    var HTTPHeaders: HTTPHeaders? { get }
    var HTTPTask: HTTPTask { get }
}

public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum HTTPTask {
    case request
}

// EndPoint

public enum StackExchangeAPI {
    case allQuestions
    case question(id: Int)
    case answersOfQuestion(id: Int)
    case user(id: Int)
}

extension StackExchangeAPI: EndPointType {

    var baseUrl: URL {
        return URL(string: "https://api.stackexchange.com/")!
    }

    var basePath: String {
        switch self {
        case .allQuestions:
            return "2.2/questions?order=desc&sort=votes&site=stackoverflow&filter=!SX3kgUUZ3HULohOcN1"
        case .question(let id):
            return "/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=!67O0sxiY9UvfuaU(YmuPUIxlhai.S3L6rCuQC76BQKQTApRCp-C45HyI(i9"
        case .answersOfQuestion(let id):
            return "/2.2/questions/\(id)/answers?order=desc&sort=activity&site=stackoverflow&filter=!2ooW06VMFzp73spnSia4Uf0bA6-M6-ku2lIxYq3x6L"
        case .user(let userId):
            return "/2.2/users/\(userId)?order=desc&sort=name&site=stackoverflow&filter=!0YzAa5Qi(lZjoj9D(7sxHUSJP"
        }
    }

    var HTTPMethods: HTTPMethod {
        switch self {
        case .allQuestions:
            return .get
        default:
            return .get
        }
    }

    var HTTPHeaders: HTTPHeaders? {
        return nil
    }

    var HTTPTask: HTTPTask {
        switch self {
        default:
            return .request
        }
    }

}

// Router
public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    func request(_ route: EndPoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: route)
            task = session.dataTask(with: request) { (data, response, error) in
                completion(data, response, error)

            }
        } catch {
            completion(nil, nil, error)
            print("error: \(error.localizedDescription)")
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }

    func buildRequest(from route: EndPoint) throws -> URLRequest {
        let url = URL(string: route.baseUrl.absoluteString + route.basePath)//route.baseUrl.appendingPathComponent(route.basePath)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        request.httpMethod = route.HTTPMethods.rawValue
        do {
            switch route.HTTPTask {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        return request
    }
}
