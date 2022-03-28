//
//  File.swift
//  CallGithub
//
//  Created by leejungchul on 2022/03/24.
//

import Foundation

// 받아올 API 내용에 맞추어서 구조체를 생성
struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    // api 와 key 값을 맞춰주기 위해 사용
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
}
