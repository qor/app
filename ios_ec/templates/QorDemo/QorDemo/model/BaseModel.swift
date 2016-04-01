import Foundation
import SwiftyJSON

public protocol BaseModel {
    init(json: JSON)
    var isError: Bool { get }
    var error: String? { get }
}