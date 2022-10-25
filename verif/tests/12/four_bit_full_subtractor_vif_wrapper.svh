
`ifndef __FOUR_BIT_FULL_SUBTRACTOR_VIF_WRAPPER_SVH__
`define __FOUR_BIT_FULL_SUBTRACTOR_VIF_WRAPPER_SVH__

class four_bit_full_subtractor_vif_wrapper extends virtual_interface_base;

    virtual interface gpio_interface #(`FBFS_X_WIDTH) x_vif;
    virtual interface gpio_interface #(`FBFS_Y_WIDTH) y_vif;
    virtual interface gpio_interface #(`FBFS_D_WIDTH) d_vif;
    virtual interface gpio_interface #(`FBFS_B_WIDTH) b_vif;

    function new(string _name = "four_bit_full_subtractor_vif_wrapper");
        super.new(_name);
    endfunction : new

endclass : four_bit_full_subtractor_vif_wrapper

`endif /* __FOUR_BIT_FULL_SUBTRACTOR_VIF_WRAPPER_SVH__ */
