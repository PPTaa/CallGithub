//
//  RepositoryListViewController.swift
//  CallGithub
//
//  Created by leejungchul on 2022/03/24.
//

import RxSwift
import RxCocoa
import UIKit

class RepositoryListViewController: UITableViewController {
    private let organization = "ReactiveX"
    // 레포지토리로 BehaviorSubject를 받고 초기값은 빈 배열로 설정
    private let repositories = BehaviorSubject<[Repository]>(value: [])
    // 사용할 disposeBag 구성
    private let disposeBag = DisposeBag()
 
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
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.fetchRepositories(of: self.organization)
            
        }
    }
    
    func fetchRepositories(of organization: String) {
        Observable.from([organization])
            .map { organization -> URL in
                // organization 문자열을 URL로 변경
                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
            .map { url -> URLRequest in
                // url을 URLRequest로 변환
                var request = URLRequest(url: url)
                // 메서드 타입 지정
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                // HTTPURLResponse과 Data를 튜플로 받는 Observable로 방출
                // URLSession.shared.rx.response 는 위와같은 튜플로 반환해줌
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in
                // response.statusCode가 200 ~ 300 사이에 속하는지 여부 판단 (~=)
                return 200 ..< 300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                // jsonObject 로변환하고 결과값을 [[String: Any]] 형식으로 제작
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                          return []
                      }
                return result
            }
            .filter { result in
                // 결과값이 없으면 filter
                return result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Repository? in //compactMap은 nil을 자동적으로 제거
                    // 가져온 dic값들 중에 키값에 따라서 guard let 으로 옵셔널 해제
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                              return nil
                          }
                    // Repository객체로 변환
                    return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
            }
            .subscribe(onNext: { [weak self] newRepositories in // 구독함으로 방출
                self?.repositories.onNext(newRepositories)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}

// delegate, datasource
extension RepositoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try repositories.value().count
        } catch {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        // 현재의 레포지토리를 바로 꺼내오기
        var currentRepo: Repository? {
            do {
                return try repositories.value()[indexPath.row]
            } catch {
                return nil
            }
        }
        
        cell.repository = currentRepo
        
        return cell
    }
}
