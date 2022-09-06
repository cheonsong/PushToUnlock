import UIKit
import Foundation
import RxSwift

public class PushToUnlock: UIView {
    
    /// Rx EventHandler
    public var isSuccess = PublishSubject<Void>()
    /// Closure EventHandler
    public var completion: (()->Void)? = nil
    /// Text Property
    public var text: String {
        get {
            return textLabel.text ?? ""
        }
        
        set {
            textLabel.text = newValue
        }
    }
    /// TextColor Property
    public var textColor: UIColor {
        get {
            return textLabel.textColor
        }
        
        set {
            textLabel.textColor = newValue
        }
    }
    /// TextFont Property
    public var textFont: UIFont {
        get {
            return textLabel.font
        }
        
        set {
            textLabel.font = newValue
        }
    }
    /// Swipe Button Color
    public var tint: UIColor {
        get {
            return swipeView.backgroundColor ?? .clear
        }
        
        set {
            swipeView.backgroundColor = newValue
        }
    }
    /// Backgound Color
    public var background: UIColor {
        get {
            return backgroundView.backgroundColor ?? .clear
        }
        
        set {
            backgroundView.backgroundColor = newValue
        }
    }
    
    /// Initializer
    /// - Parameter width: The total width
    /// - Parameter height: The total height
    /// Background and SwipeButton spacing 4
    public convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: .zero)
        
        self.width = width
        self.height = height
        
        addComponents()
        setConstraints()
        bind()
    }
    
    private var width: CGFloat = 240
    private var height: CGFloat = 64
    private lazy var successCnt: CGFloat = width - height
    private var disposeBag = DisposeBag()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = height / 2
        return view
    }()
    
    private lazy var swipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = (height - 8) / 2
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private lazy var constant: NSLayoutConstraint = {
        let constant = NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        return constant
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        completion = nil
        disposeBag = DisposeBag()
    }
    
    func addComponents() {
        [backgroundView, textLabel, swipeView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.init(item: self,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .height,
                                multiplier: 1.0,
                                constant: height).isActive = true
        
        NSLayoutConstraint.init(item: self,
                                attribute: .width,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .width,
                                multiplier: 1.0,
                                constant: width).isActive = true
        
        edgesEqualToSuperView(view: backgroundView)
        NSLayoutConstraint.init(item: backgroundView,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .height,
                                multiplier: 1.0,
                                constant: height).isActive = true
        
        NSLayoutConstraint.init(item: swipeView,
                                attribute: .left,
                                relatedBy: .equal,
                                toItem: backgroundView,
                                attribute: .left,
                                multiplier: 1.0,
                                constant: 4).isActive = true
        
        NSLayoutConstraint.init(item: swipeView,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .height,
                                multiplier: 1.0,
                                constant: height-8).isActive = true
        
        NSLayoutConstraint.init(item: swipeView,
                                attribute: .width,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .width,
                                multiplier: 1.0,
                                constant: height-8).isActive = true
        
        NSLayoutConstraint.init(item: swipeView,
                                attribute: .centerY,
                                relatedBy: .equal,
                                toItem: backgroundView,
                                attribute: .centerY,
                                multiplier: 1.0,
                                constant: 0).isActive = true
        
        
        constant.isActive = true

        NSLayoutConstraint.init(item: textLabel,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: backgroundView,
                                attribute: .centerX,
                                multiplier: 1.0,
                                constant: height * 0.3).isActive = true
        
        NSLayoutConstraint.init(item: textLabel,
                                attribute: .centerY,
                                relatedBy: .equal,
                                toItem: backgroundView,
                                attribute: .centerY,
                                multiplier: 1.0,
                                constant: 0).isActive = true
    }
    
    func bind() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeView.addGestureRecognizer(panGesture)
    }
    
    @objc func swipeAction(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.swipeView)
        let velocity = sender.velocity(in: self.swipeView)
        
        var transX: CGFloat = 0
        
        // 왼쪽으로 스와이프 불가능
        if translation.x <= 0 {
            self.textLabel.isHidden = false
            transX = max(translation.x, 0)
        } else {
            transX = min(self.successCnt,translation.x)
        }
        
        switch sender.state {
        
        case .changed:
            constant.constant = transX
            self.textLabel.isHidden = transX > 0
            
        case .ended:
            if transX == self.successCnt {
                self.isSuccess.onNext(())
                self.completion?()
                return
            }
            // 빠른속도로 스와이프 한 경우 종료됨
            else if velocity.x > 1000 {
                self.textLabel.isHidden = true
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.constant.constant = self!.successCnt
                    self?.layoutIfNeeded()
                }, completion: { [weak self] _ in
                    self?.isSuccess.onNext(())
                    self?.completion?()
                    return
                })
            }
            // 종료 실패
            else {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.constant.constant = 0
                    self?.layoutIfNeeded()
                }, completion: { [weak self] _ in
                    self?.textLabel.isHidden = false
                })
            }
        default:
            break
        }
    }
    
    private func edgesEqualToSuperView(view: UIView) {
        NSLayoutConstraint.init(item: view,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .top,
                                multiplier: 1.0,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: view,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .bottom,
                                multiplier: 1.0,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: view,
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .right,
                                multiplier: 1.0,
                                constant: 0).isActive = true
        
    }
}
