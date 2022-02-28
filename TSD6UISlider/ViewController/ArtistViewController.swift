//
//  ArtistViewController.swift
//  TSD6UISlider
//
//  Created by Дмитрий Геращенко on 10.02.2022.
//

import UIKit
import AVFoundation

final class ArtistViewController: UIViewController {
    
    private var player = AVAudioPlayer()
    private var displayLink = CADisplayLink()
    private var isPlaying = false
    
    private let artistImage = UIImageView()
    private let artistLabel = UILabel()
    private let playerDurationSlider = UISlider()
    private let playPauseButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: configureDetailView
    // Function that fetch and load data from ArtistTableViewController
    
    func configureDetailView(with artist: Artist) {
        artistImage.image = UIImage(named: artist.image)
        artistLabel.text = artist.composition
        
        guard let url = Bundle.main.url(forResource: artist.composition, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            playerDurationSlider.minimumValue = 0.0
            playerDurationSlider.maximumValue = Float(player.duration)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: configureUI
    // Function that configure all the user interface
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureArtistImage()
        configureArtistLabel()
        configurePlayerDurationSlider()
        configurePlayPauseButton()
    }
    
    // MARK: Creeate Artist Image
    
    private func configureArtistImage() {
        artistImage.contentMode = .scaleAspectFill
        artistImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(artistImage)
        
        NSLayoutConstraint.activate([
            artistImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            artistImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            artistImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Create Artitst and composition label
    
    private func configureArtistLabel() {
        artistLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(artistLabel)
        
        NSLayoutConstraint.activate([
            artistLabel.topAnchor.constraint(equalTo: artistImage.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: Create player duration slider
    
    private func configurePlayerDurationSlider() {
        playerDurationSlider.tintColor = .systemGray
        playerDurationSlider.thumbTintColor = .systemRed
        playerDurationSlider.addTarget(self, action: #selector(playerSliderValueChanged(sender:)), for: .touchDragInside)
        playerDurationSlider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playerDurationSlider)
        
        NSLayoutConstraint.activate([
            playerDurationSlider.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 30),
            playerDurationSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            playerDurationSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: Create play and pause button
    
    private func configurePlayPauseButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        playPauseButton.tintColor = .systemRed
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: playerDurationSlider.bottomAnchor, constant: 20),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 50),
            playPauseButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        artistImage.layer.cornerRadius = 15
        artistImage.clipsToBounds = true
    }
    
    // MARK: play/pause button tapped function
    // Call on play/pause button tapped
    // Changing isPlaying variable and play/pause button image
    
    @objc private func playPauseButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.isPlaying {
                self.displayLink.invalidate()
                self.player.pause()
                sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                self.displayLink = CADisplayLink(target: self, selector: #selector(self.updatePlayerDurationSlider))
                self.displayLink.preferredFramesPerSecond = 2
                self.displayLink.add(to: RunLoop.current, forMode: .common)
                self.player.play()
                sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            self.isPlaying.toggle()
        }
    }
    
    // MARK: Slider value changed function
    // Call on .valueChanged
    
    @objc private func playerSliderValueChanged(sender: UISlider) {
        if isPlaying {
            player.pause()
            player.currentTime = TimeInterval(sender.value)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.player.play()
            }
        } else {
            player.currentTime = TimeInterval(sender.value)
        }
    }
    // MARK: Function that update slider value with player duration progress
    // Call when play/pause button tapped
    
    @objc private func updatePlayerDurationSlider() {
        playerDurationSlider.setValue(Float(player.currentTime), animated: true)
    }
}
