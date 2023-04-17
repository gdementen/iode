
<IODE: python module>
IODE: python module
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
..sep |
..esc ~
..ignore ¯

&TI Memory management 
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 
&IT Interface IODE - Python - IODE

During a PYIODE session, IODE data are grouped in workspaces, one by object type (variables, scalars, equations...) 
and stored in memory using a proprietary memory management system (IODE-SWAP).

IODE functions operate ~binside~B IODE-SWAP memory. 
Exchanges between IODE objects (in IODE-SWAP) and python objects (larray, numpy or pandas objects in python memory) 
are made possible via interface functions.

&IT Source files (*.pyx, *.pxi and *.c)

The python functions are split according to their specific topics in the files ~cpyiode_*.pyx~C
where * can be ws, sample, objects, larray, reports...
Some utility functions have also been added in the pyiode_util.pyx module.

The called C-api function signatures are found in iode.pxi.
These functions are declared in iode.h (mostly in the sub file ~ciodeapi.h~C) 
and defined (for the most part) in ~cb_api.c~C.


&TI How to add a new Py-function based on a C-function
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
&IT Step 1: in C
¯¯¯¯¯¯¯¯¯¯
Create the new function in one of the iodeapi C modules, for example in ~capi/b_api.c~C:
&CO    
         int IodeMyFn(char* name) 
&TX
Declare the new function in ~capi/iodeapi.h~C

For Visual Studio (CMake) version:
&EN regenerate ~ciodeapi.lib~C (using CMake)

For non Visual Studio version (standard Microsoft ~cnmake~C / cl compiler):
&EN Goto ~c../api/vc64~C
&EN Execute ~cset64.bat~C to create the environment variables for VC64 nmake
&EN Execute ~cnmake~C to create 64 bits ~ciodeapi.lib~C
&CO
    c:.../api/vc64>> nmake
&TX

&IT Step 2: In {P|C}ython
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Add the new function declaration in iode.pxi in the section ~ccdef extern from "iode.h"~C:
&CO
    cdef int IodeMyFn(char* name)  
&TX
(Note that there is no semi-colon at the end of the line !)

Create the Python equivalent to IodeMyFn() in the appropriate module pyiode_*.pyx.
&CO
    def myfn(arg):
        return IodeMyFn(cstr(arg))
&TX

If needed, use the python utility functions:
&EN ~ccstr()~C to translate python strings (utf8) to C char* (ansi code cp850)
&EN ~cpystr()~C to do the reverse
&EN ~cpylist(char** c_list)~C to convert C char** to python lists 
   (don't forget to free c_list afterwards, e.g. by a call to SCR_free_tbl(c_list))
&EN ~cpyfloats(double *cvar, int lg)~C to convert a vector of doubles of length lg 
   into a python list of doubles

&IT Step 3: in a DOS shell
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
&CO
    c:\>> cd  <<path_to_iode>>/pyiode
    c:<<path_to_iode>>/pyiode>> set64
    c:<<path_to_iode>>/pyiode>> activate 
    c:<<path_to_iode>>/pyiode>> makepy
&TX

>