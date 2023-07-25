# local-data-finder
## A system-wide data finder for Windows

I wanted to make a simple script that uses Windows built in tools only. 

No additional tools, no Powershell policy bypass, no complex options... just the major features I use on a daily basis.

```
               .andAHHAbnn.               local-data-finder
            .aAHHHAAUUAAHHHAn.            A system-wide data finder for Windows
           dHP-~*        *~-THb.          
     .   .AHF                YHA.   .     Look for a pattern in various places in your system
     I  .AHHb.              .dHHA.  I     
     I  HHAUAAHAbn      adAHAAUAHA  I     Usage:
     I  HF~L_____        ____ IHHH  I         swdffw.bat [PATTERN] [/D] [/F] [/K] [/V] [/C] [/P] [/S] [/A] [/I]
    HHI HAPK**~AYUHb  dAHHHHHHHHHH IHH    
    HHI HHHD~ .andHH  HHUUPA~YHHHH IHH    /D match file names in the whole disk
    YUI LHHP     *~Y  P~*     THHI IUP    /F match file name in the current working directory (recursive)
     V  'HK                   LHH'  V     /K match registry keys
         THAn.  .d.aAAn.b.  .dHHP         /V match registry values (slow search)
         LHHHHAAUP* ~~ *YUAAHHHHI         /C match netstat connections
         'HHPA~*  .annn.  *~AYHH'         /P match processes
          YHb    ~* ** *~    dHF          /S match services
           *YAb..abdHHbndbndAP*           /A match autoruns values (needs autorunsc64.exe from Syinternal Autoruns)
            THHAAb.  .adAHHF              /I match installed programs
             *UHHHHHHHHHHU*               
               LHHUUHHHHHHI               You can use the wildcard character '*' to match 'any string'.
             .adHHb *HHHHHbn.             
      ..andAAHHHHHHb.AHHHHHHHAAbnn..      Sample usage:
 .ndAAHHHHHHUUHHHHHHHHHHUP-~*~-YUHHHAAbn.     ldf.bat *foo*bar* /D
```

Use it to search for remnants of uninstalled software:
![screen1.png](screen1.png)

Use it to search IOC on your system:
![screen2.png](screen2.png)
