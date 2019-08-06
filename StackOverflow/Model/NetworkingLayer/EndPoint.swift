import Foundation
import Moya

public enum StackExchangeAPI {
    case allQuestions
    case question(id: Int)
    case answersOfQuestion(id: Int)
    case user(id: Int)
}

extension StackExchangeAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.stackexchange.com/")!
    }

    public var path: String {
        switch self {
        case .allQuestions:
            return "2.2/questions?order=desc&sort=votes&site=stackoverflow&filter=!FdXqhHLx0yX_OIjLpMah9VRMJj"
        case .question(let id):
            return "/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=!67O0sxiY9UvfuaU(YmuPUIxlhai.S3L6rCuQC76BQKQTApRCp-C45HyI(i9"
        case .answersOfQuestion(let id):
            return "/2.2/questions/\(id)/answers?order=desc&sort=activity&site=stackoverflow&filter=!2ooW06VMFzp73spnSia4Uf0bA6-M6-ku2lIxYq3x6L"
        case .user(let userId):
            return "/2.2/users/\(userId)?order=desc&sort=name&site=stackoverflow&filter=!0YzAa5Qi(lZjoj9D(7sxHUSJP"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .allQuestions:
            return .get
        default:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
