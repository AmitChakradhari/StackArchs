import Foundation
import Alamofire
struct NetworkManager {

    private let router = Router<StackExchangeAPI>()
    let sessionManager = Alamofire.SessionManager.default

//    func getAllQuestions (completion: @escaping (AllQuestions?, Error?) -> Void) {
//        router.request (.allQuestions) { data, _, error in
//            //print(data ?? "noData")
//            //print(response ?? "noResponse")
//            print(error ?? "noError")
//            do {
//                let decoder = JSONDecoder().convertFromSnakeCase()
//                let decodedData = try decoder.decode(AllQuestions.self, from: data!)
//                completion(decodedData, nil)
//            } catch {
//                print(error.localizedDescription)
//                completion(nil, error)
//            }
//        }
//    }

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
        router.request(.question(id: qId)) { data, _, error in
            guard error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder().convertFromSnakeCase()
                let decodedData = try decoder.decode(Question.self, from: data!)
                completion(decodedData, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }

    func getAnswersOfQuestion(with qId: Int, completion: @escaping (Answers?, Error?) -> Void) {
        router.request(.answersOfQuestion(id: qId)) { data, _, error in
            print(error ?? "noError")
            guard data != nil else {
                print("data not found: getAnswersOfQuestion")
                return
            }
            do {
                let decoder = JSONDecoder().convertFromSnakeCase()
                let decodedData = try decoder.decode(Answers.self, from: data!)
                completion(decodedData, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }

    func getUser(with userID: Int, completion: @escaping (User?, Error?) -> Void) {
        router.request(.user(id: userID)) { data, _, error in
            print(error ?? "noError")
            guard data != nil else {
                print("data not found: getAnswersOfQuestion")
                return
            }
            do {
                let decoder = JSONDecoder().convertFromSnakeCase()
                let decodedData = try decoder.decode(User.self, from: data!)
                completion(decodedData, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
}
