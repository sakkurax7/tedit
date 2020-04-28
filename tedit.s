	.file	"tedit.c"
	.text
	.comm	E,216,32
	.globl	C_HL_extensions
	.section	.rodata
.LC0:
	.string	".c"
.LC1:
	.string	".cpp"
.LC2:
	.string	".h"
	.section	.data.rel.local,"aw"
	.align 32
	.type	C_HL_extensions, @object
	.size	C_HL_extensions, 32
C_HL_extensions:
	.quad	.LC0
	.quad	.LC1
	.quad	.LC2
	.quad	0
	.globl	C_HL_keywords
	.section	.rodata
.LC3:
	.string	"switch"
.LC4:
	.string	"if"
.LC5:
	.string	"while"
.LC6:
	.string	"for"
.LC7:
	.string	"break"
.LC8:
	.string	"continue"
.LC9:
	.string	"return"
.LC10:
	.string	"else"
.LC11:
	.string	"struct"
.LC12:
	.string	"union"
.LC13:
	.string	"typedef"
.LC14:
	.string	"static"
.LC15:
	.string	"enum"
.LC16:
	.string	"class"
.LC17:
	.string	"case"
.LC18:
	.string	"int|"
.LC19:
	.string	"long|"
.LC20:
	.string	"double|"
.LC21:
	.string	"float|"
.LC22:
	.string	"char|"
.LC23:
	.string	"unsigned|"
.LC24:
	.string	"signed|"
.LC25:
	.string	"void|"
	.section	.data.rel.local
	.align 32
	.type	C_HL_keywords, @object
	.size	C_HL_keywords, 192
C_HL_keywords:
	.quad	.LC3
	.quad	.LC4
	.quad	.LC5
	.quad	.LC6
	.quad	.LC7
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.quad	.LC11
	.quad	.LC12
	.quad	.LC13
	.quad	.LC14
	.quad	.LC15
	.quad	.LC16
	.quad	.LC17
	.quad	.LC18
	.quad	.LC19
	.quad	.LC20
	.quad	.LC21
	.quad	.LC22
	.quad	.LC23
	.quad	.LC24
	.quad	.LC25
	.quad	0
	.globl	HLDB
	.section	.rodata
.LC26:
	.string	"c"
.LC27:
	.string	"//"
.LC28:
	.string	"/*"
.LC29:
	.string	"*/"
	.section	.data.rel.local
	.align 32
	.type	HLDB, @object
	.size	HLDB, 56
HLDB:
	.quad	.LC26
	.quad	C_HL_extensions
	.quad	C_HL_keywords
	.quad	.LC27
	.quad	.LC28
	.quad	.LC29
	.long	3
	.zero	4
	.section	.rodata
.LC30:
	.string	"\033[2J"
.LC31:
	.string	"\033[H"
	.text
	.globl	die
	.type	die, @function
die:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$4, %edx
	leaq	.LC30(%rip), %rsi
	movl	$1, %edi
	call	write@PLT
	movl	$3, %edx
	leaq	.LC31(%rip), %rsi
	movl	$1, %edi
	call	write@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE6:
	.size	die, .-die
	.section	.rodata
.LC32:
	.string	"tcsetattr"
	.text
	.globl	disableRawMode
	.type	disableRawMode, @function
disableRawMode:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	152+E(%rip), %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	cmpl	$-1, %eax
	jne	.L4
	leaq	.LC32(%rip), %rdi
	call	die
.L4:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	disableRawMode, .-disableRawMode
	.section	.rodata
.LC33:
	.string	"tcgetattr"
	.text
	.globl	enableRawMode
	.type	enableRawMode, @function
enableRawMode:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	152+E(%rip), %rsi
	movl	$0, %edi
	call	tcgetattr@PLT
	cmpl	$-1, %eax
	jne	.L6
	leaq	.LC33(%rip), %rdi
	call	die
.L6:
	leaq	disableRawMode(%rip), %rdi
	call	atexit@PLT
	movq	152+E(%rip), %rax
	movq	160+E(%rip), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	168+E(%rip), %rax
	movq	176+E(%rip), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	184+E(%rip), %rax
	movq	192+E(%rip), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	200+E(%rip), %rax
	movq	%rax, -32(%rbp)
	movl	208+E(%rip), %eax
	movl	%eax, -24(%rbp)
	movl	-80(%rbp), %eax
	andl	$-1331, %eax
	movl	%eax, -80(%rbp)
	movl	-76(%rbp), %eax
	andl	$-2, %eax
	movl	%eax, -76(%rbp)
	movl	-72(%rbp), %eax
	orl	$48, %eax
	movl	%eax, -72(%rbp)
	movl	-68(%rbp), %eax
	andl	$-32780, %eax
	movl	%eax, -68(%rbp)
	movb	$0, -57(%rbp)
	movb	$1, -58(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	leaq	-80(%rbp), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	cmpl	$-1, %eax
	jne	.L9
	leaq	.LC32(%rip), %rdi
	call	die
.L9:
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	enableRawMode, .-enableRawMode
	.section	.rodata
.LC34:
	.string	"read"
	.text
	.globl	editorReadKey
	.type	editorReadKey, @function
editorReadKey:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	jmp	.L11
.L12:
	cmpl	$-1, -16(%rbp)
	jne	.L11
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	je	.L11
	leaq	.LC34(%rip), %rdi
	call	die
.L11:
	leaq	-17(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	read@PLT
	movl	%eax, -16(%rbp)
	cmpl	$1, -16(%rbp)
	jne	.L12
	movzbl	-17(%rbp), %eax
	cmpb	$27, %al
	jne	.L13
	leaq	-11(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	read@PLT
	cmpq	$1, %rax
	je	.L14
	movl	$27, %eax
	jmp	.L40
.L14:
	leaq	-11(%rbp), %rax
	addq	$1, %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	read@PLT
	cmpq	$1, %rax
	je	.L16
	movl	$27, %eax
	jmp	.L40
.L16:
	movzbl	-11(%rbp), %eax
	cmpb	$91, %al
	jne	.L17
	movzbl	-10(%rbp), %eax
	cmpb	$47, %al
	jle	.L18
	movzbl	-10(%rbp), %eax
	cmpb	$57, %al
	jg	.L18
	leaq	-11(%rbp), %rax
	addq	$2, %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	read@PLT
	cmpq	$1, %rax
	je	.L19
	movl	$27, %eax
	jmp	.L40
.L19:
	movzbl	-9(%rbp), %eax
	cmpb	$126, %al
	jne	.L42
	movzbl	-10(%rbp), %eax
	movsbl	%al, %eax
	subl	$49, %eax
	cmpl	$7, %eax
	ja	.L42
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L22(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L22(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L22:
	.long	.L28-.L22
	.long	.L42-.L22
	.long	.L27-.L22
	.long	.L26-.L22
	.long	.L25-.L22
	.long	.L24-.L22
	.long	.L23-.L22
	.long	.L21-.L22
	.text
.L28:
	movl	$1005, %eax
	jmp	.L40
.L27:
	movl	$1004, %eax
	jmp	.L40
.L26:
	movl	$1006, %eax
	jmp	.L40
.L25:
	movl	$1007, %eax
	jmp	.L40
.L24:
	movl	$1008, %eax
	jmp	.L40
.L23:
	movl	$1005, %eax
	jmp	.L40
.L21:
	movl	$1006, %eax
	jmp	.L40
.L18:
	movzbl	-10(%rbp), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	cmpl	$7, %eax
	ja	.L37
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L31(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L31(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L31:
	.long	.L36-.L31
	.long	.L35-.L31
	.long	.L34-.L31
	.long	.L33-.L31
	.long	.L37-.L31
	.long	.L32-.L31
	.long	.L37-.L31
	.long	.L30-.L31
	.text
.L36:
	movl	$1002, %eax
	jmp	.L40
.L35:
	movl	$1003, %eax
	jmp	.L40
.L34:
	movl	$1001, %eax
	jmp	.L40
.L33:
	movl	$1000, %eax
	jmp	.L40
.L30:
	movl	$1005, %eax
	jmp	.L40
.L32:
	movl	$1006, %eax
	jmp	.L40
.L17:
	movzbl	-11(%rbp), %eax
	cmpb	$79, %al
	jne	.L37
	movzbl	-10(%rbp), %eax
	movsbl	%al, %eax
	cmpl	$70, %eax
	je	.L38
	cmpl	$72, %eax
	jne	.L37
	movl	$1005, %eax
	jmp	.L40
.L38:
	movl	$1006, %eax
	jmp	.L40
.L42:
	nop
.L37:
	movl	$27, %eax
	jmp	.L40
.L13:
	movzbl	-17(%rbp), %eax
	movsbl	%al, %eax
.L40:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L41
	call	__stack_chk_fail@PLT
.L41:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	editorReadKey, .-editorReadKey
	.section	.rodata
.LC35:
	.string	"\033[6n"
.LC36:
	.string	"\r"
.LC37:
	.string	"%d;%d"
	.text
	.globl	getCursorPosition
	.type	getCursorPosition, @function
getCursorPosition:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -52(%rbp)
	movl	$4, %edx
	leaq	.LC35(%rip), %rsi
	movl	$1, %edi
	call	write@PLT
	cmpq	$4, %rax
	je	.L44
	movl	$-1, %eax
	jmp	.L54
.L44:
	leaq	.LC36(%rip), %rdi
	call	puts@PLT
	jmp	.L46
.L50:
	leaq	-48(%rbp), %rdx
	movl	-52(%rbp), %eax
	addq	%rdx, %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	read@PLT
	cmpq	$1, %rax
	jne	.L56
	movl	-52(%rbp), %eax
	movzbl	-48(%rbp,%rax), %eax
	cmpb	$82, %al
	je	.L57
	addl	$1, -52(%rbp)
.L46:
	cmpl	$30, -52(%rbp)
	jbe	.L50
	jmp	.L48
.L56:
	nop
	jmp	.L48
.L57:
	nop
.L48:
	movl	-52(%rbp), %eax
	movb	$0, -48(%rbp,%rax)
	movzbl	-48(%rbp), %eax
	cmpb	$27, %al
	jne	.L51
	movzbl	-47(%rbp), %eax
	cmpb	$91, %al
	je	.L52
.L51:
	movl	$-1, %eax
	jmp	.L54
.L52:
	movq	-80(%rbp), %rdx
	movq	-72(%rbp), %rax
	leaq	-48(%rbp), %rcx
	leaq	2(%rcx), %rdi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	leaq	.LC37(%rip), %rsi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	cmpl	$2, %eax
	je	.L53
	movl	$-1, %eax
	jmp	.L54
.L53:
	movl	$0, %eax
.L54:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L55
	call	__stack_chk_fail@PLT
.L55:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	getCursorPosition, .-getCursorPosition
	.section	.rodata
.LC38:
	.string	"\033[999C\033[999B"
	.text
	.globl	getWindowSize
	.type	getWindowSize, @function
getWindowSize:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-16(%rbp), %rax
	movq	%rax, %rdx
	movl	$21523, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	ioctl@PLT
	cmpl	$-1, %eax
	je	.L59
	movzwl	-14(%rbp), %eax
	testw	%ax, %ax
	jne	.L60
.L59:
	movl	$12, %edx
	leaq	.LC38(%rip), %rsi
	movl	$1, %edi
	call	write@PLT
	cmpq	$12, %rax
	je	.L61
	movl	$-1, %eax
	jmp	.L63
.L61:
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	getCursorPosition
	jmp	.L63
.L60:
	movzwl	-14(%rbp), %eax
	movzwl	%ax, %edx
	movq	-32(%rbp), %rax
	movl	%edx, (%rax)
	movzwl	-16(%rbp), %eax
	movzwl	%ax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, (%rax)
	movl	$0, %eax
.L63:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L64
	call	__stack_chk_fail@PLT
.L64:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	getWindowSize, .-getWindowSize
	.section	.rodata
.LC39:
	.string	",.()+-/*=~%<>[];"
	.text
	.globl	is_seperator
	.type	is_seperator, @function
is_seperator:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	call	__ctype_b_loc@PLT
	movq	(%rax), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rdx
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$8192, %eax
	testl	%eax, %eax
	jne	.L66
	cmpl	$0, -4(%rbp)
	je	.L66
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC39(%rip), %rdi
	call	strchr@PLT
	testq	%rax, %rax
	je	.L67
.L66:
	movl	$1, %eax
	jmp	.L69
.L67:
	movl	$0, %eax
.L69:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	is_seperator, .-is_seperator
	.globl	editorUpdateSyntax
	.type	editorUpdateSyntax, @function
editorUpdateSyntax:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -88(%rbp)
	movq	-88(%rbp), %rax
	movl	8(%rax), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	-88(%rbp), %rdx
	movq	%rax, 32(%rdx)
	movq	-88(%rbp), %rax
	movl	8(%rax), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	movq	32(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	144+E(%rip), %rax
	testq	%rax, %rax
	je	.L108
	movq	144+E(%rip), %rax
	movq	16(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	144+E(%rip), %rax
	movq	24(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	144+E(%rip), %rax
	movq	32(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	144+E(%rip), %rax
	movq	40(%rax), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L73
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	jmp	.L74
.L73:
	movl	$0, %eax
.L74:
	movl	%eax, -52(%rbp)
	cmpq	$0, -16(%rbp)
	je	.L75
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	jmp	.L76
.L75:
	movl	$0, %eax
.L76:
	movl	%eax, -48(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L77
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	jmp	.L78
.L77:
	movl	$0, %eax
.L78:
	movl	%eax, -44(%rbp)
	movl	$1, -76(%rbp)
	movl	$0, -72(%rbp)
	movq	-88(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L79
	movq	32+E(%rip), %rcx
	movq	-88(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	subq	$48, %rax
	addq	%rcx, %rax
	movl	40(%rax), %eax
	testl	%eax, %eax
	je	.L79
	movl	$1, %eax
	jmp	.L80
.L79:
	movl	$0, %eax
.L80:
	movl	%eax, -68(%rbp)
	movl	$0, -64(%rbp)
	jmp	.L81
.L107:
	movq	-88(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-64(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -78(%rbp)
	cmpl	$0, -64(%rbp)
	jle	.L82
	movq	-88(%rbp), %rax
	movq	32(%rax), %rax
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	subq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	jmp	.L83
.L82:
	movl	$0, %eax
.L83:
	movb	%al, -77(%rbp)
	cmpl	$0, -52(%rbp)
	je	.L84
	cmpl	$0, -72(%rbp)
	jne	.L84
	cmpl	$0, -68(%rbp)
	jne	.L84
	movl	-52(%rbp), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-64(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L84
	movq	-88(%rbp), %rax
	movl	8(%rax), %eax
	subl	-64(%rbp), %eax
	cltq
	movq	-88(%rbp), %rdx
	movq	32(%rdx), %rcx
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$1, %esi
	movq	%rcx, %rdi
	call	memset@PLT
	jmp	.L85
.L84:
	cmpl	$0, -48(%rbp)
	je	.L86
	cmpl	$0, -44(%rbp)
	je	.L86
	cmpl	$0, -72(%rbp)
	jne	.L86
	cmpl	$0, -68(%rbp)
	je	.L87
	movq	-88(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-64(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$2, (%rax)
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-64(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L88
	movl	-44(%rbp), %eax
	cltq
	movq	-88(%rbp), %rdx
	movq	32(%rdx), %rcx
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$2, %esi
	movq	%rcx, %rdi
	call	memset@PLT
	movl	-44(%rbp), %eax
	addl	%eax, -64(%rbp)
	movl	$0, -68(%rbp)
	movl	$1, -76(%rbp)
	jmp	.L81
.L88:
	addl	$1, -64(%rbp)
	jmp	.L81
.L87:
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-64(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L109
	movl	-48(%rbp), %eax
	cltq
	movq	-88(%rbp), %rdx
	movq	32(%rdx), %rcx
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$2, %esi
	movq	%rcx, %rdi
	call	memset@PLT
	movl	-48(%rbp), %eax
	addl	%eax, -64(%rbp)
	movl	$1, -68(%rbp)
	jmp	.L81
.L86:
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-64(%rbp), %eax
	cltq
	addq	%rax, %rcx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L90
	movl	-48(%rbp), %eax
	cltq
	movq	-88(%rbp), %rdx
	movq	32(%rdx), %rcx
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$2, %esi
	movq	%rcx, %rdi
	call	memset@PLT
	movl	-48(%rbp), %eax
	addl	%eax, -64(%rbp)
	movl	$1, -68(%rbp)
	jmp	.L81
.L109:
	nop
.L90:
	movq	144+E(%rip), %rax
	movl	48(%rax), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L91
	cmpl	$0, -72(%rbp)
	je	.L92
	movq	-88(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-64(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$5, (%rax)
	cmpb	$92, -78(%rbp)
	jne	.L93
	movl	-64(%rbp), %eax
	leal	1(%rax), %edx
	movq	-88(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	%eax, %edx
	jge	.L93
	movq	-88(%rbp), %rax
	movq	32(%rax), %rax
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	addq	%rdx, %rax
	movb	$5, (%rax)
	addl	$2, -64(%rbp)
	jmp	.L81
.L93:
	movsbl	-78(%rbp), %eax
	cmpl	%eax, -72(%rbp)
	jne	.L94
	movl	$0, -72(%rbp)
.L94:
	addl	$1, -64(%rbp)
	movl	$1, -76(%rbp)
	jmp	.L81
.L92:
	cmpb	$34, -78(%rbp)
	je	.L95
	cmpb	$39, -78(%rbp)
	jne	.L91
.L95:
	movsbl	-78(%rbp), %eax
	movl	%eax, -72(%rbp)
	movq	-88(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-64(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$5, (%rax)
	addl	$1, -64(%rbp)
	jmp	.L81
.L91:
	movq	144+E(%rip), %rax
	movl	48(%rax), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L96
	call	__ctype_b_loc@PLT
	movq	(%rax), %rax
	movsbq	-78(%rbp), %rdx
	addq	%rdx, %rdx
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L97
	cmpl	$0, -76(%rbp)
	jne	.L98
	cmpb	$6, -77(%rbp)
	je	.L98
.L97:
	cmpb	$46, -78(%rbp)
	jne	.L96
	cmpb	$6, -77(%rbp)
	jne	.L96
.L98:
	movq	-88(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-64(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$6, (%rax)
	addl	$1, -64(%rbp)
	movl	$0, -76(%rbp)
	jmp	.L81
.L96:
	cmpl	$0, -76(%rbp)
	je	.L99
	movl	$0, -60(%rbp)
	jmp	.L100
.L106:
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -56(%rbp)
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	subq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$124, %al
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -40(%rbp)
	cmpl	$0, -40(%rbp)
	je	.L101
	subl	$1, -56(%rbp)
.L101:
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	movq	-88(%rbp), %rcx
	movq	24(%rcx), %rsi
	movl	-64(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	%rsi, %rcx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L102
	movq	-88(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-64(%rbp), %ecx
	movl	-56(%rbp), %eax
	addl	%ecx, %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	is_seperator
	testl	%eax, %eax
	je	.L102
	movl	-56(%rbp), %eax
	cltq
	cmpl	$0, -40(%rbp)
	je	.L103
	movl	$4, %esi
	jmp	.L104
.L103:
	movl	$3, %esi
.L104:
	movq	-88(%rbp), %rdx
	movq	32(%rdx), %rcx
	movl	-64(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	memset@PLT
	movl	-56(%rbp), %eax
	addl	%eax, -64(%rbp)
	jmp	.L105
.L102:
	addl	$1, -60(%rbp)
.L100:
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L106
.L105:
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L99
	movl	$0, -76(%rbp)
	jmp	.L81
.L99:
	movsbl	-78(%rbp), %eax
	movl	%eax, %edi
	call	is_seperator
	movl	%eax, -76(%rbp)
	addl	$1, -64(%rbp)
.L81:
	movq	-88(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	%eax, -64(%rbp)
	jl	.L107
.L85:
	movq	-88(%rbp), %rax
	movl	40(%rax), %eax
	cmpl	%eax, -68(%rbp)
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -36(%rbp)
	movq	-88(%rbp), %rax
	movl	-68(%rbp), %edx
	movl	%edx, 40(%rax)
	cmpl	$0, -36(%rbp)
	je	.L70
	movq	-88(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L70
	movq	32+E(%rip), %rcx
	movq	-88(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	call	editorUpdateSyntax
	jmp	.L70
.L108:
	nop
.L70:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	editorUpdateSyntax, .-editorUpdateSyntax
	.globl	editorSyntaxToColor
	.type	editorSyntaxToColor, @function
editorSyntaxToColor:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$7, -4(%rbp)
	ja	.L111
	movl	-4(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L113(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L113(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L113:
	.long	.L111-.L113
	.long	.L118-.L113
	.long	.L118-.L113
	.long	.L117-.L113
	.long	.L116-.L113
	.long	.L115-.L113
	.long	.L114-.L113
	.long	.L112-.L113
	.text
.L118:
	movl	$36, %eax
	jmp	.L119
.L117:
	movl	$33, %eax
	jmp	.L119
.L116:
	movl	$32, %eax
	jmp	.L119
.L115:
	movl	$35, %eax
	jmp	.L119
.L114:
	movl	$31, %eax
	jmp	.L119
.L112:
	movl	$34, %eax
	jmp	.L119
.L111:
	movl	$37, %eax
.L119:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	editorSyntaxToColor, .-editorSyntaxToColor
	.globl	editorSelectSyntaxHighlight
	.type	editorSelectSyntaxHighlight, @function
editorSelectSyntaxHighlight:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	$0, 144+E(%rip)
	movq	48+E(%rip), %rax
	testq	%rax, %rax
	je	.L132
	movq	48+E(%rip), %rax
	movl	$46, %esi
	movq	%rax, %rdi
	call	strrchr@PLT
	movq	%rax, -16(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L123
.L131:
	movl	-32(%rbp), %edx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	HLDB(%rip), %rdx
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L124
.L130:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movl	-28(%rbp), %edx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L125
	cmpq	$0, -16(%rbp)
	je	.L125
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movl	-28(%rbp), %edx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L126
.L125:
	cmpl	$0, -20(%rbp)
	jne	.L127
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movl	-28(%rbp), %edx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	48+E(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strstr@PLT
	testq	%rax, %rax
	je	.L127
.L126:
	movq	-8(%rbp), %rax
	movq	%rax, 144+E(%rip)
	movl	$0, -24(%rbp)
	jmp	.L128
.L129:
	movq	32+E(%rip), %rcx
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	call	editorUpdateSyntax
	addl	$1, -24(%rbp)
.L128:
	movl	28+E(%rip), %eax
	cmpl	%eax, -24(%rbp)
	jl	.L129
	jmp	.L120
.L127:
	addl	$1, -28(%rbp)
.L124:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movl	-28(%rbp), %edx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L130
	addl	$1, -32(%rbp)
.L123:
	cmpl	$0, -32(%rbp)
	je	.L131
	jmp	.L120
.L132:
	nop
.L120:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	editorSelectSyntaxHighlight, .-editorSelectSyntaxHighlight
	.globl	editorRowCxToRx
	.type	editorRowCxToRx, @function
editorRowCxToRx:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L134
.L136:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$9, %al
	jne	.L135
	movl	-8(%rbp), %eax
	cltd
	shrl	$29, %edx
	addl	%edx, %eax
	andl	$7, %eax
	subl	%edx, %eax
	movl	$7, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, -8(%rbp)
.L135:
	addl	$1, -8(%rbp)
	addl	$1, -4(%rbp)
.L134:
	movl	-4(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L136
	movl	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	editorRowCxToRx, .-editorRowCxToRx
	.globl	editorRowRxToCx
	.type	editorRowRxToCx, @function
editorRowRxToCx:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L139
.L143:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$9, %al
	jne	.L140
	movl	-8(%rbp), %eax
	cltd
	shrl	$29, %edx
	addl	%edx, %eax
	andl	$7, %eax
	subl	%edx, %eax
	movl	$7, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, -8(%rbp)
.L140:
	addl	$1, -8(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle	.L141
	movl	-4(%rbp), %eax
	jmp	.L142
.L141:
	addl	$1, -4(%rbp)
.L139:
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L143
	movl	-4(%rbp), %eax
.L142:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	editorRowRxToCx, .-editorRowRxToCx
	.globl	editorUpdateRow
	.type	editorUpdateRow, @function
editorUpdateRow:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	$0, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L145
.L147:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$9, %al
	jne	.L146
	addl	$1, -12(%rbp)
.L146:
	addl	$1, -8(%rbp)
.L145:
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L147
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movl	4(%rax), %ecx
	movl	-12(%rbp), %edx
	movl	%edx, %eax
	sall	$3, %eax
	subl	%edx, %eax
	addl	%ecx, %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 24(%rax)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L148
.L153:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$9, %al
	jne	.L149
	movq	-24(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4(%rbp)
	cltq
	addq	%rcx, %rax
	movb	$32, (%rax)
	jmp	.L150
.L151:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4(%rbp)
	cltq
	addq	%rcx, %rax
	movb	$32, (%rax)
.L150:
	movl	-4(%rbp), %eax
	andl	$7, %eax
	testl	%eax, %eax
	jne	.L151
	jmp	.L152
.L149:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rcx
	movq	-24(%rbp), %rax
	movq	24(%rax), %rsi
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4(%rbp)
	cltq
	leaq	(%rsi,%rax), %rdx
	movzbl	(%rcx), %eax
	movb	%al, (%rdx)
.L152:
	addl	$1, -8(%rbp)
.L148:
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L153
	movq	-24(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movl	%edx, 8(%rax)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	editorUpdateSyntax
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	editorUpdateRow, .-editorUpdateRow
	.globl	editorInsertRow
	.type	editorInsertRow, @function
editorInsertRow:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	cmpl	$0, -36(%rbp)
	js	.L160
	movl	28+E(%rip), %eax
	cmpl	%eax, -36(%rbp)
	jg	.L160
	movl	28+E(%rip), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	32+E(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, 32+E(%rip)
	movl	28+E(%rip), %eax
	subl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdi
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rax, %rcx
	movq	32+E(%rip), %rsi
	movl	-36(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	movl	-36(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -20(%rbp)
	jmp	.L158
.L159:
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	(%rax), %edx
	addl	$1, %edx
	movl	%edx, (%rax)
	addl	$1, -20(%rbp)
.L158:
	movl	28+E(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jle	.L159
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	leaq	(%rcx,%rax), %rdx
	movl	-36(%rbp), %eax
	movl	%eax, (%rdx)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	-56(%rbp), %rdx
	movl	%edx, 4(%rax)
	movq	-56(%rbp), %rax
	leaq	1(%rax), %rcx
	movq	32+E(%rip), %rsi
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	leaq	(%rsi,%rax), %rbx
	movq	%rcx, %rdi
	call	malloc@PLT
	movq	%rax, 16(%rbx)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	16(%rax), %rax
	movq	-56(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	16(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	$0, 8(%rax)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	$0, 24(%rax)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	$0, 32(%rax)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	$0, 40(%rax)
	movq	32+E(%rip), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	call	editorUpdateRow
	movl	28+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 28+E(%rip)
	movl	40+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 40+E(%rip)
	jmp	.L154
.L160:
	nop
.L154:
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	editorInsertRow, .-editorInsertRow
	.globl	editorFreeRow
	.type	editorFreeRow, @function
editorFreeRow:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	editorFreeRow, .-editorFreeRow
	.globl	editorDelRow
	.type	editorDelRow, @function
editorDelRow:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	cmpl	$0, -20(%rbp)
	js	.L168
	movl	28+E(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jge	.L168
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, %rdi
	call	editorFreeRow
	movl	28+E(%rip), %eax
	subl	-20(%rbp), %eax
	subl	$1, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdi
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rax, %rcx
	movq	32+E(%rip), %rsi
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	movl	-20(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	.L166
.L167:
	movq	32+E(%rip), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	(%rax), %edx
	subl	$1, %edx
	movl	%edx, (%rax)
	addl	$1, -4(%rbp)
.L166:
	movl	28+E(%rip), %eax
	subl	$1, %eax
	cmpl	%eax, -4(%rbp)
	jl	.L167
	movl	28+E(%rip), %eax
	subl	$1, %eax
	movl	%eax, 28+E(%rip)
	movl	40+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 40+E(%rip)
	jmp	.L162
.L168:
	nop
.L162:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	editorDelRow, .-editorDelRow
	.globl	editorRowInsertChar
	.type	editorRowInsertChar, @function
editorRowInsertChar:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	cmpl	$0, -12(%rbp)
	js	.L170
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jle	.L171
.L170:
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -12(%rbp)
.L171:
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	addl	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	-8(%rbp), %rdx
	movq	%rax, 16(%rdx)
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	subl	-12(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	-8(%rbp), %rdx
	movq	16(%rdx), %rcx
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	leaq	(%rcx,%rdx), %rsi
	movq	-8(%rbp), %rdx
	movq	16(%rdx), %rdx
	movl	-12(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	$1, %rcx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	memmove@PLT
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 4(%rax)
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movl	-16(%rbp), %edx
	movb	%dl, (%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	editorUpdateRow
	movl	40+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 40+E(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	editorRowInsertChar, .-editorRowInsertChar
	.globl	editorRowAppendString
	.type	editorRowAppendString, @function
editorRowAppendString:
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	-8(%rbp), %rdx
	movq	%rax, 16(%rdx)
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	leaq	(%rdx,%rax), %rcx
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy@PLT
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	addl	%edx, %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, 4(%rax)
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	editorUpdateRow
	movl	40+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 40+E(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	editorRowAppendString, .-editorRowAppendString
	.globl	editorRowDelChar
	.type	editorRowDelChar, @function
editorRowDelChar:
.LFB24:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	cmpl	$0, -12(%rbp)
	js	.L177
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jge	.L177
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	subl	-12(%rbp), %eax
	cltq
	movq	-8(%rbp), %rdx
	movq	16(%rdx), %rdx
	movl	-12(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	$1, %rcx
	leaq	(%rdx,%rcx), %rsi
	movq	-8(%rbp), %rdx
	movq	16(%rdx), %rcx
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rcx
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	memmove@PLT
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	leal	-1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 4(%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	editorUpdateRow
	movl	40+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 40+E(%rip)
	jmp	.L173
.L177:
	nop
.L173:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	editorRowDelChar, .-editorRowDelChar
	.section	.rodata
.LC40:
	.string	""
	.text
	.globl	editorInsertChar
	.type	editorInsertChar, @function
editorInsertChar:
.LFB25:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jne	.L179
	movl	28+E(%rip), %eax
	movl	$0, %edx
	leaq	.LC40(%rip), %rsi
	movl	%eax, %edi
	call	editorInsertRow
.L179:
	movl	E(%rip), %ecx
	movq	32+E(%rip), %rsi
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	leaq	(%rsi,%rax), %rdi
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movl	%ecx, %esi
	call	editorRowInsertChar
	movl	E(%rip), %eax
	addl	$1, %eax
	movl	%eax, E(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	editorInsertChar, .-editorInsertChar
	.globl	editorInsertNewline
	.type	editorInsertNewline, @function
editorInsertNewline:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	E(%rip), %eax
	testl	%eax, %eax
	jne	.L181
	movl	4+E(%rip), %eax
	movl	$0, %edx
	leaq	.LC40(%rip), %rsi
	movl	%eax, %edi
	call	editorInsertRow
	jmp	.L182
.L181:
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	4(%rax), %edx
	movl	E(%rip), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cltq
	movq	-8(%rbp), %rdx
	movq	16(%rdx), %rcx
	movl	E(%rip), %edx
	movslq	%edx, %rdx
	leaq	(%rcx,%rdx), %rsi
	movl	4+E(%rip), %edx
	leal	1(%rdx), %ecx
	movq	%rax, %rdx
	movl	%ecx, %edi
	call	editorInsertRow
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, -8(%rbp)
	movl	E(%rip), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 4(%rax)
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	editorUpdateRow
.L182:
	movl	4+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 4+E(%rip)
	movl	$0, E(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	editorInsertNewline, .-editorInsertNewline
	.globl	editorDelChar
	.type	editorDelChar, @function
editorDelChar:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	je	.L188
	movl	E(%rip), %eax
	testl	%eax, %eax
	jne	.L186
	movl	4+E(%rip), %eax
	testl	%eax, %eax
	je	.L189
.L186:
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, -8(%rbp)
	movl	E(%rip), %eax
	testl	%eax, %eax
	jle	.L187
	movl	E(%rip), %eax
	leal	-1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	editorRowDelChar
	movl	E(%rip), %eax
	subl	$1, %eax
	movl	%eax, E(%rip)
	jmp	.L183
.L187:
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	subq	$48, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	movl	%eax, E(%rip)
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rsi
	movq	-8(%rbp), %rax
	movq	16(%rax), %rcx
	movq	32+E(%rip), %rdi
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	subq	$48, %rax
	addq	%rdi, %rax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	editorRowAppendString
	movl	4+E(%rip), %eax
	movl	%eax, %edi
	call	editorDelRow
	movl	4+E(%rip), %eax
	subl	$1, %eax
	movl	%eax, 4+E(%rip)
	jmp	.L183
.L188:
	nop
	jmp	.L183
.L189:
	nop
.L183:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	editorDelChar, .-editorDelChar
	.globl	editorRowsToString
	.type	editorRowsToString, @function
editorRowsToString:
.LFB28:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	$0, -24(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L191
.L192:
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	addl	$1, %eax
	addl	%eax, -24(%rbp)
	addl	$1, -20(%rbp)
.L191:
	movl	28+E(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L192
	movq	-40(%rbp), %rax
	movl	-24(%rbp), %edx
	movl	%edx, (%rax)
	movl	-24(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L193
.L194:
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	movslq	%eax, %rsi
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	16(%rax), %rcx
	movq	-16(%rbp), %rax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movq	32+E(%rip), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	cltq
	addq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movb	$10, (%rax)
	addq	$1, -16(%rbp)
	addl	$1, -20(%rbp)
.L193:
	movl	28+E(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L194
	movq	-8(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	editorRowsToString, .-editorRowsToString
	.section	.rodata
.LC41:
	.string	"r"
.LC42:
	.string	"fopen"
	.text
	.globl	editorOpen
	.type	editorOpen, @function
editorOpen:
.LFB29:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	48+E(%rip), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strdup@PLT
	movq	%rax, 48+E(%rip)
	movl	$0, %eax
	call	editorSelectSyntaxHighlight
	movq	-56(%rbp), %rax
	leaq	.LC41(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L197
	leaq	.LC42(%rip), %rdi
	call	die
.L197:
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	jmp	.L198
.L201:
	subq	$1, -24(%rbp)
.L199:
	cmpq	$0, -24(%rbp)
	jle	.L200
	movq	-40(%rbp), %rax
	movq	-24(%rbp), %rdx
	subq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	je	.L201
	movq	-40(%rbp), %rax
	movq	-24(%rbp), %rdx
	subq	$1, %rdx
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$13, %al
	je	.L201
.L200:
	movq	-24(%rbp), %rdx
	movq	-40(%rbp), %rcx
	movl	28+E(%rip), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	editorInsertRow
.L198:
	movq	-16(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-40(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	getline@PLT
	movq	%rax, -24(%rbp)
	cmpq	$-1, -24(%rbp)
	jne	.L199
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movl	$0, 40+E(%rip)
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L203
	call	__stack_chk_fail@PLT
.L203:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	editorOpen, .-editorOpen
	.section	.rodata
.LC43:
	.string	"Save as: %s (ESC to cancel)"
.LC44:
	.string	"Save aborted"
.LC45:
	.string	"%d bytes written to disk"
.LC46:
	.string	"Can't save! I/O error: %s"
	.text
	.globl	editorSave
	.type	editorSave, @function
editorSave:
.LFB30:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	48+E(%rip), %rax
	testq	%rax, %rax
	jne	.L205
	movl	$0, %esi
	leaq	.LC43(%rip), %rdi
	call	editorPrompt
	movq	%rax, 48+E(%rip)
	movq	48+E(%rip), %rax
	testq	%rax, %rax
	jne	.L206
	leaq	.LC44(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
	jmp	.L204
.L206:
	movl	$0, %eax
	call	editorSelectSyntaxHighlight
.L205:
	leaq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	editorRowsToString
	movq	%rax, -16(%rbp)
	movq	48+E(%rip), %rax
	movl	$420, %edx
	movl	$66, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	je	.L208
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movl	-20(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	ftruncate@PLT
	cmpl	$-1, %eax
	je	.L209
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rax
	jne	.L209
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, 40+E(%rip)
	movl	-24(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC45(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
	jmp	.L204
.L209:
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L208:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	call	__errno_location@PLT
	movl	(%rax), %eax
	movl	%eax, %edi
	call	strerror@PLT
	movq	%rax, %rsi
	leaq	.LC46(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
.L204:
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L211
	call	__stack_chk_fail@PLT
.L211:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	editorSave, .-editorSave
	.globl	editorFindCallback
	.type	editorFindCallback, @function
editorFindCallback:
.LFB31:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movq	saved_hl.4724(%rip), %rax
	testq	%rax, %rax
	je	.L213
	movq	32+E(%rip), %rcx
	movl	saved_hl_line.4723(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	8(%rax), %eax
	movslq	%eax, %rsi
	movq	saved_hl.4724(%rip), %rcx
	movq	32+E(%rip), %rdi
	movl	saved_hl_line.4723(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rdi, %rax
	movq	32(%rax), %rax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movq	saved_hl.4724(%rip), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	$0, saved_hl.4724(%rip)
.L213:
	cmpl	$13, -44(%rbp)
	je	.L214
	cmpl	$27, -44(%rbp)
	jne	.L215
.L214:
	movl	$-1, last_match.4721(%rip)
	movl	$1, direction.4722(%rip)
	jmp	.L212
.L215:
	cmpl	$1001, -44(%rbp)
	je	.L217
	cmpl	$1003, -44(%rbp)
	jne	.L218
.L217:
	movl	$1, direction.4722(%rip)
	jmp	.L219
.L218:
	cmpl	$1000, -44(%rbp)
	je	.L220
	cmpl	$1002, -44(%rbp)
	jne	.L221
.L220:
	movl	$-1, direction.4722(%rip)
	jmp	.L219
.L221:
	movl	$-1, last_match.4721(%rip)
	movl	$1, direction.4722(%rip)
.L219:
	movl	last_match.4721(%rip), %eax
	cmpl	$-1, %eax
	jne	.L222
	movl	$1, direction.4722(%rip)
.L222:
	movl	last_match.4721(%rip), %eax
	movl	%eax, -24(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L223
.L227:
	movl	direction.4722(%rip), %eax
	addl	%eax, -24(%rbp)
	cmpl	$-1, -24(%rbp)
	jne	.L224
	movl	28+E(%rip), %eax
	subl	$1, %eax
	movl	%eax, -24(%rbp)
	jmp	.L225
.L224:
	movl	28+E(%rip), %eax
	cmpl	%eax, -24(%rbp)
	jne	.L225
	movl	$0, -24(%rbp)
.L225:
	movq	32+E(%rip), %rcx
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strstr@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L226
	movl	-24(%rbp), %eax
	movl	%eax, last_match.4721(%rip)
	movl	-24(%rbp), %eax
	movl	%eax, 4+E(%rip)
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	movq	-8(%rbp), %rdx
	subq	%rax, %rdx
	movq	%rdx, %rax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	editorRowRxToCx
	movl	%eax, E(%rip)
	movl	28+E(%rip), %eax
	movl	%eax, 12+E(%rip)
	movl	-24(%rbp), %eax
	movl	%eax, saved_hl_line.4723(%rip)
	movq	-16(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, saved_hl.4724(%rip)
	movq	-16(%rbp), %rax
	movl	8(%rax), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	32(%rax), %rcx
	movq	saved_hl.4724(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	32(%rax), %rcx
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	movq	-8(%rbp), %rsi
	subq	%rax, %rsi
	movq	%rsi, %rax
	addq	%rcx, %rax
	movl	$7, %esi
	movq	%rax, %rdi
	call	memset@PLT
	jmp	.L212
.L226:
	addl	$1, -20(%rbp)
.L223:
	movl	28+E(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jl	.L227
.L212:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	editorFindCallback, .-editorFindCallback
	.section	.rodata
.LC47:
	.string	"Search: %s (ESC/Arrows/Enter)"
	.text
	.globl	editorFind
	.type	editorFind, @function
editorFind:
.LFB32:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	E(%rip), %eax
	movl	%eax, -24(%rbp)
	movl	4+E(%rip), %eax
	movl	%eax, -20(%rbp)
	movl	16+E(%rip), %eax
	movl	%eax, -16(%rbp)
	movl	12+E(%rip), %eax
	movl	%eax, -12(%rbp)
	leaq	editorFindCallback(%rip), %rsi
	leaq	.LC47(%rip), %rdi
	call	editorPrompt
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L229
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L231
.L229:
	movl	-24(%rbp), %eax
	movl	%eax, E(%rip)
	movl	-20(%rbp), %eax
	movl	%eax, 4+E(%rip)
	movl	-16(%rbp), %eax
	movl	%eax, 16+E(%rip)
	movl	-12(%rbp), %eax
	movl	%eax, 12+E(%rip)
.L231:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	editorFind, .-editorFind
	.globl	abAppend
	.type	abAppend, @function
abAppend:
.LFB33:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movl	-36(%rbp), %eax
	addl	%edx, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L235
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	movslq	%eax, %rcx
	movq	-8(%rbp), %rax
	addq	%rax, %rcx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy@PLT
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-24(%rbp), %rax
	movl	8(%rax), %edx
	movl	-36(%rbp), %eax
	addl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, 8(%rax)
	jmp	.L232
.L235:
	nop
.L232:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	abAppend, .-abAppend
	.globl	abFree
	.type	abFree, @function
abFree:
.LFB34:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	abFree, .-abFree
	.globl	editorScroll
	.type	editorScroll, @function
editorScroll:
.LFB35:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, 8+E(%rip)
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L238
	movl	E(%rip), %ecx
	movq	32+E(%rip), %rsi
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rsi, %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	editorRowCxToRx
	movl	%eax, 8+E(%rip)
.L238:
	movl	4+E(%rip), %edx
	movl	12+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L239
	movl	4+E(%rip), %eax
	movl	%eax, 12+E(%rip)
.L239:
	movl	4+E(%rip), %eax
	movl	12+E(%rip), %ecx
	movl	20+E(%rip), %edx
	addl	%ecx, %edx
	cmpl	%edx, %eax
	jl	.L240
	movl	4+E(%rip), %edx
	movl	20+E(%rip), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	addl	$1, %eax
	movl	%eax, 12+E(%rip)
.L240:
	movl	8+E(%rip), %edx
	movl	16+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L241
	movl	8+E(%rip), %eax
	movl	%eax, 16+E(%rip)
.L241:
	movl	8+E(%rip), %eax
	movl	16+E(%rip), %ecx
	movl	24+E(%rip), %edx
	addl	%ecx, %edx
	cmpl	%edx, %eax
	jl	.L243
	movl	8+E(%rip), %edx
	movl	24+E(%rip), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	addl	$1, %eax
	movl	%eax, 16+E(%rip)
.L243:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	editorScroll, .-editorScroll
	.section	.rodata
.LC48:
	.string	"1.0.3"
.LC49:
	.string	"tEdit editor -- verison %s"
.LC50:
	.string	"~"
.LC51:
	.string	" "
.LC52:
	.string	"\033[7m"
.LC53:
	.string	"\033[m"
.LC54:
	.string	"\033[%dm"
.LC55:
	.string	"\033[39m"
.LC56:
	.string	"\033[K"
.LC57:
	.string	"\r\n"
	.text
	.globl	editorDrawRows
	.type	editorDrawRows, @function
editorDrawRows:
.LFB36:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -152(%rbp)
	jmp	.L245
.L266:
	movl	12+E(%rip), %edx
	movl	-152(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -128(%rbp)
	movl	28+E(%rip), %eax
	cmpl	%eax, -128(%rbp)
	jl	.L246
	movl	28+E(%rip), %eax
	testl	%eax, %eax
	jne	.L247
	movl	20+E(%rip), %eax
	movslq	%eax, %rdx
	imulq	$1431655766, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$31, %eax
	movl	%edx, %esi
	subl	%eax, %esi
	movl	%esi, %eax
	cmpl	%eax, -152(%rbp)
	jne	.L247
	leaq	-96(%rbp), %rax
	leaq	.LC48(%rip), %rcx
	leaq	.LC49(%rip), %rdx
	movl	$80, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movl	%eax, -148(%rbp)
	movl	24+E(%rip), %eax
	cmpl	%eax, -148(%rbp)
	jle	.L248
	movl	24+E(%rip), %eax
	movl	%eax, -148(%rbp)
.L248:
	movl	24+E(%rip), %eax
	subl	-148(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -144(%rbp)
	cmpl	$0, -144(%rbp)
	je	.L250
	movq	-168(%rbp), %rax
	movl	$1, %edx
	leaq	.LC50(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	subl	$1, -144(%rbp)
	jmp	.L250
.L251:
	movq	-168(%rbp), %rax
	movl	$1, %edx
	leaq	.LC51(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
.L250:
	movl	-144(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -144(%rbp)
	testl	%eax, %eax
	jne	.L251
	movl	-148(%rbp), %edx
	leaq	-96(%rbp), %rcx
	movq	-168(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	jmp	.L253
.L247:
	movq	-168(%rbp), %rax
	movl	$1, %edx
	leaq	.LC50(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	jmp	.L253
.L246:
	movq	32+E(%rip), %rcx
	movl	-128(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	8(%rax), %edx
	movl	16+E(%rip), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -140(%rbp)
	cmpl	$0, -140(%rbp)
	jns	.L254
	movl	$0, -140(%rbp)
.L254:
	movl	24+E(%rip), %eax
	cmpl	%eax, -140(%rbp)
	jle	.L255
	movl	24+E(%rip), %eax
	movl	%eax, -140(%rbp)
.L255:
	movq	32+E(%rip), %rcx
	movl	-128(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	24(%rax), %rdx
	movl	16+E(%rip), %eax
	cltq
	addq	%rdx, %rax
	movq	%rax, -112(%rbp)
	movq	32+E(%rip), %rcx
	movl	-128(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movq	32(%rax), %rdx
	movl	16+E(%rip), %eax
	cltq
	addq	%rdx, %rax
	movq	%rax, -104(%rbp)
	movl	$-1, -136(%rbp)
	movl	$0, -132(%rbp)
	jmp	.L256
.L265:
	call	__ctype_b_loc@PLT
	movq	(%rax), %rax
	movl	-132(%rbp), %edx
	movslq	%edx, %rcx
	movq	-112(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rdx), %edx
	movsbq	%dl, %rdx
	addq	%rdx, %rdx
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L257
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movq	-112(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$26, %al
	jg	.L258
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movq	-112(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	addl	$64, %eax
	jmp	.L259
.L258:
	movl	$63, %eax
.L259:
	movb	%al, -153(%rbp)
	movq	-168(%rbp), %rax
	movl	$4, %edx
	leaq	.LC52(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	leaq	-153(%rbp), %rcx
	movq	-168(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	movq	-168(%rbp), %rax
	movl	$3, %edx
	leaq	.LC53(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	cmpl	$1, -136(%rbp)
	je	.L261
	movl	-136(%rbp), %edx
	leaq	-96(%rbp), %rax
	movl	%edx, %ecx
	leaq	.LC54(%rip), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movl	%eax, -116(%rbp)
	movl	-116(%rbp), %edx
	leaq	-96(%rbp), %rcx
	movq	-168(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	jmp	.L261
.L257:
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L262
	cmpl	$-1, -136(%rbp)
	je	.L263
	movq	-168(%rbp), %rax
	movl	$5, %edx
	leaq	.LC55(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	movl	$-1, -136(%rbp)
.L263:
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movq	-112(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-168(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	jmp	.L261
.L262:
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %edi
	call	editorSyntaxToColor
	movl	%eax, -124(%rbp)
	movl	-124(%rbp), %eax
	cmpl	-136(%rbp), %eax
	je	.L264
	movl	-124(%rbp), %eax
	movl	%eax, -136(%rbp)
	movl	-124(%rbp), %edx
	leaq	-96(%rbp), %rax
	movl	%edx, %ecx
	leaq	.LC54(%rip), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movl	%eax, -120(%rbp)
	movl	-120(%rbp), %edx
	leaq	-96(%rbp), %rcx
	movq	-168(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
.L264:
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movq	-112(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-168(%rbp), %rax
	movl	$1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
.L261:
	addl	$1, -132(%rbp)
.L256:
	movl	-132(%rbp), %eax
	cmpl	-140(%rbp), %eax
	jl	.L265
	movq	-168(%rbp), %rax
	movl	$5, %edx
	leaq	.LC55(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
.L253:
	movq	-168(%rbp), %rax
	movl	$3, %edx
	leaq	.LC56(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	movq	-168(%rbp), %rax
	movl	$2, %edx
	leaq	.LC57(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	addl	$1, -152(%rbp)
.L245:
	movl	20+E(%rip), %eax
	cmpl	%eax, -152(%rbp)
	jl	.L266
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L267
	call	__stack_chk_fail@PLT
.L267:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	editorDrawRows, .-editorDrawRows
	.section	.rodata
.LC58:
	.string	"(modified)"
.LC59:
	.string	"[No Name]"
.LC60:
	.string	"%.20s - %d lines %s"
.LC61:
	.string	"no ft"
.LC62:
	.string	"%s | %d/%d"
	.text
	.globl	editorDrawStatusBar
	.type	editorDrawStatusBar, @function
editorDrawStatusBar:
.LFB37:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$208, %rsp
	movq	%rdi, -200(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-200(%rbp), %rax
	movl	$4, %edx
	leaq	.LC52(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	movl	40+E(%rip), %eax
	testl	%eax, %eax
	je	.L269
	leaq	.LC58(%rip), %rdx
	jmp	.L270
.L269:
	leaq	.LC51(%rip), %rdx
.L270:
	movl	28+E(%rip), %ecx
	movq	48+E(%rip), %rax
	testq	%rax, %rax
	je	.L271
	movq	48+E(%rip), %rax
	jmp	.L272
.L271:
	leaq	.LC59(%rip), %rax
.L272:
	leaq	-176(%rbp), %rdi
	movq	%rdx, %r9
	movl	%ecx, %r8d
	movq	%rax, %rcx
	leaq	.LC60(%rip), %rdx
	movl	$80, %esi
	movl	$0, %eax
	call	snprintf@PLT
	movl	%eax, -184(%rbp)
	movl	28+E(%rip), %edx
	movl	4+E(%rip), %eax
	leal	1(%rax), %ecx
	movq	144+E(%rip), %rax
	testq	%rax, %rax
	je	.L273
	movq	144+E(%rip), %rax
	movq	(%rax), %rax
	jmp	.L274
.L273:
	leaq	.LC61(%rip), %rax
.L274:
	leaq	-96(%rbp), %rdi
	movl	%edx, %r9d
	movl	%ecx, %r8d
	movq	%rax, %rcx
	leaq	.LC62(%rip), %rdx
	movl	$80, %esi
	movl	$0, %eax
	call	snprintf@PLT
	movl	%eax, -180(%rbp)
	movl	24+E(%rip), %eax
	cmpl	%eax, -184(%rbp)
	jle	.L275
	movl	24+E(%rip), %eax
	movl	%eax, -184(%rbp)
.L275:
	movl	-184(%rbp), %edx
	leaq	-176(%rbp), %rcx
	movq	-200(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	jmp	.L276
.L279:
	movl	24+E(%rip), %eax
	subl	-184(%rbp), %eax
	cmpl	%eax, -180(%rbp)
	jne	.L277
	movl	-180(%rbp), %edx
	leaq	-96(%rbp), %rcx
	movq	-200(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	jmp	.L278
.L277:
	movq	-200(%rbp), %rax
	movl	$1, %edx
	leaq	.LC51(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	addl	$1, -184(%rbp)
.L276:
	movl	24+E(%rip), %eax
	cmpl	%eax, -184(%rbp)
	jl	.L279
.L278:
	movq	-200(%rbp), %rax
	movl	$3, %edx
	leaq	.LC53(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	movq	-200(%rbp), %rax
	movl	$2, %edx
	leaq	.LC57(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L280
	call	__stack_chk_fail@PLT
.L280:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	editorDrawStatusBar, .-editorDrawStatusBar
	.globl	editorDrawMessageBar
	.type	editorDrawMessageBar, @function
editorDrawMessageBar:
.LFB38:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	$3, %edx
	leaq	.LC56(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	leaq	56+E(%rip), %rdi
	call	strlen@PLT
	movl	%eax, -4(%rbp)
	movl	24+E(%rip), %eax
	cmpl	%eax, -4(%rbp)
	jle	.L282
	movl	24+E(%rip), %eax
	movl	%eax, -4(%rbp)
.L282:
	cmpl	$0, -4(%rbp)
	je	.L284
	movl	$0, %edi
	call	time@PLT
	movq	136+E(%rip), %rdx
	subq	%rdx, %rax
	cmpq	$4, %rax
	jg	.L284
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	leaq	56+E(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
.L284:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	editorDrawMessageBar, .-editorDrawMessageBar
	.section	.rodata
.LC63:
	.string	"\033[?25l"
.LC64:
	.string	"\033[%d;%dH"
.LC65:
	.string	"\033[?25h"
	.text
	.globl	editorRefreshScreen
	.type	editorRefreshScreen, @function
editorRefreshScreen:
.LFB39:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, %eax
	call	editorScroll
	movq	$0, -64(%rbp)
	movl	$0, -56(%rbp)
	leaq	-64(%rbp), %rax
	movl	$6, %edx
	leaq	.LC63(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	leaq	-64(%rbp), %rax
	movl	$3, %edx
	leaq	.LC31(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	editorDrawRows
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	editorDrawStatusBar
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	editorDrawMessageBar
	movl	8+E(%rip), %edx
	movl	16+E(%rip), %eax
	addl	%edx, %eax
	leal	1(%rax), %ecx
	movl	4+E(%rip), %edx
	movl	12+E(%rip), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	leal	1(%rax), %edx
	leaq	-48(%rbp), %rax
	movl	%ecx, %r8d
	movl	%edx, %ecx
	leaq	.LC64(%rip), %rdx
	movl	$32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, %edx
	leaq	-48(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	abAppend
	leaq	-64(%rbp), %rax
	movl	$6, %edx
	leaq	.LC65(%rip), %rsi
	movq	%rax, %rdi
	call	abAppend
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	abFree
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L286
	call	__stack_chk_fail@PLT
.L286:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	editorRefreshScreen, .-editorRefreshScreen
	.globl	editorSetStatusMessage
	.type	editorSetStatusMessage, @function
editorSetStatusMessage:
.LFB40:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$224, %rsp
	movq	%rdi, -216(%rbp)
	movq	%rsi, -168(%rbp)
	movq	%rdx, -160(%rbp)
	movq	%rcx, -152(%rbp)
	movq	%r8, -144(%rbp)
	movq	%r9, -136(%rbp)
	testb	%al, %al
	je	.L288
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm1, -112(%rbp)
	movaps	%xmm2, -96(%rbp)
	movaps	%xmm3, -80(%rbp)
	movaps	%xmm4, -64(%rbp)
	movaps	%xmm5, -48(%rbp)
	movaps	%xmm6, -32(%rbp)
	movaps	%xmm7, -16(%rbp)
.L288:
	movq	%fs:40, %rax
	movq	%rax, -184(%rbp)
	xorl	%eax, %eax
	movl	$8, -208(%rbp)
	movl	$48, -204(%rbp)
	leaq	16(%rbp), %rax
	movq	%rax, -200(%rbp)
	leaq	-176(%rbp), %rax
	movq	%rax, -192(%rbp)
	leaq	-208(%rbp), %rdx
	movq	-216(%rbp), %rax
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$80, %esi
	leaq	56+E(%rip), %rdi
	call	vsnprintf@PLT
	movl	$0, %edi
	call	time@PLT
	movq	%rax, 136+E(%rip)
	nop
	movq	-184(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L289
	call	__stack_chk_fail@PLT
.L289:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	editorSetStatusMessage, .-editorSetStatusMessage
	.globl	editorPrompt
	.type	editorPrompt, @function
editorPrompt:
.LFB41:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	$128, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	movq	$0, -8(%rbp)
	movq	-16(%rbp), %rax
	movb	$0, (%rax)
.L302:
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
	movl	$0, %eax
	call	editorRefreshScreen
	movl	$0, %eax
	call	editorReadKey
	movl	%eax, -28(%rbp)
	cmpl	$1004, -28(%rbp)
	je	.L291
	cmpl	$8, -28(%rbp)
	je	.L291
	cmpl	$127, -28(%rbp)
	jne	.L292
.L291:
	cmpq	$0, -8(%rbp)
	je	.L294
	subq	$1, -8(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	jmp	.L294
.L292:
	cmpl	$27, -28(%rbp)
	jne	.L295
	leaq	.LC40(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
	cmpq	$0, -48(%rbp)
	je	.L296
	movl	-28(%rbp), %edx
	movq	-16(%rbp), %rax
	movq	-48(%rbp), %rcx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	*%rcx
.L296:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
	jmp	.L297
.L295:
	cmpl	$13, -28(%rbp)
	jne	.L298
	cmpq	$0, -8(%rbp)
	je	.L294
	leaq	.LC40(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
	cmpq	$0, -48(%rbp)
	je	.L299
	movl	-28(%rbp), %edx
	movq	-16(%rbp), %rax
	movq	-48(%rbp), %rcx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	*%rcx
.L299:
	movq	-16(%rbp), %rax
	jmp	.L297
.L298:
	call	__ctype_b_loc@PLT
	movq	(%rax), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	addq	%rdx, %rdx
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2, %eax
	testl	%eax, %eax
	jne	.L294
	cmpl	$127, -28(%rbp)
	jg	.L294
	movq	-24(%rbp), %rax
	subq	$1, %rax
	cmpq	%rax, -8(%rbp)
	jne	.L300
	salq	-24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, -16(%rbp)
.L300:
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	addq	%rdx, %rax
	movl	-28(%rbp), %edx
	movb	%dl, (%rax)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
.L294:
	cmpq	$0, -48(%rbp)
	je	.L302
	movl	-28(%rbp), %edx
	movq	-16(%rbp), %rax
	movq	-48(%rbp), %rcx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	*%rcx
	jmp	.L302
.L297:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE41:
	.size	editorPrompt, .-editorPrompt
	.globl	editorMoveCursor
	.type	editorMoveCursor, @function
editorMoveCursor:
.LFB42:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L304
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	jmp	.L305
.L304:
	movl	$0, %eax
.L305:
	movq	%rax, -8(%rbp)
	cmpl	$1003, -20(%rbp)
	je	.L306
	cmpl	$1003, -20(%rbp)
	jg	.L307
	cmpl	$1002, -20(%rbp)
	je	.L308
	cmpl	$1002, -20(%rbp)
	jg	.L307
	cmpl	$1000, -20(%rbp)
	je	.L309
	cmpl	$1001, -20(%rbp)
	je	.L310
	jmp	.L307
.L309:
	movl	E(%rip), %eax
	testl	%eax, %eax
	je	.L311
	movl	E(%rip), %eax
	subl	$1, %eax
	movl	%eax, E(%rip)
	jmp	.L322
.L311:
	movl	4+E(%rip), %eax
	testl	%eax, %eax
	jle	.L322
	movl	4+E(%rip), %eax
	subl	$1, %eax
	movl	%eax, 4+E(%rip)
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	movl	%eax, E(%rip)
	jmp	.L322
.L310:
	cmpq	$0, -8(%rbp)
	je	.L313
	movl	E(%rip), %edx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %edx
	jge	.L313
	movl	E(%rip), %eax
	addl	$1, %eax
	movl	%eax, E(%rip)
	jmp	.L323
.L313:
	cmpq	$0, -8(%rbp)
	je	.L323
	movl	E(%rip), %edx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %edx
	jne	.L323
	movl	4+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 4+E(%rip)
	movl	$0, E(%rip)
	jmp	.L323
.L308:
	movl	4+E(%rip), %eax
	testl	%eax, %eax
	je	.L324
	movl	4+E(%rip), %eax
	subl	$1, %eax
	movl	%eax, 4+E(%rip)
	jmp	.L324
.L306:
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	je	.L325
	movl	4+E(%rip), %eax
	addl	$1, %eax
	movl	%eax, 4+E(%rip)
	jmp	.L325
.L322:
	nop
	jmp	.L307
.L323:
	nop
	jmp	.L307
.L324:
	nop
	jmp	.L307
.L325:
	nop
.L307:
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L317
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	jmp	.L318
.L317:
	movl	$0, %eax
.L318:
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L319
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	jmp	.L320
.L319:
	movl	$0, %eax
.L320:
	movl	%eax, -12(%rbp)
	movl	E(%rip), %eax
	cmpl	%eax, -12(%rbp)
	jge	.L326
	movl	-12(%rbp), %eax
	movl	%eax, E(%rip)
.L326:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE42:
	.size	editorMoveCursor, .-editorMoveCursor
	.section	.rodata
	.align 8
.LC66:
	.string	"WARNING: File has unsaved changes!!Press Ctrl-Q %d more times to quit."
	.text
	.globl	editorProcessKeypress
	.type	editorProcessKeypress, @function
editorProcessKeypress:
.LFB43:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, %eax
	call	editorReadKey
	movl	%eax, -4(%rbp)
	cmpl	$1008, -4(%rbp)
	jg	.L328
	cmpl	$1000, -4(%rbp)
	jge	.L329
	cmpl	$27, -4(%rbp)
	jg	.L330
	cmpl	$6, -4(%rbp)
	jge	.L331
	jmp	.L328
.L329:
	movl	-4(%rbp), %eax
	subl	$1000, %eax
	cmpl	$8, %eax
	ja	.L328
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L333(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L333(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L333:
	.long	.L337-.L333
	.long	.L337-.L333
	.long	.L337-.L333
	.long	.L337-.L333
	.long	.L336-.L333
	.long	.L335-.L333
	.long	.L334-.L333
	.long	.L332-.L333
	.long	.L332-.L333
	.text
.L331:
	movl	-4(%rbp), %eax
	subl	$6, %eax
	cmpl	$21, %eax
	ja	.L328
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L339(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L339(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L339:
	.long	.L343-.L339
	.long	.L328-.L339
	.long	.L336-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L355-.L339
	.long	.L342-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L341-.L339
	.long	.L328-.L339
	.long	.L340-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L328-.L339
	.long	.L355-.L339
	.text
.L330:
	cmpl	$127, -4(%rbp)
	je	.L336
	jmp	.L328
.L342:
	movl	$0, %eax
	call	editorInsertNewline
	jmp	.L344
.L341:
	movl	40+E(%rip), %eax
	testl	%eax, %eax
	je	.L345
	movl	quit_times.4826(%rip), %eax
	testl	%eax, %eax
	jle	.L345
	movl	quit_times.4826(%rip), %eax
	movl	%eax, %esi
	leaq	.LC66(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
	movl	quit_times.4826(%rip), %eax
	subl	$1, %eax
	movl	%eax, quit_times.4826(%rip)
	jmp	.L327
.L345:
	movl	$4, %edx
	leaq	.LC30(%rip), %rsi
	movl	$1, %edi
	call	write@PLT
	movl	$3, %edx
	leaq	.LC31(%rip), %rsi
	movl	$1, %edi
	call	write@PLT
	movl	$0, %edi
	call	exit@PLT
.L340:
	movl	$0, %eax
	call	editorSave
	jmp	.L344
.L335:
	movl	$0, E(%rip)
	jmp	.L344
.L334:
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jge	.L356
	movq	32+E(%rip), %rcx
	movl	4+E(%rip), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	addq	%rcx, %rax
	movl	4(%rax), %eax
	movl	%eax, E(%rip)
	jmp	.L356
.L343:
	movl	$0, %eax
	call	editorFind
	jmp	.L344
.L336:
	cmpl	$1004, -4(%rbp)
	jne	.L348
	movl	$1001, %edi
	call	editorMoveCursor
.L348:
	movl	$0, %eax
	call	editorDelChar
	jmp	.L344
.L332:
	cmpl	$1007, -4(%rbp)
	jne	.L349
	movl	12+E(%rip), %eax
	movl	%eax, 4+E(%rip)
	jmp	.L350
.L349:
	cmpl	$1008, -4(%rbp)
	jne	.L350
	movl	12+E(%rip), %edx
	movl	20+E(%rip), %eax
	addl	%edx, %eax
	subl	$1, %eax
	movl	%eax, 4+E(%rip)
	movl	4+E(%rip), %edx
	movl	28+E(%rip), %eax
	cmpl	%eax, %edx
	jle	.L350
	movl	28+E(%rip), %eax
	movl	%eax, 4+E(%rip)
.L350:
	movl	20+E(%rip), %eax
	movl	%eax, -8(%rbp)
	jmp	.L351
.L354:
	cmpl	$1007, -4(%rbp)
	jne	.L352
	movl	$1002, %eax
	jmp	.L353
.L352:
	movl	$1003, %eax
.L353:
	movl	%eax, %edi
	call	editorMoveCursor
.L351:
	movl	-8(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -8(%rbp)
	testl	%eax, %eax
	jne	.L354
	jmp	.L344
.L337:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	editorMoveCursor
	jmp	.L344
.L328:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	editorInsertChar
	jmp	.L344
.L355:
	nop
	jmp	.L344
.L356:
	nop
.L344:
	movl	$3, quit_times.4826(%rip)
.L327:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE43:
	.size	editorProcessKeypress, .-editorProcessKeypress
	.section	.rodata
.LC67:
	.string	"getWindwowSize"
	.text
	.globl	initEditor
	.type	initEditor, @function
initEditor:
.LFB44:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, E(%rip)
	movl	$0, 4+E(%rip)
	movl	$0, 8+E(%rip)
	movl	$0, 12+E(%rip)
	movl	$0, 16+E(%rip)
	movl	$0, 28+E(%rip)
	movq	$0, 32+E(%rip)
	movl	$0, 40+E(%rip)
	movq	$0, 48+E(%rip)
	movb	$0, 56+E(%rip)
	movq	$0, 136+E(%rip)
	movq	$0, 144+E(%rip)
	leaq	24+E(%rip), %rsi
	leaq	20+E(%rip), %rdi
	call	getWindowSize
	cmpl	$-1, %eax
	jne	.L358
	leaq	.LC67(%rip), %rdi
	call	die
.L358:
	movl	20+E(%rip), %eax
	subl	$2, %eax
	movl	%eax, 20+E(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE44:
	.size	initEditor, .-initEditor
	.section	.rodata
	.align 8
.LC68:
	.string	"HELP: Ctrl-Q = quit | Ctrl-S = save | Ctrl-F = find"
	.text
	.globl	main
	.type	main, @function
main:
.LFB45:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %eax
	call	enableRawMode
	movl	$0, %eax
	call	initEditor
	cmpl	$1, -4(%rbp)
	jle	.L360
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	editorOpen
.L360:
	leaq	.LC68(%rip), %rdi
	movl	$0, %eax
	call	editorSetStatusMessage
.L361:
	movl	$0, %eax
	call	editorRefreshScreen
	movl	$0, %eax
	call	editorProcessKeypress
	jmp	.L361
	.cfi_endproc
.LFE45:
	.size	main, .-main
	.local	saved_hl.4724
	.comm	saved_hl.4724,8,8
	.local	saved_hl_line.4723
	.comm	saved_hl_line.4723,4,4
	.data
	.align 4
	.type	last_match.4721, @object
	.size	last_match.4721, 4
last_match.4721:
	.long	-1
	.align 4
	.type	direction.4722, @object
	.size	direction.4722, 4
direction.4722:
	.long	1
	.align 4
	.type	quit_times.4826, @object
	.size	quit_times.4826, 4
quit_times.4826:
	.long	3
	.ident	"GCC: (Arch Linux 9.3.0-1) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
