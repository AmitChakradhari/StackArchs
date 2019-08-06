import Foundation

struct Question: Codable {

    let items: [QuestionItems]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
}

struct QuestionItems: Codable {
    let tags: [String]
    let comments: [Comment]?
    let owner: Owner
    let lastEditor: Owner?
    let isAnswered: Bool
    let answerCount: Int
    let score: Int
    let lastActivityDate: Int
    let creationDate: Int
    let questionId: Int
    let bodyMarkdown: String
    let link: String
    let title: String
    let body: String
}

struct User: Codable {
    let items: [UserItem]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
    struct UserItem: Codable {
        let badgeCounts: BadgeCount?
        let answerCount: Int?
        let questionCount: Int?
        let accountId: Int?
        let reputation: Int?
        let creationDate: Int?
        let userId: Int?
        let aboutMe: String?
        let location: String?
        let websiteUrl: String?
        let link: String?
        let profileImage: String?
        let displayName: String?
    }
}

class Comment: Codable {
    let owner: Owner?
    let score: Int
    let creationDate: Int
    let bodyMarkdown: String
    let body: String
}

struct BadgeCount: Codable {
    let bronze: Int
    let silver: Int
    let gold: Int
}

struct Answers: Codable {

    let items: [Answer]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int

   struct Answer: Codable {
        let owner: Owner
        let lastEditor: Owner?
        let comments: [Comment]?
        //let is_accepted: Bool
        //let score: Int
        let lastEditDate: Int?
        let creationDate: Int
        let answerId: Int
        let bodyMarkdown: String
        let body: String
    }

}

struct GenericResponse<T: Codable>: Codable {
    let items: [T]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
}

struct AllQuestionsItems: Codable {
    let tags: [String]
    let owner: Owner
    let isAnswered: Bool
    let viewCount: Int
    let answerCount: Int
    let score: Int
    let lastActivityDate: Int
    let creationDate: Int
    let questionId: Int
    let link: String
    let title: String
}

struct Owner: Codable {
    let badgeCounts: BadgeCount?
    let reputation: Int?
    let userId: Int?
    let userType: String?
    let profileImage: String?
    let displayName: String?
}
