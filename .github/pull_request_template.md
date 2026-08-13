# MOODCHON-FE GitHub 협업 규칙

## 1. Label

사용하는 Label은 아래 6개로 통일합니다.

* `feat`
* `fix`
* `style`
* `refactor`
* `chore`
* `docs`

---

## 2. Issue 제목

이슈 제목은 아래 형식으로 작성합니다.

```text
[라벨] 이슈 제목
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

---

## 3. Issue Template

Issue Template은 `FEAT`, `FIX`, `REFACTOR`, `CHORE` 네 종류만 사용합니다.

### FEAT

```md
## 기능 설명

<!-- 구현할 기능에 대해 작성해주세요. -->



## 작업 내용

<!-- 해당 이슈에서 진행할 작업 내용을 작성해주세요. -->


```

### FIX

```md
## 버그 내용

<!-- 발생한 버그에 대해 작성해주세요. -->



## 기대 동작

<!-- 정상적으로 동작해야 하는 내용을 작성해주세요. -->



## 작업 내용

<!-- 해당 이슈에서 진행할 작업 내용을 작성해주세요. -->


```

### REFACTOR

```md
## 작업 배경

<!-- 리팩토링이 필요한 배경을 작성해주세요. -->



## 작업 내용

<!-- 해당 이슈에서 진행할 작업 내용을 작성해주세요. -->


```

### CHORE

```md
## 작업 배경

<!-- 해당 작업이 필요한 배경을 작성해주세요. -->



## 작업 내용

<!-- 해당 이슈에서 진행할 작업 내용을 작성해주세요. -->


```

`STYLE`, `DOCS` 이슈는 별도의 템플릿을 생성하지 않습니다.

---

## 4. Branch Naming

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

description은 영문 `kebab-case`로 간결하게 작성합니다.

예시:

```text
feat/#12-create-trip
fix/#21-invite-code-validation
style/#25-notification-card
refactor/#31-common-button
chore/#1-project-setting
docs/#40-readme
```

---

## 5. Commit Message

커밋 메시지는 아래 형식을 사용합니다.

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

---

## 6. Pull Request 제목

PR 제목도 Commit Message와 동일한 형식을 사용합니다.

```text
type: 작업 내용
```

예시:

```text
feat: 촌캉스 생성 화면 구현
fix: 초대 코드 유효성 검사 수정
```

---

## 7. Pull Request Template

```md
## 관련 이슈

closes #

## 작업 내용

<!-- 이 PR에서 변경한 내용을 작성해주세요. -->



## 스크린샷

<!-- UI 변경이 있는 경우 스크린샷을 첨부해주세요. -->



## 리뷰 포인트

<!-- 리뷰어가 중점적으로 확인했으면 하는 내용을 작성해주세요. -->


```

`closes #이슈번호`를 작성하면 PR이 기본 브랜치에 병합될 때 연결된 Issue를 자동으로 닫을 수 있습니다.
