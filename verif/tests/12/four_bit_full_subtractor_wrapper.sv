
`include "../tests/12/four_bit_full_subtractor_defines.svh"

module four_bit_full_subtractor_wrapper ();

    import test_pkg::*;
    
    four_bit_full_subtractor_vif_wrapper vif_h;
    
    /* X */
    gpio_interface #(
            .GPIO_WIDTH(`FBFS_X_WIDTH)
        ) x_if();
    /* Y */
    gpio_interface #(
            .GPIO_WIDTH(`FBFS_Y_WIDTH)
        ) y_if();
    /* D */
    gpio_interface #(
             .GPIO_WIDTH(`FBFS_D_WIDTH)
        ) d_if();
    /* B */
    gpio_interface #(
            .GPIO_WIDTH(`FBFS_B_WIDTH)
        ) b_if();
   
    /***************************************************************************/
    /** 
     * Design Under Test (DUT) instantiation
     */
    four_bit_full_subtractor four_bit_full_subtractor_inst (
        .X     (x_if.gpio             ),
	    .Y     (y_if.gpio             ),
	    .B_in  (b_if.gpio[`FBFS_B_IN] ),
	    .diff  (d_if.gpio             ),
	    .B_out (b_if.gpio[`FBFS_B_OUT])
    );
    /***************************************************************************/
    
    initial begin
        vif_h = new("four_bit_full_subtractor_vif_wrapper_vif");
        
        vif_h.x_vif = x_if;
        vif_h.y_vif = y_if;
        vif_h.d_vif = d_if;
        vif_h.b_vif = b_if;
    end

endmodule : four_bit_full_subtractor_wrapper

