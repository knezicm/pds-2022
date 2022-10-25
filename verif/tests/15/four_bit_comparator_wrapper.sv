
`include "../tests/15/four_bit_comparator_defines.svh"

module four_bit_comparator_wrapper ();

    import test_pkg::*;
    
    four_bit_comparator_vif_wrapper vif_h;
    
    /* X */
    gpio_interface #(
            .GPIO_WIDTH(`FBC_X_WIDTH)
        ) fbc_x_if();
    /* Y */
    gpio_interface #(
            .GPIO_WIDTH(`FBC_Y_WIDTH)
        ) fbc_y_if();
    
    /* C */
    gpio_interface #(
            .GPIO_WIDTH(`FBC_C_WIDTH)
        ) fbc_c_if();
   
    /***************************************************************************/
    /** 
     * Design Under Test (DUT) instantiation
     */
    four_bit_comparator four_bit_comparator_inst (
        .a_i     (fbc_x_if.gpio           ),
	    .b_i     (fbc_y_if.gpio           ),
	    .aeqb_o  (fbc_c_if.gpio[`FBC_C_EQ]),
	    .agtb_o  (fbc_c_if.gpio[`FBC_C_GT]),
	    .altb_o  (fbc_c_if.gpio[`FBC_C_LT])
    );
    /***************************************************************************/
    
    initial begin
        vif_h = new("four_bit_comparator_vif_wrapper_vif");
        
        vif_h.x_vif = fbc_x_if;
        vif_h.y_vif = fbc_y_if;
        vif_h.c_vif = fbc_c_if;
    end

endmodule : four_bit_comparator_wrapper

