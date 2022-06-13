# swdf
System-wide data finder for Windows

```
               .andAHHAbnn.               
            .aAHHHAAUUAAHHHAn.            
           dHP-~*        *~-THb.          
     .   .AHF                YHA.   .     System-wide data finder for Windows
     I  .AHHb.              .dHHA.  I     
     I  HHAUAAHAbn      adAHAAUAHA  I     Look for a pattern in various places in your system
     I  HF~L_____        ____ IHHH  I     
    HHI HAPK**~AYUHb  dAHHHHHHHHHH IHH    Usage:
    HHI HHHD~ .andHH  HHUUPA~YHHHH IHH        swdffw.bat [PATTERN] [/D] [/F] [/K] [/V] [/C] [/P]
    YUI LHHP     *~Y  P~*     THHI IUP    
     V  'HK                   LHH'  V     /D match file names in the whole disk
         THAn.  .d.aAAn.b.  .dHHP         /F match file name in the current working directory (recursive)
         LHHHHAAUP* ~~ *YUAAHHHHI         /K match registry keys
         'HHPA~*  .annn.  *~AYHH'         /V match registry values (slow search)
          YHb    ~* ** *~    dHF          /C match netstat connections
           *YAb..abdHHbndbndAP*           /P match processes
            THHAAb.  .adAHHF              
             *UHHHHHHHHHHU*               You can use the wildcard character '*' to match 'any string'.
               LHHUUHHHHHHI               
             .adHHb *HHHHHbn.             Sample usage:
      ..andAAHHHHHHb.AHHHHHHHAAbnn..          swdffw.bat *foo*bar* /D
 .ndAAHHHHHHUUHHHHHHHHHHUP-~*~-YUHHHAAbn. 
```

