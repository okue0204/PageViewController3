//
//  ViewController.swift
//  PageViewController3
//
//  Created by 奥江英隆 on 2024/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    private enum Tag: CaseIterable {
        case latest
        case program
        case donwload
        case playlit
        
        var title: String {
            switch self {
            case .latest:
                "最新"
            case .program:
                "番組"
            case .donwload:
                "ダウンロード済み"
            case .playlit:
                "再生リスト"
            }
        }
    }
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let viewControllers: [UIViewController] = [
        UIStoryboard.vc2Storyboard.instantiateInitialViewController()!,
        UIStoryboard.vc3Storyboard.instantiateInitialViewController()!,
        UIStoryboard.vc4Storyboard.instantiateInitialViewController()!,
        UIStoryboard.vc5Storyboard.instantiateInitialViewController()!
    ]
    
    private var currentAnimationViewPositionX: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageContainerView.addSubview(pageViewController.view)
        pageViewController.view.topAnchor.constraint(equalTo: pageContainerView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: pageContainerView.bottomAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor).isActive = true
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: false)
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: viewController) {
            // 次のボタンのcenterX
            let afterButtonCenterX = stackView.arrangedSubviews.compactMap {
                $0 as? UIButton
            }[index].center.x
            
            // animationViewを動かす
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self,
                      let firstButton = stackView.arrangedSubviews.first as? UIButton else {
                    return
                }
                animationView.transform = CGAffineTransform(translationX: afterButtonCenterX - firstButton.center.x, y: 0)
            }
            pageControl.currentPage = index
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController),
           viewControllers.count - 1 > index {
            return viewControllers[index + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController),
           0 < index {
            return viewControllers[index - 1]
        }
        return nil
    }
}

