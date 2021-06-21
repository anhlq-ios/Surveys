//
//  Survey.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import Foundation

struct Survey: Decodable {
    let id: String?
    let title: String?
    let description: String?
    let coverImageUrl: String?
    let activeAt: String?
    
    init(id: String?, title: String?, description: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.coverImageUrl = "https://images.pexels.com/photos/2486168/pexels-photo-2486168.jpeg"
        self.activeAt = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }
    
    enum AttributesKeys: String, CodingKey {
        case title, description
        case coverImageUrl = "cover_image_url"
        case activeAt = "active_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributeContainer = try container.nestedContainer(keyedBy: AttributesKeys.self, forKey: .attributes)
        title = try attributeContainer.decode(String.self, forKey: .title)
        description = try attributeContainer.decode(String.self, forKey: .description)
        coverImageUrl = try attributeContainer.decode(String.self, forKey: .coverImageUrl)
        activeAt = try attributeContainer.decode(String.self, forKey: .activeAt)
    }
}

struct SurveyList: Decodable {
    let surveys: [Survey]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        surveys = try container.decode(Array<Survey>.self, forKey: .data)
    }
}
