//
//  RepositoryListCell.swift
//  CallGithub
//
//  Created by leejungchul on 2022/03/24.
//

import UIKit
import SnapKit

class RepositoryListCell: UITableViewCell {
    var repository: Repository?
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let starImageView = UIImageView()
    let starLabel = UILabel()
    let languageLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            nameLabel, descriptionLabel,
            starImageView, starLabel, languageLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        guard let repository = repository else { return }
        // 기본 설정
        nameLabel.text = repository.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        descriptionLabel.text = repository.description
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 2
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .orange
        
        starLabel.text = "\(repository.stargazersCount)"
        starLabel.font = .systemFont(ofSize: 16)
        starLabel.textColor = .gray
        
        languageLabel.text = repository.language
        languageLabel.font = .systemFont(ofSize: 16)
        languageLabel.textColor = .gray
        
        nameLabel.snp.makeConstraints {
            // 탑 리딩 트레일링을 슈퍼뷰의 18만큼씩 안쪽으로떨어트림
            $0.top.leading.trailing.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            // 탑을 nameLabel에서 3 떨어트림
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            // 리딩 트레일링을 nameLabel과 동일하게
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        starImageView.snp.makeConstraints {
            // 탑을 descriptionLabel에서 8 떨어트림
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            // 리딩을 descriptionLabel과 동일하게
            $0.leading.equalTo(descriptionLabel)
            // 높이 너비를 20으로 고정
            $0.width.height.equalTo(20)
            // 하단을 슈퍼뷰와 18 떨어지게
            $0.bottom.equalToSuperview().inset(18)
        }
        
        starLabel.snp.makeConstraints {
            // Y축 중심을 starImageView와 동일하게
            $0.centerY.equalTo(starImageView)
            // 리딩을 starImageView의 트레일링에서 5 떨어지게
            $0.leading.equalTo(starImageView.snp.trailing).offset(5)
        }
        
        languageLabel.snp.makeConstraints {
            // Y축 중심을 starLabel와 동일하게
            $0.centerY.equalTo(starLabel)
            // 리딩을 starLabel의 트레일링에서 12 떨어지게
            $0.leading.equalTo(starLabel.snp.trailing).offset(12)
        }
        
        
    }
}
