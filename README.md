HDDspeed v0.002
---------------
HDDspeed is a drive speed testing utility for Windows, 
Linux and Mac OSX written by Danny Arends. It is written 
in the D language and estimates the maximum data transfer 
rates using write(), readln(), and readRaw() functions.

Some results on a Wind100 netbook indicate Linux being 
almost 2-3 times as fast as MS windows on reading and 
writing binary files.

The windows 32 and 64 bit version is available for download at:

https://www.dannyarends.nl/HDDspeed/HDDspeed_32.exe

https://www.dannyarends.nl/HDDspeed/HDDspeed_64.exe

Usage
-----
Compile the executable for this you will need the DMD 
compiler available at http://www.d-programming-language.org/

Compile by executing:

    $ dmd src/HDDspeed.d src/stats.d src/generate.d

After compilation just run the created executable 
HDDspeed, parameters of the executable are:

    $ HDDspeed [n.tests] [size]
    $  
    $  [n.tests]  Number of tests, larger = better
    $  [size]     Size of buffer, experimental
    
Examples
--------
    ST1 - Mobile ST980825AS (80GB) on HP Compaq NC6400
    ST2 - Mobile ST9160821AS (160GB) on Sony Vaio PCG-5J5M
    WD1 - Western Digital (WD1600JS) on Custom setup
    WD2 - Western Digital (WD5000AADS) on Custom setup
    WDM - Western Digital Mobile (WD1600BEVT) on MSI Wind100
    USB - Standard USB disk (2GB) on MSI Wind100
    SS1 - Samsung Spinpoint F1 on Custom setup
    NVM - Toshiba 256GB NVMe THNSN5256GPUK NV
    ST3 - Samsung Spinpoint M9T Hard Drive

    | ID  | FORM  | OS     | Write     | Read (TXT) | Read (BIN)|
    |-----------------------------------------------------------|
    | ST1 | NTFS  | WinXP2 |  697 mB/s | 2485 kB/s  |  690 mB/s |
    | ST2 | NTFS  | Vista  |  821 mB/s | 2790 kB/s  |  813 mB/s |
    | WD1 | NTFS  | 2008   | 1714 mB/s | 4916 kB/s  | 1697 mB/s |
    | WD2 | NTFS  | 2008   | 1798 mB/s | 4993 kB/s  | 1781 mB/s |
    | WDM | NTFS  | WinXP3 |  422 mB/s | 1141 kB/s  |  407 mB/s |
    | WDM | ext2  | Debian | 1162 mB/s | 1214 kB/s  |  920 mB/s |
    | USB | fat32 | WinXP3 |  393 mB/s | 1235 kB/s  |  390 mB/s |
    | USB | ext2  | Debian |  917 mB/s | 1103 kB/s  |  908 mB/s |
    | USB | ext4  | Debian | 1163 mB/s | 1196 kB/s  | 1151 mB/s |
    | SS1 | NTFS  | Win7   |  793 mB/s | 2424 kB/s  |  785 mB/s |
    | NVM | NTFS  | Win10  | 3076 mB/s | 45.7 mB/s  | 3046 mB/s |
    | ST3 | NTFS  | Win10  | 4826 mB/s | 59.6 mB/s  | 4778 mB/s |

Documentation 
-------------

See [https://www.dannyarends.nl/Project: HDDspeed](https://www.dannyarends.nl/Project:%20HDDspeed)

Disclaimer
----------
Copyright (c) 2012 [Danny Arends](http://www.dannyarends.nl)
