<!-- This content was generated by scr4w_amd -->

# Table of Contents



- [IODE: source organisation](#T1)
  - [32 bits IODE version](#T2)
      - [Borland (currently Embarcadero) 32 bits](#T3)
      - [Iode for python (MSVC 64 bits)](#T4)
  - [64 bits IODE version](#T5)
      - [MSVC 64 bits.](#T6)

# IODE: source organisation {#T1}

Two versions:

- 32 bits IODE version
- 64 bits IODE version

## 32 bits IODE version {#T2}

#### Borland (currently Embarcadero) 32 bits {#T3}

*Location*: c:/usr/iode\_src

*Versionalisation tool*: SVN

*SVN server*: svn.plan.be/iode

|Directory|Target|Contents|
|:---|:---|:---|
|`./api`|iodeapi.lib (32 bits)|api sources|
|`./tests/test_c_api`|test1\[cpp\].exe|test1 sources \+ makefile|
|`./tests/data`||data for test1.exe and test1cpp.exe|
|`./tests/output`||results of test1.exe and test1cpp.exe|
|`./cmd`|iodecmd.exe|iodecmd sources|
|`./dos`|iode.exe|GUI DOS sources|
|`./iodecom`|iodecom.exe|sources and make64.bat to generate iodecom.exe|
|`./man`|iode.chm, iode.plan.be, readme.htm, iode.pdf|makechm.bat, makewiki.bat, makereadme.bat, makemif.bat, makedev.bat, makeall.bat|
|`./man/src`||manual sources (.m, .m1, .png, .jpg, .gif...)|
|`./man/src/dev`|DESCRIPTION.md, LEC.md, etc|developper's manual sources (\*.m)|
|`./man/bin`|manuals|scr4 executables to compile manual pages|
|`./fun`||example model|
|`./nsis_installer`|iode\{vers\}.exe, iodeupd\{vers\}.exe|sources (\*.nsi) \+ remakeiode.bat to regenerate the whole project|
|**External sources**|||
|`../scr4_src`|scr4iode.lib, s32wo.lib|scr4 sources files \+ makefile|

#### Iode for python (MSVC 64 bits) {#T4}

Location: `c:/usr/iode_src`

|Directory|Target|Contents|
|:---|:---|:---|
|`./pyiode`|py\{vers\}/iode.pyd|makepy.bat, cythonize\_iode.py, test\_iode.py, .pyx and .pxi sources|
|`./api/vc64`|iodeapi.lib (64 bits MSVC)|64 bits objects \+ VC makefile|
|`scr4_src/vc64`|s4iode.lib (64 bits MSVC)|64 bits objects \+ VC makefile|

## 64 bits IODE version {#T5}

#### MSVC 64 bits. {#T6}

Location: `%USERPROFILE%\source\repos\iode`

Versionalisation tool: `git`

GitHub repository: `https://github.com/plan-be/iode`

|Directory|Target|Contents|
|:---|:---|:---|
|`./api`|iodeapi.lib (64 bits MSVC)|api sources|
|`./tests/test_c_api`|test1\[cpp\].exe, test\_c\_api.exe|test1 sources, convert\_tests.bat, borland\_to\_google\_test.py|
|`./tests/data`||data for test1.exe and test1cpp.exe|
|`./tests/output`||results of test1.exe and test1cpp.exe|
|`./cpp_api`|iodecppapi.lib (64 bits MSVC)|api sources|
|`./cmd`|iodecmd.exe|iodecmd sources|
|`./pyiode`|py\{vers\}/iode.pyd|\*.pxi, \*.pyx \+ makepy.bat \+ cythonize\_iode.py \+ test\_iode.py|
|`./gui`|iode\_gui.exe|Qt sources|
|`./scr4`|scr4iode.lib|scr4 sources files for iode|
|`./man`|iode.chm, iode.plan.be, readme.htm, iode.pdf|makechm.bat, makewiki.bat, makereadme.bat, makemif.bat, makedev.bat, makeall.bat|
|`./man/src`||manual sources (.m, .m1, .png, .jpg, .gif...)|
|`./man/src/dev`|DESCRIPTION.md, LEC.md, etc|developper's manual sources (\*.m)|
|`./man/bin`|manuals|scr4 executables to compile manual pages|
