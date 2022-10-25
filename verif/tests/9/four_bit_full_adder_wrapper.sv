
`include "../tests/9/four_bit_full_adder_defines.svh"

module four_bit_full_adder_wrapper ();

    import test_pkg::*;
    
    four_bit_full_adder_vif_wrapper vif_h;
    
    /* X */
    gpio_interface #(
            .GPIO_WIDTH(`FBDA_X_WIDTH)
        ) x_if();
    /* Y */
    gpio_interface #(
            .GPIO_WIDTH(`FBDA_Y_WIDTH)
        ) y_if();
    /* D */
    gpio_interface #(
             .GPIO_WIDTH(`FBDA_RES_WIDTH)
        ) res_if();
    /* B */
    gpio_interface #(
            .GPIO_WIDTH(`FBDA_C_WIDTH)
        ) c_if();
   
    /***************************************************************************/
    /** 
     * Design Under Test (DUT) instantiation
     */
    four_bit_full_adder four_bit_full_adder_inst (
        .a     (x_if.gpio             ),
	    .b     (y_if.gpio             ),
	    .cin   (c_if.gpio[`FBDA_C_IN] ),
	    .sum   (res_if.gpio           ),
	    .cout  (c_if.gpio[`FBDA_C_OUT])
    );
    /***************************************************************************/
    
    initial begin
        vif_h = new("four_bit_full_adder_vif_wrapper_vif");
        
        vif_h.x_vif = x_if;
        vif_h.y_vif = y_if;
        vif_h.res_vif = res_if;
        vif_h.c_vif = c_if;
    end

endmodule : four_bit_full_adder_wrapper

