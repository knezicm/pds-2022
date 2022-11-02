
`include "../tests/0/nand2_defines.svh"

module nand2_wrapper ();

    import test_pkg::*;
    
    nand2_vif_wrapper vif_h;
    
    /* IN */
    gpio_interface #(
            .GPIO_WIDTH(`NAND2_IN_WIDTH)
        ) in_if();
    /* OUT */
    gpio_interface #(
            .GPIO_WIDTH(`NAND2_OUT_WIDTH)
        ) out_if();
   
    /***************************************************************************/
    /** 
     * Design Under Test (DUT) instantiation
     */
    nand2 nand2_inst (
        .i_A(in_if.gpio[`NAND2_A]),
	    .i_B(in_if.gpio[`NAND2_B]),
	    .o_Y(out_if.gpio[`NAND2_Y])
    );
    /***************************************************************************/
    
    initial begin
        vif_h = new("nand2_vif_wrapper_vif");
        
        vif_h.in_vif = in_if;
        vif_h.out_vif = out_if;
    end

endmodule : nand2_wrapper

