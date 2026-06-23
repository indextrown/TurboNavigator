# TurboNavigator Codex 운영 가이드라인

이 문서는 TurboNavigator 저장소에서 Codex 설정, 프로젝트 컨텍스트, 로컬 스킬이 Swift Package 문맥으로 동작하는지 확인하기 위한 기준이다.

## 기준 파일

- `README.md`
- `README.en.md`
- `Package.swift`
- `.codex/context/turbonavigator-architecture.md`
- `.codex/context/turbonavigator-build-checklist.md`
- `.codex/prompts/researcher.md`
- `.codex/prompts/planner.md`
- `.codex/prompts/reviewer.md`
- `.agents/skills/planning-pipeline/SKILL.md`
- `.agents/skills/auto-commit-push/SKILL.md`
- `.agents/skills/auto-pr/SKILL.md`

## Codex CLI 시작 예시

### 계획/분석용

```bash
codex --cd "/Users/kimdonghyeon/2025/개발/라이브러리/TurboNavigator" \
  --model gpt-5.4 \
  -c model_reasoning_effort='"xhigh"' \
  -c service_tier='"fast"' \
  --enable goals \
  --sandbox read-only \
  --ask-for-approval on-request
```

### 구현용

```bash
codex --cd "/Users/kimdonghyeon/2025/개발/라이브러리/TurboNavigator" \
  --model gpt-5.4 \
  -c model_reasoning_effort='"xhigh"' \
  -c service_tier='"fast"' \
  --enable goals \
  --sandbox workspace-write \
  --ask-for-approval on-request
```

## 로딩 확인 포인트

1. Codex를 저장소 루트에서 시작한다.
2. 시작 후 `/hooks`로 `.codex/hooks.json`이 로드됐는지 확인한다.
3. 현재 적용된 저장소 문맥 요약을 요청해 TurboNavigator 문맥이 반영되는지 확인한다.
4. 테스트 프롬프트를 한 번 입력한 뒤 `.codex/logs/*.jsonl`에 로그가 기록되는지 확인한다.

## 추천 alias

```bash
alias turbonav-codex-plan='codex --cd "/Users/kimdonghyeon/2025/개발/라이브러리/TurboNavigator" --model gpt-5.4 -c model_reasoning_effort='"'"'"xhigh"'"'"' -c service_tier='"'"'"fast"'"'"' --enable goals --sandbox read-only --ask-for-approval on-request'
alias turbonav-codex-impl='codex --cd "/Users/kimdonghyeon/2025/개발/라이브러리/TurboNavigator" --model gpt-5.4 -c model_reasoning_effort='"'"'"xhigh"'"'"' -c service_tier='"'"'"fast"'"'"' --enable goals --sandbox workspace-write --ask-for-approval on-request'
```

## 동작 검증 시나리오

### 1. Plan-first 확인

```text
TurboNavigator의 deep link 처리 구조를 개선하기 전에 구현 방향을 먼저 정리해줘.
```

정상 동작 기준:

- 바로 파일을 수정하지 않는다.
- Researcher, Planner, Reviewer 관점으로 현재 구조와 리스크를 나눈다.
- route registry, navigator, stack/modal/tab/deep link 영향 범위를 분리한다.
- 이슈 생성 또는 재사용, 이슈 브랜치, 커밋, PR, 사용자 승인 대기 흐름이 포함된다.

### 2. Project Skill 확인

```text
planning-pipeline 기준으로 tab stack 전환 정책 개선 방향을 잡아줘.
```

정상 동작 기준:

- 변경 범위를 하나의 navigation slice로 제한한다.
- UIKit coordinator와 SwiftUI bridge 영향 범위를 구분한다.
- 테스트, demo build, README 업데이트 필요 여부를 함께 제시한다.

## 로그 확인 예시

```bash
tail -n 5 .codex/logs/prompts.jsonl
tail -n 5 .codex/logs/tools.jsonl
tail -n 5 .codex/logs/turns.jsonl
```

## 주의 사항

- `.codex/logs/`는 로컬 추적용이며 커밋 대상이 아니다.
- Hook을 추가하거나 수정한 뒤에는 새 Codex 세션을 시작한다.
- navigation 설계 기준이 바뀌면 `.codex/context/turbonavigator-architecture.md`와 관련 스킬 문서를 같이 갱신한다.
