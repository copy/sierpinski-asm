%define size 128

	org 100h

	; go to video mode 13
	mov ax, 13h
	int 10h

	mov ax, 0A000h
	mov ds, ax

	; current x
	mov ax, size

outer_loop:

	dec ax
	; current y
	mov dx, size
	
inner_loop:

	dec dx

	; background color
	mov cl, 0

	test ax, dx
	jnz draw

	; foreground color
	mov cl, 15
	
draw:

	; calculate transformed x	
	; x = x - y/2
	mov di, ax

	mov si, dx
	shr si, 1
	add di, si

	; calculate transformed y
	; y = size - y
	mov bx, size
	sub bx, dx

	; x, y is at byte A0000h + x + 320 * y
	imul bx, 320

	mov [bx + di], cl

	or dx, dx
	jnz inner_loop

	or ax, ax
	jnz outer_loop

	; done
	; wait for keystroke
	mov ah, 0
	int 16h

	; back to video mode 3
	mov ax, 3h
	int 10h

	ret

