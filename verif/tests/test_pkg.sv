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
    
    /** 
     * Issue 0
     *  NAND2
     */
    `include "./0/nand2_defines.svh"
    `include "./0/nand2_vif_wrapper.svh"
    `include "./0/nand2_test_generic.svh" 
    
    /**
     * Issue(s) 9, 10 & 11
     *  Full Adder test(s)
     */
    `include "./9/four_bit_full_adder_defines.svh"
    `include "./9/four_bit_full_adder_vif_wrapper.svh"
    `include "./9/four_bit_full_adder_test_generic.svh"
    /** 
     * Issue(s) 12, 13 & 14 
     *  Full Subtractor test(s) 
     */
    `include "./12/four_bit_full_subtractor_defines.svh"
    `include "./12/four_bit_full_subtractor_vif_wrapper.svh"
    `include "./12/four_bit_full_subtractor_test_generic.svh"
    /**
     * Issue 15
     *  Comparator
     */
    `include "./15/four_bit_comparator_defines.svh"
    `include "./15/four_bit_comparator_vif_wrapper.svh"
    `include "./15/four_bit_comparator_test_generic.svh"

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
        end else if ("nand2_test_generic" == test_name) begin
            test_h = nand2_test_generic::new(test_name, vif_base_h);
        end else if ("four_bit_full_subtractor_test_generic" == test_name) begin
            test_h = four_bit_full_subtractor_test_generic::new(test_name, vif_base_h);
        end else if ("four_bit_full_adder_test_generic" == test_name) begin
            test_h = four_bit_full_adder_test_generic::new(test_name, vif_base_h);
        end else if ("four_bit_comparator_test_generic" == test_name) begin
            test_h = four_bit_comparator_test_generic::new(test_name, vif_base_h);
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

