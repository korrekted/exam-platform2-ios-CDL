//
//  ColorsPalette.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 06.05.2021.
//

import UIKit

enum NavigationPalette {
    static let navigationBackground = UIColor(integralRed: 41, green: 55, blue: 137)
    static let navigationTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let navigationTrackTint = UIColor(integralRed: 60, green: 75, blue: 159)
    static let navigationProgressTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let tabTint = UIColor(integralRed: 41, green: 55, blue: 137)
    static let tabBarBackground = UIColor(integralRed: 245, green: 245, blue: 245)
}

enum TrophyPalette {
    static let background = UIColor(integralRed: 143, green: 207, blue: 99)
    static let title = UIColor(integralRed: 245, green: 245, blue: 245)
    static let buttonTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let buttonBackground = UIColor(integralRed: 41, green: 55, blue: 137)
}

enum StudyPalette {
    static let background = UIColor(integralRed: 245, green: 245, blue: 245)
    static let primaryButton = UIColor(integralRed: 249, green: 205, blue: 106)
    static let secondaryButton = UIColor(integralRed: 60, green: 75, blue: 159)
    static let primaryButtonText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryButtonText = UIColor(integralRed: 245, green: 245, blue: 245)
    static let title = UIColor(integralRed: 31, green: 31, blue: 31)
    
    enum Brief {
        static let selected = UIColor(integralRed: 60, green: 75, blue: 159)
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
        static let selectedText = UIColor(integralRed: 245, green: 245, blue: 245)
        static let weekdayText = UIColor(integralRed: 245, green: 245, blue: 245)
    }
    
    enum Course {
        static let selected = UIColor(integralRed: 41, green: 55, blue: 137)
        static let deselected = UIColor(integralRed: 232, green: 234, blue: 237)
        static let title = UIColor(integralRed: 31, green: 31, blue: 31)
        static let subtitle = UIColor(integralRed: 31, green: 31, blue: 31)
        static let selectedText = UIColor(integralRed: 245, green: 245, blue: 245)
        static let addCourse = UIColor(integralRed: 232, green: 234, blue: 237)
        static let progressText = UIColor(integralRed: 41, green: 55, blue: 137)
    }
    
    enum Mode {
        static let background = UIColor(integralRed: 232, green: 234, blue: 237)
        static let iconBackground = UIColor(integralRed: 60, green: 75, blue: 159)
        static let iconTint = UIColor(integralRed: 245, green: 245, blue: 245)
        static let markBackground = UIColor(integralRed: 249, green: 205, blue: 106)
        static let markText = UIColor(integralRed: 31, green: 31, blue: 31)
        static let title = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum ScorePalette {
    static let background = UIColor(integralRed: 249, green: 205, blue: 106)
    static let containerBackground = UIColor(integralRed: 245, green: 245, blue: 245)
    static let title = UIColor(integralRed: 31, green: 31, blue: 31)
    static let progress = UIColor(integralRed: 31, green: 31, blue: 31)
    static let progressWarning = UIColor(integralRed: 241, green: 104, blue: 91)
}

enum TestPalette {
    static let background = UIColor(integralRed: 245, green: 245, blue: 245)
    static let primaryButton = UIColor(integralRed: 249, green: 205, blue: 106)
    static let secondaryButton = UIColor(integralRed: 41, green: 55, blue: 137)
    static let primaryTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let questionText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let explanationTitle = UIColor(integralRed: 31, green: 31, blue: 31)
    static let explanationText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let bottomGradients = [UIColor.clear.cgColor, UIColor(integralRed: 241, green: 244, blue: 251).cgColor]
    
    enum Answer {
        static let text = UIColor(integralRed: 31, green: 31, blue: 31)
        static let selectedText = UIColor(integralRed: 245, green: 245, blue: 245)
        static let selectedBorder = UIColor(integralRed: 41, green: 55, blue: 137)
        static let initialBorder = UIColor(integralRed: 232, green: 234, blue: 237)
        static let warningBorder = UIColor(integralRed: 143, green: 207, blue: 99)
        static let initialBackground = UIColor(integralRed: 245, green: 245, blue: 245)
        static let incorrectBackground = UIColor(integralRed: 241, green: 104, blue: 91)
        static let correctBackground = UIColor(integralRed: 143, green: 207, blue: 99)
        static let warningBackground = UIColor(integralRed: 143, green: 207, blue: 99, alpha: 0.2)
    }
    
    enum QuestionNumber {
        static let background = UIColor(integralRed: 232, green: 234, blue: 237)
        static let text = UIColor(integralRed: 31, green: 31, blue: 31)
        static let selectedBackground = UIColor(integralRed: 41, green: 55, blue: 137)
        static let selectedText = UIColor(integralRed: 245, green: 245, blue: 245)
    }
}

enum CourseDetailsPalette {
    static let primaryButton = UIColor(integralRed: 232, green: 234, blue: 237)
    static let primaryTint = UIColor(integralRed: 41, green: 55, blue: 137)
    static let secondaryButton = UIColor(integralRed: 41, green: 55, blue: 137)
    static let secondaryTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let correctGradient = UIColor(integralRed: 143, green: 207, blue: 99)
    static let incorrectGradient = UIColor(integralRed: 241, green: 104, blue: 91)
    static let emptyGradient = UIColor(integralRed: 212, green: 216, blue: 221)
    static let title = UIColor(integralRed: 212, green: 216, blue: 221)
    static let subtitle = UIColor(integralRed: 68, green: 68, blue: 68)
    static let background = UIColor(integralRed: 245, green: 245, blue: 245)
    static let itemBackground = UIColor(integralRed: 232, green: 234, blue: 237)
}

enum SettingsPalette {
    static let background = UIColor(integralRed: 242, green: 245, blue: 252)
    static let itemBackground = UIColor(integralRed: 232, green: 234, blue: 237)
    static let itemTitle = UIColor(integralRed: 31, green: 31, blue: 31)
    static let buttonTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let unlockBackground = UIColor(integralRed: 249, green: 205, blue: 106)
    static let unlockTint = UIColor(integralRed: 31, green: 31, blue: 31)
}

enum CoursePalette {
    static let background = UIColor(integralRed: 245, green: 245, blue: 245)
}

enum PaygatePalette {
    static let background = UIColor(integralRed: 41, green: 55, blue: 137)
    static let continueButton = UIColor(integralRed: 249, green: 205, blue: 106)
    static let continueTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let primaryText = UIColor(integralRed: 245, green: 245, blue: 245)
    static let secondaryText = UIColor(integralRed: 245, green: 245, blue: 245)
    
    enum Option {
        static let selectedBackground = UIColor(integralRed: 249, green: 205, blue: 106)
        static let deselectedBorder = UIColor(integralRed: 249, green: 205, blue: 106)
        static let selectedText = UIColor(integralRed: 31, green: 31, blue: 31)
        static let deselectText = UIColor(integralRed: 245, green: 245, blue: 245)
        static let saveSelectedBackground = UIColor(integralRed: 245, green: 245, blue: 245)
        static let saveDeselectedBackground = UIColor(integralRed: 245, green: 245, blue: 245)
        static let saveSelectedText = UIColor(integralRed: 31, green: 31, blue: 31)
        static let saveDeselectedText = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum TestStatsPalette {
    static let background = UIColor(integralRed: 242, green: 245, blue: 252)
    static let primaryButton = UIColor(integralRed: 249, green: 205, blue: 106)
    static let secondaryButton = UIColor(integralRed: 232, green: 234, blue: 237)
    static let primaryText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let correct = UIColor(integralRed: 143, green: 207, blue: 99)
    static let incorrect = UIColor(integralRed: 241, green: 104, blue: 91)
    static let passingScore = UIColor(integralRed: 31, green: 31, blue: 31)
    static let answerText = UIColor(integralRed: 245, green: 245, blue: 245)
    static let separator = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.2)
    static let loader = UIColor(integralRed: 41, green: 55, blue: 137)
    
    enum Filter {
        static let selected = UIColor(integralRed: 31, green: 31, blue: 31)
        static let deselected = UIColor(integralRed: 31, green: 31, blue: 31, alpha: 0.6)
    }
    
    enum CommunityResult {
        static let value = UIColor(integralRed: 31, green: 31, blue: 31)
        static let subtitle = UIColor(integralRed: 31, green: 31, blue: 31)
    }
    
    enum Progress {
        static let text = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum StatsPalette {
    static let background = UIColor(integralRed: 245, green: 245, blue: 245)
    static let separator = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.05)
    
    enum Description {
        static let background = UIColor(integralRed: 232, green: 234, blue: 237)
        static let title = UIColor(integralRed: 31, green: 31, blue: 31)
        static let value = UIColor(integralRed: 31, green: 31, blue: 31)
    }
    
    enum Progress {
        static let testTaken = UIColor(integralRed: 41, green: 55, blue: 137)
        static let correctAnswers = UIColor(integralRed: 249, green: 205, blue: 106)
        static let questionsTaken = UIColor(integralRed: 198, green: 42, blue: 80)
    }
    
    enum MainStats {
        static let title = UIColor(integralRed: 68, green: 68, blue: 68)
        static let value = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum Splash {
    static let background = UIColor(integralRed: 41, green: 55, blue: 137)
    static let primaryText = UIColor(integralRed: 245, green: 245, blue: 245)
    static let secondaryText = UIColor(integralRed: 249, green: 205, blue: 106)
}

enum Onboarding {
    static let background = UIColor(integralRed: 41, green: 55, blue: 137)
    static let primaryText = UIColor(integralRed: 245, green: 245, blue: 245)
    static let secondaryText = UIColor(integralRed: 245, green: 245, blue: 245)
    static let primaryButton = UIColor(integralRed: 249, green: 205, blue: 106)
    static let primaryButtonTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryButton = UIColor.clear
    static let secondaryButtonBorder = UIColor(integralRed: 232, green: 234, blue: 237)
    static let secondaryButtonTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let pickerText = UIColor(integralRed: 245, green: 245, blue: 245)
    
    enum LanguageAndGender {
        static let background = UIColor(integralRed: 60, green: 75, blue: 159)
        static let border = UIColor(integralRed: 249, green: 205, blue: 106)
    }
    
    enum Goal {
        static let background = UIColor(integralRed: 60, green: 75, blue: 159)
        static let selectedBackground = UIColor(integralRed: 249, green: 205, blue: 106)
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
        static let selectedText = UIColor(integralRed: 31, green: 31, blue: 31)
    }
    
    enum Slider {
        static let minimumTrackTint = UIColor(integralRed: 249, green: 205, blue: 106)
        static let maximumTrackTint = UIColor(integralRed: 60, green: 75, blue: 159)
    }
    
    enum Question {
        static let containerBackground = UIColor(integralRed: 60, green: 75, blue: 159)
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
    }
    
    enum Preloader {
        static let background = UIColor(integralRed: 41, green: 55, blue: 137)
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
        static let progressTrack = UIColor(integralRed: 60, green: 75, blue: 159)
        static let progress = UIColor(integralRed: 249, green: 205, blue: 106)
    }
    
    enum Progress {
        static let track = UIColor(integralRed: 60, green: 75, blue: 159)
        static let progress = UIColor(integralRed: 245, green: 245, blue: 245)
    }
    
    enum Topics {
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
        static let selectedText = UIColor(integralRed: 31, green: 31, blue: 31)
        static let background = UIColor(integralRed: 60, green: 75, blue: 159)
        static let selectedBackground = UIColor(integralRed: 249, green: 205, blue: 106)
    }
}

enum FlashcardPalette {
    static let background = UIColor(integralRed: 232, green: 234, blue: 237)
    
    enum Card {
        static let background = UIColor(integralRed: 245, green: 245, blue: 245)
        static let progress = UIColor(integralRed: 68, green: 68, blue: 68)
        static let question = UIColor(integralRed: 31, green: 31, blue: 31)
        static let answer = UIColor(integralRed: 68, green: 68, blue: 68)
        static let buttonTint = UIColor(integralRed: 31, green: 31, blue: 31)
        static let primaryButton = UIColor(integralRed: 249, green: 205, blue: 106)
        static let secondaryButton = UIColor(integralRed: 232, green: 234, blue: 237)
    }
}
