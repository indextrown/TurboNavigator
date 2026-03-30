//
//  File.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/31/26.
//

import Foundation

/// 딥링크로 해석된 route들을 네비게이션 스택에 어떻게 적용할지 정의하는 타입.
///
/// - Description:
///   DeepLink에 포함된 route들을 어떤 방식으로 화면에 반영할지 결정합니다.
///   Navigator 또는 Coordinator에서 해당 action을 해석하여 실제 화면 전환을 수행합니다.
///
/// - Case:
///   - push:
///     현재 네비게이션 스택 위에 route들을 순차적으로 추가합니다.
///
///   - replace:
///     기존 네비게이션 스택을 제거하고 새로운 route들로 전체를 교체합니다.
///
///   - present(style:):
///     새로운 modal stack을 생성하여 route들을 표시합니다.
///     내부적으로 UINavigationController를 생성하여 modal 형태로 표시할 수 있습니다.
///
/// - Note:
///   DeepLinkAction은 "어떻게 이동할지"만 정의하며,
///   실제 화면 전환 로직은 Navigator / Coordinator에서 처리됩니다.
///
/// - Example:
///   push → 현재 화면 위에 detail 추가
///   replace → 로그인 후 홈으로 전체 교체
///   present → 모달로 새로운 흐름 시작
public enum DeepLinkAction {
    
    /// 현재 스택 위에 route들을 push
    case push
    
    /// 기존 스택을 새로운 route들로 교체
    case replace
    
    /// modal로 새로운 화면 흐름을 표시
    ///
    /// - Parameter style:
    ///   modal 표시 방식 (기본값: automatic)
    case present(style: ModalPresentationStyle = .automatic)
}
