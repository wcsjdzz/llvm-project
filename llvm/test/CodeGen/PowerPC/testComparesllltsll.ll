; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = local_unnamed_addr global i64 0, align 8

; Function Attrs: norecurse nounwind readnone
define i64 @test_llltsll(i64 %a, i64 %b) {
; CHECK-LABEL: test_llltsll:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sradi r5, r3, 63
; CHECK-NEXT:    rldicl r6, r4, 1, 63
; CHECK-NEXT:    subfc r3, r4, r3
; CHECK-NEXT:    adde r3, r6, r5
; CHECK-NEXT:    xori r3, r3, 1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llltsll_sext(i64 %a, i64 %b) {
; CHECK-LABEL: test_llltsll_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sradi r5, r3, 63
; CHECK-NEXT:    rldicl r6, r4, 1, 63
; CHECK-NEXT:    subfc r3, r4, r3
; CHECK-NEXT:    adde r3, r6, r5
; CHECK-NEXT:    xori r3, r3, 1
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llltsll_sext_z(i64 %a) {
; CHECK-LABEL: test_llltsll_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, 0
  %sub = sext i1 %cmp to i64
  ret i64 %sub
}

; Function Attrs: norecurse nounwind
define void @test_llltsll_store(i64 %a, i64 %b) {
; BE-LABEL: test_llltsll_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    sradi r6, r3, 63
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    subfc r3, r4, r3
; BE-NEXT:    rldicl r3, r4, 1, 63
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    adde r3, r3, r6
; BE-NEXT:    xori r3, r3, 1
; BE-NEXT:    std r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llltsll_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sradi r6, r3, 63
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    subfc r3, r4, r3
; LE-NEXT:    rldicl r3, r4, 1, 63
; LE-NEXT:    adde r3, r3, r6
; LE-NEXT:    xori r3, r3, 1
; LE-NEXT:    std r3, glob@toc@l(r5)
; LE-NEXT:    blr
; CHECK-DIAG:    subfc [[REG3:r[0-9]+]], r4, r3
entry:
  %cmp = icmp slt i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llltsll_sext_store(i64 %a, i64 %b) {
; BE-LABEL: test_llltsll_sext_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    sradi r6, r3, 63
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    subfc r3, r4, r3
; BE-NEXT:    rldicl r3, r4, 1, 63
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    adde r3, r3, r6
; BE-NEXT:    xori r3, r3, 1
; BE-NEXT:    neg r3, r3
; BE-NEXT:    std r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llltsll_sext_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sradi r6, r3, 63
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    subfc r3, r4, r3
; LE-NEXT:    rldicl r3, r4, 1, 63
; LE-NEXT:    adde r3, r3, r6
; LE-NEXT:    xori r3, r3, 1
; LE-NEXT:    neg r3, r3
; LE-NEXT:    std r3, glob@toc@l(r5)
; LE-NEXT:    blr
; CHECK-DIAG:    subfc [[REG3:r[0-9]+]], r4, r3
entry:
  %cmp = icmp slt i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llltsll_sext_z_store(i64 %a) {
; BE-LABEL: test_llltsll_sext_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r4, r2, .LC0@toc@ha
; BE-NEXT:    sradi r3, r3, 63
; BE-NEXT:    ld r4, .LC0@toc@l(r4)
; BE-NEXT:    std r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llltsll_sext_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r4, r2, glob@toc@ha
; LE-NEXT:    sradi r3, r3, 63
; LE-NEXT:    std r3, glob@toc@l(r4)
; LE-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, 0
  %sub = sext i1 %cmp to i64
  store i64 %sub, i64* @glob, align 8
  ret void
}
