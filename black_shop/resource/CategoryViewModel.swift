import Foundation

struct ErrorModel: Decodable {
    
}

struct CategoryModel: Decodable {
    var data: [CategoryModelData]
}

struct CategoryModelData: Decodable {
    var name: String
    var data: MmodelClass
}

struct CategoryData: Decodable {
    var text: String
    var url: String
    var selectedId: Int
    var variants: [VariantsData]
    
}
struct VariantsData: Decodable {
    var id: Int
    var text: String
}

struct MmodelClass: Decodable {
    
    var text: String
    var url: String
    var selectedId: Int
    var variants: [VariantsData]
    
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case url = "url"
        case selectedId = "selectedId"
        case variants = "variants"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        selectedId = try values.decodeIfPresent(Int.self, forKey: .selectedId) ?? 0
        variants = try values.decodeIfPresent([VariantsData].self, forKey: .variants) ?? [VariantsData(id: 0, text: "")]
    }
}
