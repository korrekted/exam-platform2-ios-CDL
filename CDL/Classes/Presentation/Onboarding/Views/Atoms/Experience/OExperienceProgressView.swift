//
//  OExperienceProgressView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 29.06.2021.
//

final class OExperienceProgressView: UIView {
    enum Period {
        case period1, period2, period3, period4
    }
    
    var period: Period = .period1 {
        didSet {
            moveSelectedView()
            moveCursorView()
        }
    }
    
    lazy var progressView = UIView()
    lazy var period1Button = UIButton()
    lazy var period2Button = UIButton()
    lazy var period3Button = UIButton()
    lazy var period4Button = UIButton()
    lazy var period1Label = UILabel()
    lazy var period4Label = UILabel()
    lazy var selectedView = UIView()
    lazy var cursorView = OExperienceCursor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moveSelectedView()
        moveCursorView()
    }
}

// MARK: Private
private extension OExperienceProgressView {
    func initialize() {
        progressView.frame.size = CGSize(width: 335.scale, height: 4.scale)
        progressView.frame.origin = CGPoint(x: 0, y: 35.scale)
        progressView.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        
        period1Button.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        period1Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period1Button.frame.origin = CGPoint(x: 0, y: 31.scale)
        period1Button.layer.cornerRadius = 6.scale
        
        period2Button.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        period2Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period2Button.frame.origin = CGPoint(x: 107, y: 31.scale)
        period2Button.layer.cornerRadius = 6.scale
        
        period3Button.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        period3Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period3Button.frame.origin = CGPoint(x: 221.scale, y: 31.scale)
        period3Button.layer.cornerRadius = 6.scale
        
        period4Button.backgroundColor = UIColor(integralRed: 60, green: 75, blue: 159)
        period4Button.frame.size = CGSize(width: 12.scale, height: 12.scale)
        period4Button.frame.origin = CGPoint(x: 323.scale, y: 31.scale)
        period4Button.layer.cornerRadius = 6.scale
        
        period1Label.attributedText = "Onboarding.Experience.Period1".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 245, green: 245, blue: 245, alpha: 0.6))
                            .font(Fonts.Lato.regular(size: 16.scale))
                            .lineHeight(22.4.scale))
        period1Label.frame.origin = CGPoint(x: 0, y: 0)
        period1Label.sizeToFit()
        
        period4Label.attributedText = "Onboarding.Experience.Period4".localized
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 245, green: 245, blue: 245, alpha: 0.6))
                            .font(Fonts.Lato.regular(size: 16.scale))
                            .lineHeight(22.4.scale))
        period4Label.sizeToFit()
        period4Label.frame.origin = CGPoint(x: 335.scale - period4Label.frame.width, y: 0)
        
        selectedView.backgroundColor = UIColor(integralRed: 249, green: 205, blue: 106)
        selectedView.frame.size = CGSize(width: 21.scale, height: 21.scale)
        selectedView.layer.cornerRadius = 10.5.scale
        
        cursorView.backgroundColor = UIColor.clear
        cursorView.frame.size = CGSize(width: 98.scale, height: 59.scale)
        
        [
            progressView,
            period1Button, period2Button, period3Button, period4Button,
            period1Label, period4Label,
            selectedView,
            cursorView
        ]
        .forEach { addSubview($0) }
    }
    
    func moveSelectedView() {
        switch period {
        case .period1:
            selectedView.center = period1Button.center
        case .period2:
            selectedView.center = period2Button.center
        case .period3:
            selectedView.center = period3Button.center
        case .period4:
            selectedView.center = period4Button.center
        }
    }
    
    func moveCursorView() {
        switch period {
        case .period1, .period4:
            cursorView.isHidden = true
        case .period2:
            cursorView.title = "Onboarding.Experience.Period2".localized
            cursorView.frame.origin = CGPoint(x: 71.scale, y: 59.scale)
            cursorView.isHidden = false
        case .period3:
            cursorView.title = "Onboarding.Experience.Period3".localized
            cursorView.frame.origin = CGPoint(x: 182.scale, y: 59.scale)
            cursorView.isHidden = false
        }
    }
}
