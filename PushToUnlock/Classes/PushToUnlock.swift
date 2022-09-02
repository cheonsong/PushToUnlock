import UIKit
import Foundation

public class PushToUnlock: UIView {
    //    let disposeBag = DisposeBag()
    
    
    private var width: CGFloat = 240
    private var height: CGFloat = 64
    
    private lazy var successCnt: CGFloat = width - height
    // 스와이프 성공여부
//    var isSuccess = PublishRelay<Bool>()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 64 / 2
        return view
    }()
    
    private lazy var swipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 56 / 2
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Push To Unlock"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private lazy var constant: NSLayoutConstraint = {
        let constant = NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        return constant
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        setConstraints()
        bind()
    }
    
    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: .zero)
        
        self.width = width
        self.height = height
        
        addComponents()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    func addComponents() {
        [backgroundView, textLabel, swipeView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints() {
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
                                attribute: .right,
                                relatedBy: .equal,
                                toItem: backgroundView,
                                attribute: .right,
                                multiplier: 1.0,
                                constant: -40).isActive = true
        
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
        self.addGestureRecognizer(panGesture)
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
//                self.isSuccess.accept(true)
                return
            }
            // 빠른속도로 스와이프 한 경우 종료됨
            else if velocity.x > 1000 {
                self.textLabel.isHidden = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.constant.constant = self.successCnt
                    self.layoutIfNeeded()
                }, completion: { _ in
//                    self.isSuccess.accept(true)
                    return
                })
            }
            // 종료 실패
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.constant.constant = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.textLabel.isHidden = false
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
