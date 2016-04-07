import Foundation
import SwiftyJSON

struct EmptyObject: BaseModel {
    var isError: Bool { return false }
    var error: String?

    init(json: JSON) { }
}
