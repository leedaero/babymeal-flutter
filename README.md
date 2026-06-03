# 🥣 치밀한 이유식

> 아기의 이유식을 더 스마트하게 — 재고 관리부터 식단 스케줄까지 한 앱에서

---

## 소개

**치밀한 이유식**은 이유식을 준비하는 부모를 위한 올인원 관리 앱입니다.  
냉동 큐브 재고를 실시간으로 추적하고, 날짜별 식단을 계획하며, 알러지 테스트 이력까지 꼼꼼하게 기록할 수 있습니다.

---

## 주요 기능

### 📦 재고 관리
- 이유식 재료를 **큐브(cube)** 단위로 등록 및 추적
- 카테고리 필터 (채소 / 과일 / 단백질 / 곡물 / 유제품 / 기타)
- 재고 부족 알림 — 3개 이하 시 자동 경고
- 제조일 기준 **90일 초과 시 유통기한 경고**
- 이모지·색상으로 재료를 한눈에 구분

### 🗓 식단 스케줄
- 캘린더 뷰로 날짜별 식단 등록·확인
- 하루 5끼 구분: 아침 / 오전간식 / 점심 / 오후간식 / 저녁
- 식단 상태 관리: `예정` / `완료` / `건너뜀`
- 재료별 그람수(g) 표시로 정확한 섭취량 기록
- 노트 추가로 특이사항 메모

### 🧪 알러지 테스트
- 신규 재료 첫 시도 날짜를 캘린더에 기록
- 알러지 반응 여부 및 메모 관리
- 이유식 `tried` 타입으로 일반 식단과 분리 관리

### 📊 통계
- 재료별 사용 현황 바 차트
- 재고 부족 재료 한눈에 파악
- 통계 결과 이미지로 공유 기능

### 🔔 푸시 알림
- Firebase Cloud Messaging(FCM) 기반 실시간 알림
- 재고 부족·식단 알림 수신

---

## 기술 스택

| 분류 | 내용 |
|------|------|
| Framework | Flutter 3 (Dart) |
| 상태 관리 | Riverpod 2 |
| HTTP 통신 | Dio |
| 인증 | JWT (flutter_secure_storage) |
| 알림 | Firebase Messaging + flutter_local_notifications |
| 캘린더 | table_calendar |
| 차트 | fl_chart |
| 백엔드 | REST API ([leedaero/babymeal](https://github.com/leedaero/babymeal)) |

---

## 화면 구성

```
로그인
  └─ 메인 쉘
       ├─ 재고 관리    (홈)
       ├─ 식단 스케줄  (캘린더)
       ├─ 알러지       (캘린더)
       ├─ 통계         (차트)
       └─ 설정
```

---

## 시작하기

### 요구사항

- Flutter SDK `^3.12.0`
- Android SDK (minSdk 21)
- Firebase 프로젝트 연결 (`google-services.json`)

### 실행

```bash
git clone https://github.com/leedaero/babymeal-flutter.git
cd babymeal-flutter
flutter pub get
flutter run
```

### 빌드

```bash
# 릴리즈 APK (실기기)
flutter build apk --release

# 에뮬레이터용 APK (Apple Silicon Mac)
flutter build apk --debug --target-platform android-arm64
```

---

## 배포

Firebase App Distribution을 통해 테스트 배포합니다.  
배포 절차는 [CLAUDE.md](./CLAUDE.md)를 참고하세요.

---

## 관련 레포

| 레포 | 설명 |
|------|------|
| [babymeal-flutter](https://github.com/leedaero/babymeal-flutter) | 이 레포 — Flutter 앱 |
| [babymeal](https://github.com/leedaero/babymeal) | 백엔드 REST API |
