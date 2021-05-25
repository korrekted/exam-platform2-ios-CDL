//
//  GetTopicsResponseMapper.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.04.2021.
//

final class GetTopicsResponseMapper {
    static func map(from response: Any) -> [SpecificTopic] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let courses = data["courses"] as? [[String: Any]]
        else {
            return []
        }
        
        return courses.compactMap { courseJSON -> SpecificTopic? in
            guard
                let id = courseJSON["id"] as? Int,
                let name = courseJSON["name"] as? String,
                let description = courseJSON["sub"] as? String
            else {
                return nil
            }
            
            return SpecificTopic(id: id,
                                 title: name,
                                 description: description,
                                 isMain: courseJSON["main"] as? Bool ?? false)
        }
    }
}
