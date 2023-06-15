
extern printi
extern printc
extern checkargc
global asm_main
default rel
section .data
glovars: dq 0
section .text
asm_main:
	push rbp
	mov qword [glovars], rsp
	sub qword [glovars], 8
	push rdx ;save asm_main args
	push rcx
	;check arg count:
	sub rsp, 24
	mov rdx, rcx
	mov rcx, 0
	call checkargc
	add rsp, 24
	pop rcx
	pop rdx ;pop asm_main args
	; allocate globals:
	
ldargs:           ;set up command line arguments on stack:
	mov rcx, rcx
	mov rsi, rdx
_args_next:
	cmp rcx, 0
	jz _args_end
	push qword [rsi]
	add rsi, 8
	sub rcx, 1
	jmp _args_next      ;repeat until --ecx == 0
_args_end:
	lea rbp, [rsp--1*8]  ; make rbp point to first arg
	;CALL 0,L1_main
	push rbp 
	call near L1_main
	push rbx
	;STOP
	mov rsp, qword [glovars]
	add rsp, 8          ; restore rsp
	pop rbp
	ret
	
L1_main:
	pop rax			; retaddr
	pop r10			; oldbp  
	sub rsp, 16     ; make space for svm r,bp 
	mov rsi, rsp 
	mov rbp, rsp 
	add rbp, 0	   ; 8*arity 

_L1_main_pro_1:	  ; slide 2 stack slot
	cmp rbp, rsi      
	jz _L1_main_pro_2    
	mov rcx, [rsi+16] 
	mov [rsi], rcx    
	add rsi, 8        
	jmp _L1_main_pro_1    

_L1_main_pro_2: 
	sub rbp, 8 ; rbp pointer to first arg 
	mov [rbp+16], rax ; set retaddr 
	mov [rbp+8], r10  ; set oldbp
	;CSTI 1
	push 1
	;CSTI 2
	push 2
	;EQ
	pop rax
	pop r10
	cmp rax, r10
	jne .Lasm0
	push 1
	jmp .Lasm1
.Lasm0:
	push 0
.Lasm1:
	;IFZERO L3
	pop rax
	cmp rax,0
	je L3
	;CSTI 1
	push 1
	;CSTI 2
	push 2
	;EQ
	pop rax
	pop r10
	cmp rax, r10
	jne .Lasm2
	push 1
	jmp .Lasm3
.Lasm2:
	push 0
.Lasm3:
	;NOT
	pop rax
	xor rax, 1
	push rax
	;GOTO L2
	jmp L2
	
L3:
	;CSTI 0
	push 0
	
L2:
	;PRINTI
	pop rcx
	push rcx
	sub rsp, 16
	call printi
	add rsp, 16
	;INCSP -1
	lea rsp, [rsp-8*(-1)]
	;CSTI 1
	push 1
	;CSTI 2
	push 2
	;SWAP
	pop rax
	pop r10
	push rax
	push r10
	;LT
	pop rax
	pop r10
	cmp r10, rax
	jl .Lasm4
	push 0
	jmp .Lasm5
.Lasm4:
	push 1
.Lasm5:
	;IFNZRO L5
	pop rax
	cmp rax,0
	jne L5
	;CSTI 1
	push 1
	;CSTI 2
	push 2
	;LT
	pop rax
	pop r10
	cmp r10, rax
	jl .Lasm6
	push 0
	jmp .Lasm7
.Lasm6:
	push 1
.Lasm7:
	;GOTO L4
	jmp L4
	
L5:
	;CSTI 1
	push 1
	
L4:
	;PRINTI
	pop rcx
	push rcx
	sub rsp, 16
	call printi
	add rsp, 16
	;INCSP -1
	lea rsp, [rsp-8*(-1)]
	;CSTI 1
	push 1
	;CSTI 1
	push 1
	;LT
	pop rax
	pop r10
	cmp r10, rax
	jl .Lasm8
	push 0
	jmp .Lasm9
.Lasm8:
	push 1
.Lasm9:
	;NOT
	pop rax
	xor rax, 1
	push rax
	;IFZERO L7
	pop rax
	cmp rax,0
	je L7
	;CSTI 1
	push 1
	;CSTI 1
	push 1
	;SWAP
	pop rax
	pop r10
	push rax
	push r10
	;LT
	pop rax
	pop r10
	cmp r10, rax
	jl .Lasm10
	push 0
	jmp .Lasm11
.Lasm10:
	push 1
.Lasm11:
	;NOT
	pop rax
	xor rax, 1
	push rax
	;GOTO L6
	jmp L6
	
L7:
	;CSTI 0
	push 0
	
L6:
	;PRINTI
	pop rcx
	push rcx
	sub rsp, 16
	call printi
	add rsp, 16
	;INCSP -1
	lea rsp, [rsp-8*(-1)]
	;CSTI 1
	push 1
	;CSTI 0
	push 0
	;SWAP
	pop rax
	pop r10
	push rax
	push r10
	;LT
	pop rax
	pop r10
	cmp r10, rax
	jl .Lasm12
	push 0
	jmp .Lasm13
.Lasm12:
	push 1
.Lasm13:
	;NOT
	pop rax
	xor rax, 1
	push rax
	;PRINTI
	pop rcx
	push rcx
	sub rsp, 16
	call printi
	add rsp, 16
	;INCSP -1
	lea rsp, [rsp-8*(-1)]
	;INCSP 0
	lea rsp, [rsp-8*(0)]
	;RET -1
	pop rbx
	add rsp, 8*-1
	pop rbp
	ret
	