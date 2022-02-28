//
//  ViewController.swift
//  TSD6UISlider
//
//  Created by Дмитрий Геращенко on 10.02.2022.
//

import UIKit
import AVFoundation

final class ArtistTableViewController: UIViewController {
    
    private let artists = [
        Artist(image: "Agnes Obel", artist: "Agnes Obel", composition: "Agnes Obel - September Song"),
        Artist(image: "Brian Eno", artist: "Brian Eno", composition: "Brian Eno - An Ending (Ascent)")
    ]
    private let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.title = "Music"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
    }
}

extension ArtistTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.reuseIdentifier, for: indexPath) as? MusicTableViewCell else { return UITableViewCell() }
        
        if let audioPath = Bundle.main.path(forResource: artists[indexPath.row].composition, ofType: "mp3") {
            let pathURL = URL(fileURLWithPath: audioPath)
            let asset = AVURLAsset(url: pathURL)
            let durationCMTime = asset.duration
            let audioDurationInSeconds = Int(CMTimeGetSeconds(durationCMTime))
            let minutes = audioDurationInSeconds / 60
            let seconds = audioDurationInSeconds % 60
            
            cell.configureCell(image: artists[indexPath.row].image, artist: artists[indexPath.row].artist, durationText: "\(minutes):\(seconds)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        let artistDetailViewController = ArtistViewController()
        artistDetailViewController.configureDetailView(with: artist)
        navigationController?.present(artistDetailViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
