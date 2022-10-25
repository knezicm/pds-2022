
`ifndef __FOUR_BIT_FULL_ADDER_VIF_WRAPPER_SVH__
`define __FOUR_BIT_FULL_ADDER_VIF_WRAPPER_SVH__

class four_bit_full_adder_vif_wrapper extends virtual_interface_base;

    virtual interface gpio_interface #(`FBDA_X_WIDTH) x_vif;
    virtual interface gpio_interface #(`FBDA_Y_WIDTH) y_vif;
    virtual interface gpio_interface #(`FBDA_RES_WIDTH) res_vif;
    virtual interface gpio_interface #(`FBDA_C_WIDTH) c_vif;

    function new(string _name = "four_bit_full_adder_vif_wrapper");
        super.new(_name);
    endfunction : new

endclass : four_bit_full_adder_vif_wrapper

`endif /* __FOUR_BIT_FULL_ADDER_VIF_WRAPPER_SVH__ */
