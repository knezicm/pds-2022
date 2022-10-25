
`ifndef DUT_WRAPPER
    $fatal("Design Under Test Wrapper is not specified!!!");
`endif 

module top #()();

    timeunit 1ns;
    timeprecision 1ns;

    import test_pkg::*;

    `DUT_WRAPPER dut();

    initial begin
        test_pkg::vif_base_h = dut.vif_h;
        test_pkg::run_test();
        test_pkg::end_of_test();
    end

endmodule : top
