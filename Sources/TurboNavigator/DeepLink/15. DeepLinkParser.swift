//
//  DeepLinkParser.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/31/26.
//

import Foundation

/// 외부에서 전달된 URL을 앱 내부에서 이해할 수 있는 DeepLink로 변환하는 프로토콜.
///
/// - Description:
///   URL Scheme, Universal Link, 푸시 알림 링크 등을 해석하여
///   타입 안전한 DeepLink<Route>로 변환합니다.
///
/// - 역할:
///   - URL → Route 변환
///   - 네비게이션에 필요한 정보 추출 (path, query, parameter 등)
///   - 잘못된 URL 필터링 (유효하지 않으면 nil 반환)
///
/// - 특징:
///   - 앱의 라우팅 구조와 강하게 연결됨
///   - Route 타입을 기반으로 타입 안전한 딥링크 처리 가능
///   - 여러 parser를 구성하여 확장 가능
///
/// - Note:
///   이 프로토콜은 "해석"만 담당하며,
///   실제 화면 이동은 Navigator / Coordinator가 수행합니다.
///
/// - Example:
///   URL: myapp://detail?id=42
///   → DeepLink(route: .detail(id: "42"), action: .push)
///
/// - Generic:
///   - Route: 앱에서 사용하는 라우트 타입 (Hashable)
public protocol DeepLinkParser {
    
    associatedtype Route: Hashable
    
    /// URL을 분석하여 DeepLink로 변환
    ///
    /// - Parameter url: 외부에서 전달된 URL (scheme, universal link 등)
    /// - Returns:
    ///   변환된 DeepLink (유효하지 않으면 nil)
    func parse(url: URL) -> DeepLink<Route>?
}
