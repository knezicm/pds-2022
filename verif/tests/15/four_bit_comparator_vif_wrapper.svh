
`ifndef __FOUR_BIT_COMPARATOR_VIF_WRAPPER_SVH__
`define __FOUR_BIT_COMPARATOR_VIF_WRAPPER_SVH__

class four_bit_comparator_vif_wrapper extends virtual_interface_base;

    virtual interface gpio_interface #(
                        .GPIO_WIDTH(`FBC_X_WIDTH)
                        ) x_vif;
    virtual interface gpio_interface #(
                        .GPIO_WIDTH(`FBC_Y_WIDTH)
                        ) y_vif;
    virtual interface gpio_interface #(
                        .GPIO_WIDTH(`FBC_C_WIDTH)
                        ) c_vif;

    function new(string _name = "four_bit_comparator_vif_wrapper");
        super.new(_name);
    endfunction : new

endclass : four_bit_comparator_vif_wrapper

`endif /* __FOUR_BIT_COMPARATOR_VIF_WRAPPER_SVH__ */
