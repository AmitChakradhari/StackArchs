import Foundation
import Moya
import PromiseKit
import RxSwift
import RxCocoa

struct NetworkManager {

    enum NetworkCall {
        case AllQuestion
    }

    func getResponse<T>(_ call: NetworkCall) -> Promise<T> {
        switch call {
        case .AllQuestion:
            return getResponse(api: .allQuestions, as: GenericResponse<AllQuestionsItems>.self) as! Promise<T>
        }
    }

    func getResponse<T: Codable>(api: StackExchangeAPI, as type: T.Type) -> Promise<T> {
        return Promise { seal in
            provider.request(api) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(T.self, from: response.data)
                        seal.fulfill(decodedData)
                    } catch (let e) {
                        print("error: \(e.localizedDescription)")
                        seal.reject(e)
                    }
                case .failure(let error):
                    print("error : \(error.localizedDescription)")
                    seal.reject(error)
                }
            }
        }
    }

    static let endpointClosure = { (target: StackExchangeAPI) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString.removingPercentEncoding!
        let defaultEndpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return  defaultEndpoint
    }

    let provider = MoyaProvider<StackExchangeAPI>(endpointClosure: endpointClosure)//(plugins: [CompleteUrlLoggerPlugin()])
}
class CompleteUrlLoggerPlugin : PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url?.absoluteString ?? "Something is wrong")
    }
}
