; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = INTRC_CLKOUT   ; Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = ON             ; Watchdog Timer Enable bit (WDT enabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
;agregada libreria de compilador
  
// section waed for main code
psect   MainCode,global,class=CODE,delta=2 ; PIC10/12/16
; psect   barfunc,local,class=CODE,reloc=2 ; PIC18

 MAIN: ;Marca el punto de incio del programa principal.
    ;serie de instrucciones BAMKISEL que se utilizan para seleccionar
    ;configuracionde puertos como salida y entrada
    BANKSEL TRISB ;seleciono el banco del puerto B
    BCF TRISB,0 ;configuro el puerto
    BANKSEL PORTB ;enviar la configuracion de registro para el puerto
    
    BANKSEL TRISA
    BCF TRISA,0
    BANKSEL PORTA
    
    BANKSEL TRISC
    BSF TRISC,0
    BANKSEL PORTC
    
    BANKSEL TRISC
    BSF TRISC,1
    BANKSEL PORTC
    
CicloPrincipal:  ;incio de ciclo iyterativo principal
    ;Asegurar que el pin se encuentre lleno antes de apagarlo
    BTFSS               PORTC,0 ;revisar el pin 0 de puerto C
    BCF                 PORTA,0 ;Si el pin 0 del puerto B es 1, entonces salir
                                ;Si el pin 0 del puerto B es 0,entonce entrar
    ;Apagar, espera y encender LED;
    BCF                 PORTB,0 ;Colocar a 0 el pin 0 del puerto b (Apagar Led)
        CALL            ESPERA   ;Llamar o ejecutar la subrutina ESPERA
    BSF                 PORTB,0 ;Colocar a uno 1 el pin 0 del puerto B (Encender Led)
        CALL            ESPERA   ;Invoco la esfera nuevamente 
    ;Revisar si el boton 1 esta presionado
    	
    BTFSC PORTC,0 ;revisar el pin 0 del puerto C
    BSF   PORTA,0 ;Si el pin es 0 logico, no entrar a instrucion BSF
                  ;Di el pin es 1 logico, entrar a instruccion BSF
    ;Revisar si el boton 2 esta oresionado		  
    BTFSC PORTC,1 ;revisar el pin 0 del puerto C
    BSF   PORTA,1 ;Si el pin es 1 es 0 logico, no entrar a instrucion BSF
                  ;Di el pin 1 es 1 logico, entrar a instruccion BSF
		  
    GOTO            CicloPrincipal 
    
ESPERA:
    movlw 1000 ;mover literal a el registro de trabajo
    movwf 0x10 ;mover el registro de trabajo a la direccion del argumento
    movwf 0x11 ;mover el registo de trabajo a la direccion del argumento 
    
CICLO_ESPERA:
    decfsz 0x10, F
    goto CICLO_ESPERA
    decfsz 0x11, F
    goto CICLO_ESPERA
    retlw 0
    
    
  END    MAIN ;finaliza la ejecucion del programa