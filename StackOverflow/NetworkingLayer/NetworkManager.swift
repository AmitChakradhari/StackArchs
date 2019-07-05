import Foundation
import Alamofire
import Moya
struct NetworkManager {

    static let endpointClosure = { (target: StackExchangeAPI) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString.removingPercentEncoding!
        let defaultEndpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return  defaultEndpoint //defaultEndpoint.adding(newHTTPHeaderFields: JSONEncoding.default)
    }
    let provider = MoyaProvider<StackExchangeAPI>(endpointClosure: endpointClosure)//(plugins: [CompleteUrlLoggerPlugin()])

    func getAllQuestions (completion: @escaping (AllQuestions?, Error?) -> Void) {
        provider.request(.allQuestions) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder().convertFromSnakeCase()
                do {
                    let decodedData = try decoder.decode(AllQuestions.self, from: response.data)
                    completion(decodedData, nil)
                } catch (let e) {
                    print("error: \(e.localizedDescription)")
                    completion(nil, e)
                }
            case .failure(let error):
                print("error : \(error.localizedDescription)")
            }
        }
    }

    func getQuestion(with qId: Int, completion: @escaping (Question?, Error?) -> Void) {
        provider.request(.question(id: qId)) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder().convertFromSnakeCase()
                do {
                    let decodedData = try decoder.decode(Question.self, from: response.data)
                    completion(decodedData, nil)
                } catch (let e) {
                    print("error: \(e.localizedDescription)")
                    completion(nil, e)
                }
            case .failure(let error):
                print("error : \(error.localizedDescription)")
            }
        }
    }

    func getAnswersOfQuestion(with qId: Int, completion: @escaping (Answers?, Error?) -> Void) {
        provider.request(.answersOfQuestion(id: qId)) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder().convertFromSnakeCase()
                do {
                    let decodedData = try decoder.decode(Answers.self, from: response.data)
                    completion(decodedData, nil)
                } catch (let e) {
                    print("error: \(e.localizedDescription)")
                    completion(nil, e)
                }
            case .failure(let error):
                print("error : \(error.localizedDescription)")
            }
        }
    }

    func getUser(with userID: Int, completion: @escaping (User?, Error?) -> Void) {
        provider.request(.user(id: userID)) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder().convertFromSnakeCase()
                do {
                    let decodedData = try decoder.decode(User.self, from: response.data)
                    completion(decodedData, nil)
                } catch (let e) {
                    print("error: \(e.localizedDescription)")
                    completion(nil, e)
                }
            case .failure(let error):
                print("error : \(error.localizedDescription)")
            }
        }
    }
}
class CompleteUrlLoggerPlugin : PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url?.absoluteString ?? "Something is wrong")
    }
}
