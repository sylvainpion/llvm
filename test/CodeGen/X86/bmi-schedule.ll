; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mattr=+bmi   | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl     | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=btver2  | FileCheck %s --check-prefix=CHECK --check-prefix=BTVER2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1  | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define i16 @test_andn_i16(i16 zeroext %a0, i16 zeroext %a1, i16 *%a2) {
; GENERIC-LABEL: test_andn_i16:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    andnl %esi, %edi, %eax
; GENERIC-NEXT:    notl %edi
; GENERIC-NEXT:    andw (%rdx), %di
; GENERIC-NEXT:    addl %edi, %eax
; GENERIC-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_andn_i16:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    andnl %esi, %edi, %eax # sched: [1:0.50]
; HASWELL-NEXT:    notl %edi # sched: [1:0.25]
; HASWELL-NEXT:    andw (%rdx), %di # sched: [5:0.50]
; HASWELL-NEXT:    addl %edi, %eax # sched: [1:0.25]
; HASWELL-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_andn_i16:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    andnl %esi, %edi, %eax # sched: [1:0.50]
; BTVER2-NEXT:    notl %edi # sched: [1:0.50]
; BTVER2-NEXT:    andw (%rdx), %di # sched: [4:1.00]
; BTVER2-NEXT:    addl %edi, %eax # sched: [1:0.50]
; BTVER2-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_andn_i16:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    andnl %esi, %edi, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    notl %edi # sched: [1:0.25]
; ZNVER1-NEXT:    andw (%rdx), %di # sched: [5:0.50]
; ZNVER1-NEXT:    addl %edi, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i16, i16 *%a2
  %2 = xor i16 %a0, -1
  %3 = and i16 %2, %a1
  %4 = and i16 %2, %1
  %5 = add i16 %3, %4
  ret i16 %5
}

define i32 @test_andn_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_andn_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    andnl %esi, %edi, %ecx
; GENERIC-NEXT:    andnl (%rdx), %edi, %eax
; GENERIC-NEXT:    addl %ecx, %eax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_andn_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    andnl %esi, %edi, %ecx # sched: [1:0.50]
; HASWELL-NEXT:    andnl (%rdx), %edi, %eax # sched: [4:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_andn_i32:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    andnl (%rdx), %edi, %eax # sched: [4:1.00]
; BTVER2-NEXT:    andnl %esi, %edi, %ecx # sched: [1:0.50]
; BTVER2-NEXT:    addl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_andn_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    andnl (%rdx), %edi, %eax # sched: [5:0.50]
; ZNVER1-NEXT:    andnl %esi, %edi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = xor i32 %a0, -1
  %3 = and i32 %2, %a1
  %4 = and i32 %2, %1
  %5 = add i32 %3, %4
  ret i32 %5
}

define i64 @test_andn_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_andn_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    andnq %rsi, %rdi, %rcx
; GENERIC-NEXT:    andnq (%rdx), %rdi, %rax
; GENERIC-NEXT:    addq %rcx, %rax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_andn_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    andnq %rsi, %rdi, %rcx # sched: [1:0.50]
; HASWELL-NEXT:    andnq (%rdx), %rdi, %rax # sched: [4:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_andn_i64:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    andnq (%rdx), %rdi, %rax # sched: [4:1.00]
; BTVER2-NEXT:    andnq %rsi, %rdi, %rcx # sched: [1:0.50]
; BTVER2-NEXT:    addq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_andn_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    andnq (%rdx), %rdi, %rax # sched: [5:0.50]
; ZNVER1-NEXT:    andnq %rsi, %rdi, %rcx # sched: [1:0.25]
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = xor i64 %a0, -1
  %3 = and i64 %2, %a1
  %4 = and i64 %2, %1
  %5 = add i64 %3, %4
  ret i64 %5
}

define i32 @test_bextr_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_bextr_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    bextrl %edi, (%rdx), %ecx
; GENERIC-NEXT:    bextrl %edi, %esi, %eax
; GENERIC-NEXT:    addl %ecx, %eax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_bextr_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    bextrl %edi, (%rdx), %ecx # sched: [6:0.50]
; HASWELL-NEXT:    bextrl %edi, %esi, %eax # sched: [2:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_bextr_i32:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    bextrl %edi, (%rdx), %ecx
; BTVER2-NEXT:    bextrl %edi, %esi, %eax
; BTVER2-NEXT:    addl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_bextr_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    bextrl %edi, (%rdx), %ecx
; ZNVER1-NEXT:    bextrl %edi, %esi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %1, i32 %a0)
  %3 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %a1, i32 %a0)
  %4 = add i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.x86.bmi.bextr.32(i32, i32)

define i64 @test_bextr_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_bextr_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    bextrq %rdi, (%rdx), %rcx
; GENERIC-NEXT:    bextrq %rdi, %rsi, %rax
; GENERIC-NEXT:    addq %rcx, %rax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_bextr_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    bextrq %rdi, (%rdx), %rcx # sched: [6:0.50]
; HASWELL-NEXT:    bextrq %rdi, %rsi, %rax # sched: [2:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_bextr_i64:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    bextrq %rdi, (%rdx), %rcx
; BTVER2-NEXT:    bextrq %rdi, %rsi, %rax
; BTVER2-NEXT:    addq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_bextr_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    bextrq %rdi, (%rdx), %rcx
; ZNVER1-NEXT:    bextrq %rdi, %rsi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = tail call i64 @llvm.x86.bmi.bextr.64(i64 %1, i64 %a0)
  %3 = tail call i64 @llvm.x86.bmi.bextr.64(i64 %a1, i64 %a0)
  %4 = add i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.x86.bmi.bextr.64(i64, i64)

define i32 @test_blsi_i32(i32 %a0, i32 *%a1) {
; GENERIC-LABEL: test_blsi_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    blsil (%rsi), %ecx
; GENERIC-NEXT:    blsil %edi, %eax
; GENERIC-NEXT:    addl %ecx, %eax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_blsi_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    blsil (%rsi), %ecx # sched: [4:0.50]
; HASWELL-NEXT:    blsil %edi, %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_blsi_i32:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    blsil (%rsi), %ecx
; BTVER2-NEXT:    blsil %edi, %eax
; BTVER2-NEXT:    addl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_blsi_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    blsil (%rsi), %ecx
; ZNVER1-NEXT:    blsil %edi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a1
  %2 = sub i32 0, %1
  %3 = sub i32 0, %a0
  %4 = and i32 %1, %2
  %5 = and i32 %a0, %3
  %6 = add i32 %4, %5
  ret i32 %6
}

define i64 @test_blsi_i64(i64 %a0, i64 *%a1) {
; GENERIC-LABEL: test_blsi_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    blsiq (%rsi), %rcx
; GENERIC-NEXT:    blsiq %rdi, %rax
; GENERIC-NEXT:    addq %rcx, %rax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_blsi_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    blsiq (%rsi), %rcx # sched: [4:0.50]
; HASWELL-NEXT:    blsiq %rdi, %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_blsi_i64:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    blsiq (%rsi), %rcx
; BTVER2-NEXT:    blsiq %rdi, %rax
; BTVER2-NEXT:    addq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_blsi_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    blsiq (%rsi), %rcx
; ZNVER1-NEXT:    blsiq %rdi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a1
  %2 = sub i64 0, %1
  %3 = sub i64 0, %a0
  %4 = and i64 %1, %2
  %5 = and i64 %a0, %3
  %6 = add i64 %4, %5
  ret i64 %6
}

define i32 @test_blsmsk_i32(i32 %a0, i32 *%a1) {
; GENERIC-LABEL: test_blsmsk_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    blsmskl (%rsi), %ecx
; GENERIC-NEXT:    blsmskl %edi, %eax
; GENERIC-NEXT:    addl %ecx, %eax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_blsmsk_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    blsmskl (%rsi), %ecx # sched: [4:0.50]
; HASWELL-NEXT:    blsmskl %edi, %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_blsmsk_i32:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    blsmskl (%rsi), %ecx
; BTVER2-NEXT:    blsmskl %edi, %eax
; BTVER2-NEXT:    addl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_blsmsk_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    blsmskl (%rsi), %ecx
; ZNVER1-NEXT:    blsmskl %edi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a1
  %2 = sub i32 %1, 1
  %3 = sub i32 %a0, 1
  %4 = xor i32 %1, %2
  %5 = xor i32 %a0, %3
  %6 = add i32 %4, %5
  ret i32 %6
}

define i64 @test_blsmsk_i64(i64 %a0, i64 *%a1) {
; GENERIC-LABEL: test_blsmsk_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    blsmskq (%rsi), %rcx
; GENERIC-NEXT:    blsmskq %rdi, %rax
; GENERIC-NEXT:    addq %rcx, %rax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_blsmsk_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    blsmskq (%rsi), %rcx # sched: [4:0.50]
; HASWELL-NEXT:    blsmskq %rdi, %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_blsmsk_i64:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    blsmskq (%rsi), %rcx
; BTVER2-NEXT:    blsmskq %rdi, %rax
; BTVER2-NEXT:    addq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_blsmsk_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    blsmskq (%rsi), %rcx
; ZNVER1-NEXT:    blsmskq %rdi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a1
  %2 = sub i64 %1, 1
  %3 = sub i64 %a0, 1
  %4 = xor i64 %1, %2
  %5 = xor i64 %a0, %3
  %6 = add i64 %4, %5
  ret i64 %6
}

define i32 @test_blsr_i32(i32 %a0, i32 *%a1) {
; GENERIC-LABEL: test_blsr_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    blsrl (%rsi), %ecx
; GENERIC-NEXT:    blsrl %edi, %eax
; GENERIC-NEXT:    addl %ecx, %eax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_blsr_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    blsrl (%rsi), %ecx # sched: [4:0.50]
; HASWELL-NEXT:    blsrl %edi, %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_blsr_i32:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    blsrl (%rsi), %ecx
; BTVER2-NEXT:    blsrl %edi, %eax
; BTVER2-NEXT:    addl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_blsr_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    blsrl (%rsi), %ecx
; ZNVER1-NEXT:    blsrl %edi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a1
  %2 = sub i32 %1, 1
  %3 = sub i32 %a0, 1
  %4 = and i32 %1, %2
  %5 = and i32 %a0, %3
  %6 = add i32 %4, %5
  ret i32 %6
}

define i64 @test_blsr_i64(i64 %a0, i64 *%a1) {
; GENERIC-LABEL: test_blsr_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    blsrq (%rsi), %rcx
; GENERIC-NEXT:    blsrq %rdi, %rax
; GENERIC-NEXT:    addq %rcx, %rax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_blsr_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    blsrq (%rsi), %rcx # sched: [4:0.50]
; HASWELL-NEXT:    blsrq %rdi, %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_blsr_i64:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    blsrq (%rsi), %rcx
; BTVER2-NEXT:    blsrq %rdi, %rax
; BTVER2-NEXT:    addq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_blsr_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    blsrq (%rsi), %rcx
; ZNVER1-NEXT:    blsrq %rdi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a1
  %2 = sub i64 %1, 1
  %3 = sub i64 %a0, 1
  %4 = and i64 %1, %2
  %5 = and i64 %a0, %3
  %6 = add i64 %4, %5
  ret i64 %6
}

define i16 @test_cttz_i16(i16 zeroext %a0, i16 *%a1) {
; GENERIC-LABEL: test_cttz_i16:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    tzcntw (%rsi), %cx
; GENERIC-NEXT:    tzcntw %di, %ax
; GENERIC-NEXT:    orl %ecx, %eax
; GENERIC-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_cttz_i16:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    tzcntw (%rsi), %cx # sched: [7:1.00]
; HASWELL-NEXT:    tzcntw %di, %ax # sched: [3:1.00]
; HASWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_cttz_i16:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    tzcntw (%rsi), %cx
; BTVER2-NEXT:    tzcntw %di, %ax
; BTVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_cttz_i16:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    tzcntw (%rsi), %cx
; ZNVER1-NEXT:    tzcntw %di, %ax
; ZNVER1-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i16, i16 *%a1
  %2 = tail call i16 @llvm.cttz.i16( i16 %1, i1 false )
  %3 = tail call i16 @llvm.cttz.i16( i16 %a0, i1 false )
  %4 = or i16 %2, %3
  ret i16 %4
}
declare i16 @llvm.cttz.i16(i16, i1)

define i32 @test_cttz_i32(i32 %a0, i32 *%a1) {
; GENERIC-LABEL: test_cttz_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    tzcntl (%rsi), %ecx
; GENERIC-NEXT:    tzcntl %edi, %eax
; GENERIC-NEXT:    orl %ecx, %eax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_cttz_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    tzcntl (%rsi), %ecx # sched: [7:1.00]
; HASWELL-NEXT:    tzcntl %edi, %eax # sched: [3:1.00]
; HASWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_cttz_i32:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    tzcntl (%rsi), %ecx
; BTVER2-NEXT:    tzcntl %edi, %eax
; BTVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_cttz_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    tzcntl (%rsi), %ecx
; ZNVER1-NEXT:    tzcntl %edi, %eax
; ZNVER1-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a1
  %2 = tail call i32 @llvm.cttz.i32( i32 %1, i1 false )
  %3 = tail call i32 @llvm.cttz.i32( i32 %a0, i1 false )
  %4 = or i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.cttz.i32(i32, i1)

define i64 @test_cttz_i64(i64 %a0, i64 *%a1) {
; GENERIC-LABEL: test_cttz_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    tzcntq (%rsi), %rcx
; GENERIC-NEXT:    tzcntq %rdi, %rax
; GENERIC-NEXT:    orq %rcx, %rax
; GENERIC-NEXT:    retq
;
; HASWELL-LABEL: test_cttz_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    tzcntq (%rsi), %rcx # sched: [7:1.00]
; HASWELL-NEXT:    tzcntq %rdi, %rax # sched: [3:1.00]
; HASWELL-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [1:1.00]
;
; BTVER2-LABEL: test_cttz_i64:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    tzcntq (%rsi), %rcx
; BTVER2-NEXT:    tzcntq %rdi, %rax
; BTVER2-NEXT:    orq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_cttz_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    tzcntq (%rsi), %rcx
; ZNVER1-NEXT:    tzcntq %rdi, %rax
; ZNVER1-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a1
  %2 = tail call i64 @llvm.cttz.i64( i64 %1, i1 false )
  %3 = tail call i64 @llvm.cttz.i64( i64 %a0, i1 false )
  %4 = or i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.cttz.i64(i64, i1)
