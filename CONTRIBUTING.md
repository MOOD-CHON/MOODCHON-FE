# CONTRIBUTING

# MOODCHON-FE 협업 가이드

MOODCHON-FE 프로젝트의 일관된 협업을 위해 아래 규칙을 사용합니다.

## 1. Label

사용하는 Label은 아래 6개로 통일합니다.

* `feat`: 새로운 기능 및 화면 구현
* `fix`: 버그 및 오류 수정
* `style`: UI 및 스타일 변경
* `refactor`: 기능 변화 없는 코드 구조 개선
* `chore`: 환경 설정, 패키지 및 프로젝트 설정
* `docs`: 문서 작성 및 수정

## 2. Issue

작업을 시작하기 전에 관련 Issue를 생성합니다.

Issue 제목은 아래 형식으로 작성합니다.

```text
[TYPE] 이슈 제목
```

예시:

```text
[FEAT] 촌캉스 생성 화면 구현
[FIX] 초대 코드 유효성 검사 수정
[STYLE] 알림 카드 UI 수정
[REFACTOR] 공통 버튼 구조 개선
[CHORE] Flutter 프로젝트 초기 설정
[DOCS] README 개발 규칙 작성
```

Issue의 Type에 맞는 Label을 함께 지정합니다.

Issue Template은 아래 네 종류를 제공합니다.

* `FEAT`
* `FIX`
* `REFACTOR`
* `CHORE`

`STYLE`, `DOCS` 이슈는 별도의 Template 없이 작성합니다.

## 3. Branch

브랜치는 반드시 관련 Issue를 생성한 후 생성합니다.

형식:

```text
{type}/#{issue-number}-{description}
```

사용 가능한 type:

```text
feat
fix
style
refactor
chore
docs
```

`description`은 영문 `kebab-case`로 간결하게 작성합니다.

예시:

```text
feat/#12-create-trip
fix/#21-invite-code-validation
style/#25-notification-card
refactor/#31-common-button
chore/#1-project-setup
docs/#40-readme
```

일반 기능 개발 및 수정 브랜치는 `develop` 브랜치에서 생성하며, 작업 완료 후 `develop` 브랜치를 대상으로 Pull Request를 생성합니다.

배포 시에는 `develop` 브랜치의 내용을 `main` 브랜치로 병합합니다.

```text
feat / fix / style / refactor / chore / docs
                      ↓
                   develop
                      ↓
                    main
```

## 4. Commit Message

Commit Message는 아래 형식을 사용합니다.

```text
type: 작업 내용
```

사용 가능한 type:

```text
feat
fix
style
refactor
chore
docs
```

예시:

```text
feat: 촌캉스 생성 화면 구현
fix: 초대 코드 유효성 검사 수정
style: 알림 카드 UI 수정
refactor: 공통 버튼 구조 개선
chore: Flutter 패키지 설정
docs: README 개발 규칙 추가
```

Type은 반드시 소문자로 작성합니다.

## 5. Pull Request

일반 작업의 Pull Request 대상 브랜치는 `develop`으로 설정합니다.

배포 시에만 `develop`에서 `main`으로 Pull Request를 생성합니다.

PR 제목은 Commit Message와 동일한 형식을 사용합니다.

```text
type: 작업 내용
```

예시:

```text
feat: 촌캉스 생성 화면 구현
fix: 초대 코드 유효성 검사 수정
```

PR 본문의 `관련 이슈`에 아래와 같이 Issue 번호를 작성합니다.

```text
closes #12
```

PR이 병합되면 연결된 Issue가 자동으로 닫힙니다.

PR 본문에는 다음 내용을 작성합니다.

* 작업 내용
* 스크린샷 (UI 변경이 있는 경우)
* 리뷰 포인트

## 6. 작업 흐름

작업은 아래 순서로 진행합니다.

1. Issue 생성
2. Issue Type에 맞는 Label 지정
3. `develop` 브랜치를 최신 상태로 업데이트
4. Issue 기반 작업 브랜치 생성
5. 작업 및 Commit
6. 원격 브랜치에 Push
7. `develop` 브랜치를 대상으로 Pull Request 생성
8. 변경 사항 확인 후 Merge
9. 작업 브랜치 삭제

배포 시에는 `develop`에서 `main`으로 Pull Request를 생성하여 병합합니다.