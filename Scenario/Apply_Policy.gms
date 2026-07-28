* ==============================================================================
* Scenario/Apply_Policy.gms
* 정책 스위치 정합성 검증. 시나리오 파일에서 스위치를 설정한 "직후",
* solve "이전"에 호출.
* ==============================================================================

* --- (i) 환류 배분 정합성: 징수지역의 배분 비율 합은 0 또는 1 ---
 rcy_chk(z) = SUM(zj, rcy_share(z,zj));
 ABORT$(SMAX(z, ABS(rcy_chk(z))*ABS(rcy_chk(z)-1)) > 1e-8)
     "rcy_share: collecting-region shares must sum to 0 or 1", rcy_chk;

* --- (ii) 환류 수단 중복 지정 금지 ---
 ABORT$(SMAX(z, rcy_hh(z)+rcy_gov(z)) > 1)
     "only one recycling instrument per region is allowed";

* --- (iii) ToU 충격은 ZE2 지역에만 부과되어야 함 ---
 ABORT$(SMAX((b,z)$(NOT ZE2(z)), ABS(tth_B_raw(b,z))) > 1e-12)
     "tth_B_raw is nonzero outside ZE2. E2_Sets.gms 의 ZE2 를 확인할 것.", tth_B_raw;

* --- (iv) 사후 세수중립 스위치는 0 또는 1 ---
 ABORT$(SMAX(z, ABS(e2_expost(z))*ABS(e2_expost(z)-1)) > 1e-12)
     "e2_expost must be 0 or 1", e2_expost;
