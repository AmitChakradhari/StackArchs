import Foundation
import Moya
import PromiseKit
import RxSwift
import RxCocoa

struct NetworkManager {

    static let endpointClosure = { (target: StackExchangeAPI) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString.removingPercentEncoding!
        let defaultEndpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return  defaultEndpoint
    }

    let provider = MoyaProvider<StackExchangeAPI>(endpointClosure: endpointClosure)//(plugins: [CompleteUrlLoggerPlugin()])

    func getAllQuestions () -> Promise<AllQuestions> {
        return Promise { seal in
            provider.request(.allQuestions) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(AllQuestions.self, from: response.data)
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

    func getQuestion(with qId: Int) -> Promise<Question> {
        return Promise { seal in
            provider.request(.question(id: qId)) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(Question.self, from: response.data)
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

    func getAnswersOfQuestion(with qId: Int) -> Promise<Answers> {
        return Promise { seal in
            provider.request(.answersOfQuestion(id: qId)) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(Answers.self, from: response.data)
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

    func getUser(with userID: Int) -> Promise<User> {
        return Promise { seal in
            provider.request(.user(id: userID)) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(User.self, from: response.data)
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
}
class CompleteUrlLoggerPlugin : PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url?.absoluteString ?? "Something is wrong")
    }
}
