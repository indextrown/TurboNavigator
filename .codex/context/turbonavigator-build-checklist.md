# TurboNavigator Build Checklist

이 문서는 TurboNavigator 작업을 구현할 때 따라야 하는 체크리스트다.

## 0. 운영 규칙

- [ ] 구현 전 기존 open issue를 먼저 찾는다.
- [ ] 관련 issue가 없으면 새 issue를 만든다.
- [ ] 브랜치는 issue 번호가 들어간 `codex/<type>-<issue-number>-<short-slug>` 형식을 우선 사용한다.
- [ ] 모든 커밋은 issue 브랜치에서만 만든다.
- [ ] 구현이 끝나면 PR을 만든다.
- [ ] PR 제목은 이슈가 있으면 `[#<issue-number>] <issue-title>` 형식을 따른다.
- [ ] PR 생성 후에는 사용자 승인 대기 상태로 멈춘다.
- [ ] 사용자가 명시적으로 요청하지 않으면 merge, 후속 원격 write, 범위 확장을 하지 않는다.

## 1. 변경 전 확인

- [ ] 변경이 core navigator, registry, coordinator, adapter, deep link, debug, demo, docs 중 어디에 속하는지 분류한다.
- [ ] public API 변경 여부를 확인한다.
- [ ] iOS 13 호환성에 영향이 있는지 확인한다.
- [ ] SwiftUI-only 앱과 UIKit 혼합 앱 양쪽에 영향이 있는지 확인한다.
- [ ] README 또는 demo 업데이트가 필요한지 확인한다.

## 2. 구현 기준

- [ ] route identity가 필요한 화면은 `AnyRouteIdentifiable` 또는 `WrappingController` 경로로 추적 가능해야 한다.
- [ ] modal이 떠 있을 때 active stack 우선순위가 깨지지 않아야 한다.
- [ ] tab stack은 탭별 독립 navigation controller를 유지해야 한다.
- [ ] deep link는 URL parsing과 route action 실행을 분리해야 한다.
- [ ] debug snapshot은 root/tab/modal 상태를 route 기준으로 설명해야 한다.

## 3. 테스트와 검증

- [ ] route stack 연산은 단위 테스트를 우선 검토한다.
- [ ] SwiftUI bridge 또는 UIKit controller 변경은 demo build를 검토한다.
- [ ] 문서-only 변경은 `git diff --check`를 최소 검증으로 실행한다.
- [ ] 실행하지 못한 검증은 PR에 이유를 적는다.

## 4. 하지 말아야 할 일

- [ ] issue 범위를 넘는 public API 재설계를 함께 하지 않는다.
- [ ] unrelated demo나 generated 파일을 stage하지 않는다.
- [ ] `.codex/logs/*.jsonl`, `.env`, 인증키, 빌드 산출물을 커밋하지 않는다.
- [ ] SwiftUI `NavigationStack`으로 엔진을 바꾸는 방향을 기본값으로 두지 않는다.
