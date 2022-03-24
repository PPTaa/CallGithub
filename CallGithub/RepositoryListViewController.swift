//
//  RepositoryListViewController.swift
//  CallGithub
//
//  Created by leejungchul on 2022/03/24.
//

import RxSwift
import UIKit

class RepositoryListViewController: UITableViewController {
    private let organization = "Apple"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바의 타이틀 지정
        title = organization + "Repositories"
        // 당겨서 새로고침 (api call)
        self.refreshControl = UIRefreshControl()
            
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .yellow
        refreshControl.tintColor = .red
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        // 당겼을때의 행동 지정
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
        tableView.rowHeight = 140
    }
    
    @objc func refresh() {
        
    }
}

// delegate, datasource
extension RepositoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        return cell
    }
}
