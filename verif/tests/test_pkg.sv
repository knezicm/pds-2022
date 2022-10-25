`ifndef __TEST_PKG_SV__
`define __TEST_PKG_SV__

package test_pkg;
    /** 
     * Typedefs
     */
    
    /** 
     * Include(s) (tests):
     */
    /** - Base test */
    `include "virtual_interface_base.svh"
    `include "test_base.svh"
    

    virtual_interface_base vif_base_h;
    test_base test_h;

    task run_test(string _test_name = "");
        string test_name;
     
        if ("" == _test_name) begin
            if (!$value$plusargs ("TESTNAME=%s", test_name)) begin
                $display("[FATAL]: TESTNAME argument is not provided!!!");
                $fatal;
            end;
        end else begin
            test_name = _test_name;
        end;
        $display("TESTNAME = %s", test_name);

        
        if ("test_base" == test_name) begin
            test_h = new(test_name);
        end else begin
            $display("[FATAL]: Test name does not exist!!!");
            $fatal;
        end
        
        test_h.run_test();
        
    endtask : run_test;


    task end_of_test();
        wait (1 == test_h.end_of_test);
        $finish;
    endtask : end_of_test

endpackage : test_pkg

`endif /* __TEST_PKG_SV__ */

