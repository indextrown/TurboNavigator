//
//  DeepLink.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/31/26.
//

import Foundation

/// 네비게이션 시스템에서 사용할 수 있는 타입 안전한 딥링크 모델.
///
/// - Description:
///   외부 URL, 푸시 알림, 앱 내부 이벤트 등을 통해 특정 화면으로 이동할 때
///   어떤 route들을 어떤 방식으로 적용할지 정의합니다.
///
/// - 구성 요소:
///   - routes: 이동할 화면들의 경로 배열 (stack 형태로 사용 가능)
///   - action: 해당 routes를 어떤 방식으로 적용할지에 대한 전략
///     (예: push, replace, present 등)
///
/// - 특징:
///   - 타입 안전한 Route 기반 딥링크 처리
///   - 단일 화면 이동뿐만 아니라 여러 화면을 stack 형태로 구성 가능
///   - Navigator / Coordinator와 함께 사용하여 일관된 네비게이션 처리 가능
///
/// - 사용 예:
///   - 푸시 알림 클릭 시 특정 화면으로 이동
///   - URL 스킴을 통한 앱 내부 특정 경로 진입
///   - 로그인 이후 특정 화면으로 리다이렉트
///
/// - Note:
///   DeepLink는 단순 데이터 모델이며,
///   실제 네비게이션 처리는 Navigator 또는 Coordinator에서 수행합니다.
///
/// - Generic:
///   - Route: Hashable을 준수하는 라우트 타입
public struct DeepLink<Route: Hashable> {
    
    /// 이동할 화면들의 route 목록
    ///
    /// - Note:
    ///   배열 순서대로 stack이 구성됩니다.
    ///   예: [.home, .detail(id: "1")] → Home → Detail 순으로 push
    public let routes: [Route]
    
    /// routes를 어떻게 적용할지 결정하는 액션
    ///
    /// - Example:
    ///   - `.push`: 현재 스택 위에 추가
    ///   - `.replace`: 기존 스택을 교체
    public let action: DeepLinkAction
    
    /// 여러 개의 route를 포함하는 딥링크 생성자
    ///
    /// - Parameters:
    ///   - routes: 이동할 route 배열
    ///   - action: 적용 방식
    public init(routes: [Route], action: DeepLinkAction) {
        self.routes = routes
        self.action = action
    }
    
    /// 단일 route를 위한 편의 생성자
    ///
    /// - Parameters:
    ///   - route: 이동할 단일 route
    ///   - action: 적용 방식
    public init(route: Route, action: DeepLinkAction) {
        self.init(routes: [route], action: action)
    }
}
