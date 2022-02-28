//
//  MusicTableViewCell.swift
//  TSD6UISlider
//
//  Created by Дмитрий Геращенко on 10.02.2022.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {

    static let reuseIdentifier = "cellId"
    
    private let artistImage = UIImageView()
    private let nameLabel = UILabel()
    private let durationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        configureArtistImage()
        configureNameLabel()
        configureDurationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let musicImageSize = contentView.frame.size.height - 6
        let durationLabelSize = CGFloat(50)
        // musicImage
        
        artistImage.frame = CGRect(x: 8,
                                  y: 3,
                                  width: musicImageSize,
                                  height: musicImageSize)
        // nameLabel
        nameLabel.frame = CGRect(x: artistImage.frame.size.width + 10,
                                 y: 0,
                                 width: contentView.frame.size.width - 10 - artistImage.frame.size.width - durationLabelSize,
                                 height: contentView.frame.size.height)
        
        // durationLabel
        durationLabel.frame = CGRect(x: contentView.frame.size.width - durationLabelSize,
                                 y: 3,
                                 width: durationLabelSize,
                                 height: contentView.frame.size.height)
        
    }
    
    func configureCell(image: String, artist: String, durationText: String) {
        artistImage.image = UIImage(named: image)
        nameLabel.text = artist
        durationLabel.text = durationText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        durationLabel.text = nil
    }
    
    private func configureArtistImage() {
        artistImage.clipsToBounds = true
        artistImage.contentMode = .scaleAspectFill
        
        contentView.addSubview(artistImage)
    }
    private func configureNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        contentView.addSubview(nameLabel)
    }
    
    private func configureDurationLabel() {
        durationLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        contentView.addSubview(durationLabel)
    }
}
