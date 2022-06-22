<!-- This content was generated by scr4w_amd -->

# Table of Contents



- [IODE: Printing](#T1)
    - [Introduction](#T2)
    - [Available output destinations](#T3)
    - [Usage](#T4)
    - [Example](#T5)
    - [More detailed example of A2M code including tables and graphs](#T6)
    - [List of source files](#T7)
  - [w\_wrt.c](#T8)
      - [List of functions](#T9)
      - [List of global variables](#T10)
  - [w\_wrt1.c](#T11)
      - [List of functions](#T12)

# IODE: Printing {#T1}

### Introduction {#T2}

All outputs generated by IODE are based on the A2M engine of SCR4. The only role of IODE is to generate A2M code to describes tables, graphs, equations, etc, in A2M language. When this A2M code is complete, the final output is generated by the A2M engine of SCR4 for the selected destination.

### Available output destinations {#T3}

The currently available output formats are:

- W\_A2M = A2M file
- W\_MIF = mif file (Adobe FrameMaker ascii format)
- W\_HTML = html file
- W\_RTF = rtf file
- W\_CSV = csv file
- W\_GDI = Windows printer
- W\_DUMMY = no output

Some outputs have limitations:

- rtf files do not include graphs (an EMF/WMF version exists but is currenlty disabled. See SCR4)
- csv files do not includes graphs
- html files use a commercial javascript library (Fusion Chart). A link to that lib is therefore required.

The special output destination "W\_DISP" is only used for graphs displayed on screen. It uses the TeeChart C\+\+ library (Embarcadero).

### Usage {#T4}

1. initialise the output for a specific destination:

```
        - W_dest(filename, type) 
```

2. send commands and text in A2m language

```
        - W_print_tit(level);
        - W_printf(fmt, parms);
        - ...
        - W_flush() // Optional. Use when an object is complete (in memory)
```

3. close the file or send to the printer

```
        - W_close()
```

4. optionaly goto step 1 to create a new file / printout

### Example {#T5}

```
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
```

### More detailed example of A2M code including tables and graphs {#T6}

```
W_printf(".sep |\n");                   // Defines the table separators
W_printf(".esc \n");                   // Defines the escape char 
    
W_printf(".pghead IODE\n");             // Page header
W_printf(".pgfoot - page %d - \n");     // Page footer including the page number (%d)
    
W_print_tit(1);                         // Tag for level 1 title    
W_printf("%s\n", "Mon titre");          // text of the title
    
W_printf(".tb\n");                      // Begins a new table
W_printf(".tborder 1\n");               // Set the table border width
W_printf(".theader\n");                 // Next lines are header (centered, bold)
W_printf("| Syntax | Description\n");   // Headers
W_printf(".tbody\n");                   // Next lines are body 
W_printf("| int L_errno       | Last error number during LEC compilation\n");
W_printf("| char* L_error()   | Returns a static buffer containing the last LEC compilation error message.\n");
W_printf(".te\n");                      // End of table
 
W_printf(".gb 16.00 10.00\n");          // Begins a new graph of 16cm x 10cm    
W_printf(".ggrid TMM\n");               // 
W_printf(".galign L\n");
W_printf(".gbox 0 b 0\n");              
W_printf(".gtitle Equation ACAF : observed and fitted values\n");   // Graph title
W_printf(".gty L \"(ACAF/VAF[-1])  : observed\" 1980Y1  0.011412042  0.016028202  0.011903394  0.012051363  0.010215556  0.010582964  0.0090882893  0.009277778  0.0082268494  0.0051589358  0.0066405193  0.0068489061  0.0075258742  0.0082727193  0.0019340143  -0.0029850522  0.0069569681 \n");
W_printf(".gty L \"(ACAF/VAF[-1])  : fitted\" 1980Y1  0.012562124  0.012491075  0.012526504  0.011687035  0.011060337  0.010403968  0.0095320575  0.0090522427  0.008714914  0.0076539375  0.0065561227  0.006355248  0.0064942167  0.0062763884  0.0062678674  -0.0029850522  0.0044903364 \n");
W_printf(".ge\n");                      // End of graph
 
```

### List of source files {#T7}

- w\_wrt.c : main functions
- w\_wrt1.c : shortcuts to A2M commands

## w\_wrt.c {#T8}

Contains the main "W\_\*" functions: select, close, print, display, printer management.

#### List of functions {#T9}

|Syntax|Description|
|:---|:---|
|`int W_dest(char *filename, int type)`|Select a new printing destination in one of the available possible types|
|`int W_close()`|Ends a printing session by sending the objects in A2m memory to the printer or the output file.|
|`int W_flush()`|Sends the objects currently recorded in memory by A2mMemRecord() to the printer or the file.|
|`int W_printfEx(int dup, char* fmt, va_list args)`|Records a text in A2m memory for printing after parsing the fmt argument.|
|`int W_printf(char* fmt, ...)`|Records a text in A2m memory for printing.|
|`int W_putc(int ch)`|Records a single character in A2m memory by a call to W\_printf().|
|`int W_record(char *str)`|Records a text in A2m memory.|
|`int W_InitDisplay()`|Defines the new output type as W\_DISP (displays or creates a TeeChart graph file).|
|`int W_EndDisplay(char *title, int x, int y, int w, int h)`|Closes the current printing session by sending the graphs to the screen.|
|`static int W_SavePrinterSettings()`|Saves the current default printer and some of its settings.|
|`static int W_ResetPrinterSettings()`|Restores the default printer and some of its settings.|
|`static int W_SetPrinterSettings()`|Sets the default printer (defined by global W\_gdiprinter) and some of its settings.|

#### List of global variables {#T10}

|Syntax|Description|
|:---|:---|
|`char W_filename[K_MAX_FILE + 1] = "";`|Output file name|
|`int W_type = 0;`|Current A2M output destination:|
|`int W_gdiask = 0;`|Ask the user which printer to send the data to. If null, selects the default printer.|
|`int W_gdiorient = 0;`|Unused \-\- Printer page orientation: 0 = Portrait, 1 = Landscape|
|`int W_gdiduplex = 0;`|Unused \-\- Printer duplex:|
|                                             |0 for simplex|
|                                             |1 for duplex|
|                                             |2 for vertical duplex|
|`char W_gdiprinter[80] = "";`|Printer name|
|`int W_a2mapp = 0;`|A2M Dest only:|
|                                             |0 => output file is reset,|
|                                             |1 => output is appended to the file|
|`int W_rtfhelp = 0;`|RTF only: generate RTF output for the outdated Windows help format (.hlp).|
|`int W_htmlhelp = 0;`|RTF only: generate HTML output for the Windows HEML help format (.chm).|

## w\_wrt1.c {#T11}

Contains some shortcuts to A2M commands in the context of IODE printing.

#### List of functions {#T12}

|Syntax|Description|
|:---|:---|
|`void W_print_enum(int n)`|Starts an A2M enum paragraph (enum\_\*) of level n.|
|`void W_print_cmd(int n)`|Sends commands to A2M to start a paragraph containing code|
|`void W_print_par(int n)`|Starts an A2M normal paragraph (par\_\*) of level n.|
|`void W_print_tit(int n)`|Starts an A2M title paragraph (tit\_\*) of level n.|
