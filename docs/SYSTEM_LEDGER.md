# World Ledger System

## Purpose

World Ledger System은 특정 NPC가 직접 플레이어를 기억하고 승격하는 구조를 피하면서도, 플레이어가 “세계가 나를 기억한다”고 느끼게 만드는 반응형 월드 시스템이다.

## Core Rule

> 개별 적이 복수하지 않는다. 세계가 기록하고, 세력이 반응하며, 오멘이 발생한다.

## Data Layers

| Layer | Description | Example |
|---|---|---|
| Run Memory | 현재 판의 행동 기록 | 독 피해량, 회피 횟수, 사망 원인 |
| Region Ledger | 지역별 누적 상태 | Mourning Field 위험도 3 |
| Faction Grievance | 세력별 원한 | Hollow Choir 64 |
| Rumor Deck | 오멘 후보 카드 | 독의 장송가 |
| Ritual Queue | 다음 전투 변형 예약 | 다음 보스 보호막 강화 |
| Campaign Chronicle | 장기 기록 | 최다 사망 지역, 선호 무기 |

## Avoided Structures

- 특정 일반 적이 플레이어를 죽인 뒤 이름 있는 보스로 승격되는 구조.
- 적 NPC 위계도에서 승진/강등하는 구조.
- 특정 NPC가 과거 전투를 직접 기억하고 대사/외형/능력을 변화시키는 구조.
- 다른 플레이어에게 적 데이터를 넘겨 복수 미션을 만드는 구조.

## Trigger Tags

| Tag | Meaning | Example Reaction |
|---|---|---|
| dominant_damage_type | 주력 피해 속성 | 해당 속성 저항 오멘 |
| low_dodge_rate | 회피 사용 낮음 | 돌진형 적 증가 |
| death_hotspot | 반복 사망 지역 | 묘비/저주 이벤트 |
| boss_burst_kill | 보스 빠른 처치 | 다음 보스 방어 의식 |
| skill_reliance | 스킬 의존도 높음 | 침묵 장판 |
| ignored_rewards | 보상 무시 | 절제/탐욕 이벤트 |
| faction_pressure | 특정 세력 집중 처치 | 세력 원한 증가 |

## Grievance Formula

```text
faction_grievance_delta =
  base_kill_score
  + elite_kill_bonus
  + region_purity_bonus
  + repeated_run_multiplier
  - cleansing_action_value
```

Example:

```text
Hollow Choir 적 120마리 처치: +12
망령 엘리트 2마리 처치: +10
같은 지역 연속 2회 진입: x1.2
성소 정화 수행: -15
최종 증가량 = (12 + 10) x 1.2 - 15 = 11.4 → 반올림 +11
```

## Omen Resolution Order

1. Collect run metrics.
2. Convert metrics into tags.
3. Update region and faction ledgers.
4. Generate candidate omens.
5. Filter hard-counter effects.
6. Pick omens by risk budget.
7. Present forecast to player.
8. Apply in next run.
9. Reward higher-risk states.

## Player-Facing Feedback

전투 후 반드시 다음 형식으로 보여준다.

```text
오늘 밤, 달빛은 당신의 독을 기억했습니다.
Thorn Court 원한 +12
Moonless Fen 사망 흔적 +1
새 오멘 후보: 독의 장송가
정화 가능: Memory Wax 3개 사용
```
