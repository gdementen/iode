#  IODE EXTENSION FOR PYTHON
#  =========================
# 
#     @header4iode
#  
#  IODE identity execution
#  -----------------------
# 
#   idt_execute(sample: Optional[Union[str, List[str]]] = None, idt_list: Optional[Union[str, List[str]]] = None, var_files: Optional[Union[str, List[str]]] = None, scl_files: Optional[Union[str, List[str]]] = None,trace: int = 0) | Execute a list of identities on a given sample

def idt_execute(sample: Optional[Union[str, List[str]]] = None, 
                idt_list: Optional[Union[str, List[str]]] = None, 
                var_files: Optional[Union[str, List[str]]] = None, 
                scl_files: Optional[Union[str, List[str]]] = None,
                trace: bool = False):
    r'''
    Execute a list of identities
    
    Parameters
    ----------
    sample: Optional[Union[str, List[str]]] = None
            range of period on which the identities must be calculated
            if sample is None or empty, the WS sample is used 
            
    idt_list: Optional[Union[str, List[str]]] = None
            list of identities to execute
            if empty, all identities are executed
            
    var_files: Optional[Union[str, List[str]]] = None
            list of files the needed variables must be read from. "WS" means current current Variable WS.
            if empty, only the current KV_WS is used
            
    scl_files: Optional[Union[str, List[str]]] = None
            list of files the needed scalars must be read from. "WS" means current current WS.
            if empty, only the current workspace is used
                        
    trace: int = 0
            optional trace indicating the source of the variables and scalars. For example:
            
            Execution of identities
            
            Parameters
                Execution sample : 1960Y1:2015Y1
            
                Variables loaded
                    From WS : AOUC AOUC_ COTRES DEBT DTF DTH EFMY EFXY EX FLG FLGR GAP2 GAP_ GOSF HF  
                    
                Scalars loaded
                    From ../data/fun : gamma gamma2 gamma3 gamma4 knf3
            
    Examples
    --------
        # define the "trace" file
        iode.w_dest("test_iode.htm", iode.W_HTML)
    
        # Simple case: no vars in WS, sample given
        iode.ws_clear_var()
        iode.ws_sample_set("1960Y1", "2015Y1")
        iode.ws_load_idt(f"{IODE_DATA_DIR}fun")
        iode.idt_execute("1961Y1:2000Y1", "AOUC", f"{IODE_DATA_DIR}fun", trace = 1)
        AOUC = iode.get_var("AOUC")
        test_eq('iode.idt_execute("1961Y1:2000Y1", "AOUC", f"{IODE_DATA_DIR}fun, trace = 1") -> AOUC[1961Y1]', 0.24783192, AOUC[1])
    
        # Load WS + change value before execution to check the result
        iode.ws_load_var(f"{IODE_DATA_DIR}fun")
        AOUC = iode.get_var("AOUC")
        AOUC[1] = 0.1 
        iode.set_var("AOUC", AOUC) # var changed in IODE WS
        iode.idt_execute("1961Y1:2015Y1", "AOUC")
        AOUC = iode.get_var("AOUC")
        test_eq('2. iode.idt_execute("1961Y1:2015Y1", "AOUC") -> AOUC[1961Y1]', 0.24783192, AOUC[1])
    
        # Shortest way using get_var_as_ndarray(..., False) => no iode.set_var() needed
        iode.ws_load_var(f"{IODE_DATA_DIR}fun")
        AOUC = iode.get_var_as_ndarray("AOUC", False)
        AOUC[1] = 0.1
        iode.idt_execute("1961Y1:2015Y1", "AOUC")
        test_eq('3. iode.idt_execute("1961Y1:2015Y1", "AOUC") -> AOUC[1961Y1]', 0.24783192, AOUC[1])
    
        # Alternative ways to call idt_execute
        AOUC = iode.get_var_as_ndarray("AOUC", False)
        AOUC[1] = 0.1
        iode.idt_execute(["1961Y1", "2015Y1"], ["AOUC", "FLGR"])
        test_eq('4. iode.idt_execute(["1961Y1", "2015Y1"], ["AOUC", "FLGR"]) -> AOUC[1961Y1]', 0.24783192, AOUC[1])
    
        # Call with empty parameters 
        iode.ws_load_scl(f"{IODE_DATA_DIR}fun")
        iode.delete_idt("SSFFX") # SSFFX contains non existent variables
        AOUC = iode.get_var_as_ndarray("AOUC", False)
        print(f"AOUC[1]={AOUC[1]}")
        AOUC[1] = 0.1
        iode.idt_execute() # all idts on full sample using current loaded WS
        AOUC = iode.get_var_as_ndarray("AOUC", False)
        test_eq(' 5. iode.idt_execute() -> AOUC[1961Y1]', 0.24677525, AOUC[1])
    
        iode.w_close()
    
    '''

    
    # Transforms Lists into strs
    sample = arg_to_str(sample)
    idt_list = arg_to_str(idt_list, ";")
    var_files = arg_to_str(var_files, ";")
    scl_files = arg_to_str(scl_files, ";")

    clear_error_msgs() # clear messages before executing the function
    rc = IodeExecuteIdts(cstr(sample), cstr(idt_list), cstr(var_files), cstr(scl_files), trace) 
    if rc < 0:
        display_error_msgs() 
        raise RuntimeError(f"idt_execute() failed.")
