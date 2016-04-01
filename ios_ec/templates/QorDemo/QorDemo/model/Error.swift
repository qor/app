import Foundation
import SwiftyJSON

struct Error: BaseModel, CustomStringConvertible {
    var error: String?
    var statusCode: Int

    init(json: JSON) {
        error       = json["error"].string
        statusCode  = json["statusCode"].int ?? 500
    }

    var isError: Bool { return true }

    var description: String {
        return "Model Error: \(error!)\n\tStatus Code: \(statusCode)"
    }
}
