import UIKit
import Foundation

class CachedImageView: UIImageView {
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let aiv = UIActivityIndicatorView(style: .large)
            aiv.translatesAutoresizingMaskIntoConstraints = false
            return aiv
        } else {
            let aiv = UIActivityIndicatorView(style: .white)
            
            aiv.translatesAutoresizingMaskIntoConstraints = false
            return aiv
        }
  
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutActivityIndicator() {
        activityIndicatorView.removeFromSuperview()
        
        addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        if self.image == nil {
            activityIndicatorView.startAnimating()
        }
    }

    // MARK: - Properties
    func downloadImageFrom(url: URL) {
        ImageCache.publicCache.load(url: url as NSURL) { image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
}
