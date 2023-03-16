
<IODE: Printing>
..sep |
..esc ~
..ignore ¯

IODE: Printing
¯¯¯¯¯¯¯¯¯¯¯¯¯¯
&TI Introduction
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
All outputs generated by IODE are based on the A2M engine of SCR4. 
The only role of IODE is to generate A2M code to describes tables, graphs, equations, etc, in A2M language. 
When this A2M code is complete, the final output is generated by the A2M engine of SCR4 for the selected destination.

&TI Available output destinations
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

The currently available output formats are:

&EN W_A2M = A2M file 
&EN W_MIF = mif  file (Adobe FrameMaker ascii format)
&EN W_HTML = html  file
&EN W_RTF = rtf  file
&EN W_CSV = csv file
&EN W_GDI = Windows printer
&EN W_DUMMY = no output

Some outputs have limitations:

&EN rtf files do not include graphs (an EMF/WMF version exists but is currenlty disabled. See SCR4)
&EN csv files do not includes graphs 
&EN html files use a commercial javascript library (Fusion Chart). A link to that lib is therefore required.

The special output destination "W_DISP" is only used for graphs displayed on screen. It uses the TeeChart C++ library (Embarcadero).


&TI Usage
¯¯¯¯¯¯¯¯
1. initialise the output for a specific destination: 
&CO
        - W_dest(filename, type) 
&TX
2. send commands and text in A2m language
&CO
        - W_print_tit(level);
        - W_printf(fmt, parms);
        - ...
        - W_flush() // Optional. Use when an object is complete (in memory)
&TX

3. close the file or send to the printer
&CO
        - W_close()
&TX
4. optionaly goto step 1 to create a new file / printout  
    
&TI Example
¯¯¯¯¯¯¯¯¯¯
&CO
    W_dest("", W_GDI);              // Prepares to send output to the default printer (W_GDI)
    W_print_tit(1);                 // Sends the tag for a level 1 title
    W_printf("Title 1\n\n");        // text of the title
    ...
    W_close();                      // Flushes the memory buffer and sends the output to the printer

    W_dest("test1.htm", W_HTML);    // Creates test.html in HTML format (W_HTML)
    W_printf(".par1 tit_1\n");      // Saves a2m code in memory
    W_printf("Title 1\n\n");        // id.
    ...
    W_close();                      // Flushes the memory buffer and saves the result in the file test1.htm
&TX

&TI More detailed example of A2M code including tables and graphs
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
&CO
W_printf(".sep |\n");                   // Defines the table separators
W_printf(".esc ~\n");                   // Defines the escape char 
    
W_printf(".pghead IODE\n");             // Page header
W_printf(".pgfoot - page %d - \n");     // Page footer including the page number (%d)
    
W_print_tit(1);                         // Tag for level 1 title    
W_printf("%s\n", "Mon titre");          // text of the title
    
W_printf(".tb\n");                      // Begins a new table
W_printf(".tborder 1\n");               // Set the table border width
W_printf(".theader\n");                 // Next lines are header (centered, bold)
W_printf("| Syntax | Description\n");   // Headers
W_printf(".tbody\n");                   // Next lines are body 
W_printf("| ~cint L_errno       | Last error number during LEC compilation\n");
W_printf("| ~cchar* L_error()   | Returns a static buffer containing the last LEC compilation error message.\n");
W_printf(".te\n");                      // End of table
 
W_printf(".gb 16.00 10.00\n");          // Begins a new graph of 16cm x 10cm    
W_printf(".ggrid TMM\n");               // 
W_printf(".galign L\n");
W_printf(".gbox 0 b 0\n");              
W_printf(".gtitle Equation ACAF : observed and fitted values\n");   // Graph title
W_printf(".gty L \"(ACAF/VAF[-1])  : observed\" 1980Y1  0.011412042  0.016028202  0.011903394  0.012051363  0.010215556  0.010582964  0.0090882893  0.009277778  0.0082268494  0.0051589358  0.0066405193  0.0068489061  0.0075258742  0.0082727193  0.0019340143  -0.0029850522  0.0069569681 \n");
W_printf(".gty L \"(ACAF/VAF[-1])  : fitted\" 1980Y1  0.012562124  0.012491075  0.012526504  0.011687035  0.011060337  0.010403968  0.0095320575  0.0090522427  0.008714914  0.0076539375  0.0065561227  0.006355248  0.0064942167  0.0062763884  0.0062678674  -0.0029850522  0.0044903364 \n");
W_printf(".ge\n");                      // End of graph

&TX

&TI List of source files
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
&EN <w_wrt.c>   : main functions
&EN <w_wrt1.c>  : shortcuts to A2M commands
>
<w_wrt.c>
w_wrt.c
¯¯¯¯¯¯¯
Contains the main "W_*" functions: select, close, print, display, printer management.

&IT List of functions
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
..tb
| Syntax                                                                | Description  
| ~cint W_dest(char *filename, int type)                                | Select a new printing destination in one of the available possible types
| ~cint W_close()                                                       | Ends a printing session by sending the objects in A2m memory to the printer or the output file.
| ~cint W_flush()                                                       | Sends the objects currently recorded in memory by A2mMemRecord() to the printer or the file.
| ~cint W_printfEx(int dup, int ch1, int ch2, char* fmt, va_list args)  | Records a text in A2m memory for printing after parsing the fmt argument.
| ~cint W_printf(char* fmt, ...)                                        | Records a text in A2m memory for printing.
| ~cint W_printfDbl(char* fmt, ...)                                     | Records a text in A2m memory for printing after parsing the fmt argument. Doubles the backslashes.
| ~cint W_printfRepl(char* fmt, ...)                                    | Records a text in A2m memory for printing after parsing the fmt argument. Replaces '&' by A2M_SEPCH.
| ~cint W_putc(int ch)                                                  | Records a single character in A2m memory by a call to W_printf().
| ~cint W_record(char *str)                                             | Records a text in A2m memory.
| ~cint W_InitDisplay()                                                 | Defines the new output type as W_DISP (displays or creates a TeeChart graph file).
| ~cint W_EndDisplay(char *title, int x, int y, int w, int h)           | Closes the current printing session by sending the graphs to the screen.
| ~cstatic int W_SavePrinterSettings()                                  | Saves the current default printer and some of its settings.
| ~cstatic int W_ResetPrinterSettings()                                 | Restores the default printer and some of its settings.
| ~cstatic int W_SetPrinterSettings()                                   | Sets the default printer (defined by global W_gdiprinter) and some of its settings.
..te

&IT List of global variables
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
..tb
| Syntax                                        | Description  
| ~cchar    W_filename[K_MAX_FILE + 1] = "";    |    Output file name
| ~cint     W_type = 0;                         |    Current A2M output destination:
| ~cint     W_gdiask = 0;                       |    Ask the user which printer to send the data to. If null, selects the default printer.
| ~cint     W_gdiorient = 0;                    |    Unused -- Printer page orientation: 0 = Portrait, 1 = Landscape
| ~cint     W_gdiduplex = 0;                    |    Unused -- Printer duplex:
|                                               |         0 for simplex
|                                               |         1 for duplex
|                                               |         2 for vertical duplex
| ~cchar    W_gdiprinter[80] = "";              |    Printer name
| ~cint     W_a2mapp = 0;                       |    A2M Dest only:
|                                               |         0 =>> output file is reset,
|                                               |         1 =>> output is appended to the file
| ~cint     W_rtfhelp = 0;                      |    RTF only: generate RTF output for the outdated Windows help format (.hlp).
| ~cint     W_htmlhelp = 0;                     |    RTF only: generate HTML output for the Windows HEML help format (.chm).
..te

>

<w_wrt1.c>
w_wrt1.c
¯¯¯¯¯¯¯¯
Contains some shortcuts to A2M commands in the context of IODE printing.

&IT List of functions
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
..tb
| Syntax                                 | Description  
| ~cvoid W_print_enum(int n)             | Starts an A2M enum paragraph (enum_*) of level n.
| ~cvoid W_print_cmd(int n)              | Sends commands to A2M to start a paragraph containing code 
| ~cvoid W_print_par(int n)              | Starts an A2M normal paragraph (par_*) of level n.
| ~cvoid W_print_tit(int n)              | Starts an A2M title paragraph (tit_*) of level n.
| ~cvoid W_print_pg_header(char* arg)    | Sends the A2M command to change the page header
| ~cvoid W_print_pg_footer(char* arg)    | Sends the A2M command to change the page footer
| ~cvoid W_print_rtf_topic(char* arg)    | Sends the A2M command to set the next help topic
| ~cvoid W_print_tb(char* title, int nc) | Starts a new table in A2M format
..te
>