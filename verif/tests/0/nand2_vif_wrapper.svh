
`ifndef __NAND2_VIF_WRAPPER_SVH__
`define __NAND2_VIF_WRAPPER_SVH__

class nand2_vif_wrapper extends virtual_interface_base;

    virtual interface gpio_interface #(`NAND2_IN_WIDTH) in_vif;
    virtual interface gpio_interface #(`NAND2_OUT_WIDTH) out_vif;

    function new(string _name = "nand2_vif_wrapper");
        super.new(_name);
    endfunction : new

endclass : nand2_vif_wrapper

`endif /* __NAND2_VIF_WRAPPER_SVH__ */
