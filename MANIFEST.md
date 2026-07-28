# ToU-CGE : CBAM 제거 후 구성

Essay 1(CBAM) 요소를 제거하고 IBR→ToU 내용만 남긴 구성입니다.

## 적용 절차

```bash
# 1. Essay 1 저장소에서 CBAM 제거본 생성
python strip_cbam.py --src /path/to/CBAM-CGE --dst /path/to/TOU-CGE

# 2. 이 폴더의 파일들을 TOU-CGE 에 복사
cp E2_*.gms                       /path/to/TOU-CGE/
cp Run_Master.gms                 /path/to/TOU-CGE/
cp Results_format/E2_*.gms        /path/to/TOU-CGE/Results_format/
cp Scenario/*.gms                 /path/to/TOU-CGE/Scenario/
cp -r micro                       /path/to/TOU-CGE/

# 3. Model.gms 직접 수정 5곳 (아래)
```

`strip_cbam.py` 는 `Policy/Recycling.gms`, `Scenario/Reset_Policy.gms`, `Scenario/Apply_Policy.gms` 를 ToU 전용으로 **직접 생성**하므로 별도 복사가 필요 없습니다.

---

## 제거된 것

| 대상 | 내용 |
|---|---|
| `TCBAM`, `CP`, `CO2IDFACTOR`, `EQ16_4` | CBAM 관세수입 |
| `z3` `z4` `z5`, `I3` `I4`, `J11` | CBAM 지역·부문 매핑 |
| `EQ96`~`EQ101` | 생산세·노동세 감면 환류 도구 |
| `deltattip` `ttip_share` `deltattiw` `ttiw_share` | 위 도구의 변수 |
| `rcy_lab` `rcy_prd` | 해당 환류 수단 |
| `Scenario/S0_BASE` ~ `S4_CBAM_HH`, `_CarbonPrice_Path` | CBAM 시나리오 |

`Model.gms` 736 → 676행. 잔류 참조 **0건** (스크립트가 자동 검사).

## 유지된 것 — CBAM처럼 보이지만 구조적입니다

| 대상 | 이유 |
|---|---|
| `CTAX` `TCTAX` `CO2FACTOR` | 탄소세는 PEP 표준이며 CBAM과 무관. 한국 ETS 및 환경축 분석에 필요. 기본값 `CTAX0` |
| `rcy_share` `rcy_hh` `rcy_gov`, `RCY_IN` 매크로 | S2 환류에 그대로 사용 |
| `sim` 집합 | 결과 파라미터가 `sim` 인덱스를 가짐. `/1*1/` 로 축소 |

## 손댄 것 — `frisch`

원 코드는 `frisch(Z3)=-1.1; frisch(Z4)=-1.3; frisch(z5)=-1.5;` 로 **CBAM 지역집합에 의존**했습니다. z3/z4/z5를 지우면 `frisch=0`이 되어 `CMINO` 계산에서 0으로 나누게 됩니다.

지역별 명시 할당으로 대체하고 **원값을 그대로 보존**했습니다. 한국은 −1.3입니다. 0인 지역이 있으면 멈추도록 `ABORT` 가드를 넣었습니다.

> Essay 2에서는 `frisch`가 가계 전력수요 탄력성을 지배합니다. 함의 탄력성 `eps_elec ≈ sigma_Y(elec)/frisch` 를 확인하고, 앞서 논의한 대로 `sigma_Y(ene,z)` 비례 재보정을 함께 처리하십시오.

---

## Model.gms 직접 수정 5곳

`strip_cbam.py` 실행 **후**에 적용합니다. 행 번호는 제거 후 기준이므로 문자열로 찾으십시오.

### ① LES 수요 (EQ36)
```diff
- EQ36(i,z)..     PC(i,z)*C(i,z) =e= PC(i,z)*CMIN(i,z)+gamma_LES(i,z)
-                                 *{CTH(z)-SUM[ij,PC(ij,z)*CMIN(ij,z)]};
+ EQ36(i,z)..     PC_HH(i,z)*C(i,z) =e= PC_HH(i,z)*CMIN(i,z)+gamma_LES(i,z)
+                                 *{CTH(z)-SUM[ij,PC_HH(ij,z)*CMIN(ij,z)]};
```

### ② 소비자물가지수 (EQ68)
```diff
- EQ68(z)..       PIXCON(z) =e= SUM[i,PC(i,z)*CO(i,z)]/SUM[i,PCO(i,z)*CO(i,z)];
+ EQ68(z)..       PIXCON(z) =e= SUM[i,PC_HH(i,z)*CO(i,z)]/SUM[i,PCO(i,z)*CO(i,z)];
```

### ③ 시장청산 (EQ71)
```diff
- EQ71(i1,z)..    Q(i1,z) =e= C(i1,z)+CG(i1,z)+INV(i1,z)+DIT(i1,z);
+ EQ71(i1,z)..    Q(i1,z) =e= C(i1,z)
+                             + [CE_PHYS(z)-C(i1,z)]$IELEC(i1)
+                             + CG(i1,z)+INV(i1,z)+DIT(i1,z);
```

### ④ 생산물세 합계 (EQ21)
```diff
- EQ21(z)..       TPRCTS(z) =e= TICT(z)+TIMT(z)+TIXT(z);
+ EQ21(z)..       TPRCTS(z) =e= TICT(z)+TIMT(z)+TIXT(z)+TIC_HH(z);
```
`YG`(EQ16)는 `TPRCTS`를 포함하므로 EQ16은 수정하지 않습니다.

### ⑤ 지출측 GDP (EQ84)
```diff
  EQ84(z)..       GDP_FD(z) =e=
-                 SUM[i,PC(i,z)*(C(i,z)+CG(i,z)+INV(i,z))]
+                 SUM[i,PC_HH(i,z)*C(i,z)]
+                +SUM[i,PC(i,z)*(CG(i,z)+INV(i,z))]
```

### 추가 : Results_format/CGE_Results.gms
```diff
- valEH(p_elec,z,sim)            = EHI(p_elec,z)*C.L('18_ELEC',z);
+ valEH(p_elec,z,sim)            = EHI(p_elec,z)*CE_PHYS.L(z);
```
`C.L` 은 CES 수량지수이지 물리량이 아닙니다. CO2 계산이 `valEH`를 타므로 누락하면 배출량이 어긋납니다.

---

## 검증

CBAM을 제거하면 **Essay 1 회귀 테스트를 쓸 수 없습니다.** 대신 이 순서로 검증합니다.

| # | 작업 | 통과 조건 |
|---|---|---|
| 0 | `python micro/verify_e2_algebra.py` | 항등식 전부 PASS. GAMS 불필요 |
| 1 | `gams Run_Master.gms action=c` | 컴파일 오류 없음. `EQ_E2_1`~`EQ_E2_9` 존재 |
| 2 | `RUN_BENCHMARK 1` | `chk_bench` 전 항목 < 1e-6. 벗어나면 `ABORT` |
| 3 | `RUN_S0_IBR 1` | Step 2와 동일한 해 |
| 4 | `RUN_S1_TOU 1` | `TIC_HH ≈ 0` (사후 세수중립), 피크 비중 감소 |

Step 2가 사실상 Essay 1 회귀 테스트를 대체합니다. `LEON ≈ 0` 이면 CBAM 제거로 방정식·변수 균형이 깨지지 않았다는 뜻입니다.

**안전장치**: Essay 1 저장소를 그대로 두고 새 저장소를 만드십시오. 문제가 생기면 원본에서 다시 `strip_cbam.py`를 돌리면 됩니다.

---

## 정책충격 인터페이스

`tth_B` 는 내생변수입니다. 충격은 파라미터로 줍니다.

```gams
 tth_B_raw(b,'01_KOR') = p_ToU(b)/p_bar - 1;   * 요금표에서 온 원 wedge
 e2_expost('01_KOR')   = 1;                    * 1 = 사후 세수중립
```

`e2_expost=1` 이면 `EQ_E2_9` 가 `TIC_HH=0` 이 되도록 `tou_shift` 를 내생 결정합니다. 사전 세수중립(벤치마크 수량 기준)은 행태반응 후 세수를 잃으므로 별개입니다.

## 교체할 자리표시 값

| 위치 | 항목 | 출처 |
|---|---|---|
| `E2_CAL.gms` | `theta_B(b,'01_KOR')` | KEPCO 설문 A7 |
| `E2_CAL.gms` | `sigma_ToU('01_KOR')` | `tou_micro.py` 의 `sigma_ToU*` |
| `Scenario/S1,S2` | `p_ToU(b)`, `p_bar` | 한전 약관 + 가계동향조사 |
| `PAR.gms` | `sigma_Y(ene,z)` | λ 비례 재보정 |
