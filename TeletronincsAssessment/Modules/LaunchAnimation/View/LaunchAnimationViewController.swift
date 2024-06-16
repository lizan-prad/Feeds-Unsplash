//
//  LaunchAnimationViewController.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 16/06/2024.
//

import UIKit
import Lottie

class LaunchAnimationViewController: UIViewController {
    
    @IBOutlet weak var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimationView()
        startAnimation()
    }

    private func setupAnimationView() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
    }
    
    deinit {
        animationView.stop()
    }

    private func startAnimation() {
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            (UIApplication.shared.delegate as? AppDelegate)?.postListCoordinator?.transitionToMainViewController()
        }
    }
}
