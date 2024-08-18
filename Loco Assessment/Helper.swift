//
//  Helper.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation
import UIKit

extension UIView {

    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }


    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIColor {
    convenience init(hexString: String) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


class AlertManager {
    
    static func showErrorAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}

class ImageLoader {
    static func loadImage(from urlString: String, placeholder: String = "placeholder", into imageView: UIImageView, contentMode: UIView.ContentMode = .scaleToFill) {
        imageView.image = UIImage(named: placeholder)
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data) ?? UIImage(named: placeholder)
                imageView.contentMode = contentMode
            }
        }
        task.resume()
    }
}

extension UIView {
    func startShimmering() {
        // Force the layout to ensure the bounds are updated
        self.layoutIfNeeded()
        
        let light = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        let dark = UIColor.black.cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        
        // Set the gradient's frame to match the view's bounds
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering() {
        self.layer.mask = nil
    }
}

extension UISearchBar {
    func addShimmerToPlaceholder() {
        if let textField = self.value(forKey: "searchField") as? UITextField,
           let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
            placeholderLabel.startShimmering()
        }
    }
    
    func removeShimmerFromPlaceholder() {
        if let textField = self.value(forKey: "searchField") as? UITextField,
           let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
            placeholderLabel.stopShimmering()
        }
    }
}
