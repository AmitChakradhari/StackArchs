import Foundation
import Alamofire
struct NetworkManager {

    private let router = Router<StackExchangeAPI>()
    let sessionManager = Alamofire.SessionManager.default

    func getAllQuestions (completion: @escaping (AllQuestions?, Error?) -> Void) {
        do {
            let urlRequest = try router.buildRequest(from: .allQuestions)
            sessionManager.request(urlRequest)
            .validate()
            .responseData { response in
                guard response.error == nil, let data = response.data else { return }
                let decoder = JSONDecoder().convertFromSnakeCase()
                do {
                    let decodedData = try decoder.decode(AllQuestions.self, from: data)
                    completion(decodedData, nil)
                } catch (let e) {
                    print("error: \(e.localizedDescription)")
                    completion(nil, e)
                }
            }
        }
        catch (let err) {
            print("error: \(err.localizedDescription)")
            completion(nil, err)
        }
    }


    func getQuestion(with qId: Int, completion: @escaping (Question?, Error?) -> Void) {

        do {
            let urlRequest = try router.buildRequest(from: .question(id: qId))
            sessionManager.request(urlRequest)
                .validate()
                .responseData { response in
                    guard response.error == nil, let data = response.data else { return }
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(Question.self, from: data)
                        completion(decodedData, nil)
                    } catch (let e) {
                        print("error: \(e.localizedDescription)")
                        completion(nil, e)
                    }
            }
        }
        catch (let err) {
            print("error: \(err.localizedDescription)")
            completion(nil, err)
        }
    }



    func getAnswersOfQuestion(with qId: Int, completion: @escaping (Answers?, Error?) -> Void) {

        do {
            let urlRequest = try router.buildRequest(from: .answersOfQuestion(id: qId))
            sessionManager.request(urlRequest)
                .validate()
                .responseData { response in
                    guard response.error == nil, let data = response.data else { return }
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(Answers.self, from: data)
                        completion(decodedData, nil)
                    } catch (let e) {
                        print("error: \(e.localizedDescription)")
                        completion(nil, e)
                    }
            }
        }
        catch (let err) {
            print("error: \(err.localizedDescription)")
            completion(nil, err)
        }

    }

    func getUser(with userID: Int, completion: @escaping (User?, Error?) -> Void) {

        do {
            let urlRequest = try router.buildRequest(from: .user(id: userID))
            sessionManager.request(urlRequest)
                .validate()
                .responseData { response in
                    guard response.error == nil, let data = response.data else { return }
                    let decoder = JSONDecoder().convertFromSnakeCase()
                    do {
                        let decodedData = try decoder.decode(User.self, from: data)
                        completion(decodedData, nil)
                    } catch (let e) {
                        print("error: \(e.localizedDescription)")
                        completion(nil, e)
                    }
            }
        }
        catch (let err) {
            print("error: \(err.localizedDescription)")
            completion(nil, err)
        }
    }
}
