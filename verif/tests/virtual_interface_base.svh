
`ifndef __VIRTUAL_INTERFACE_BASE_SVH__
`define __VIRTUAL_INTERFACE_BASE_SVH__

class virtual_interface_base;

    string name; 
    
    function new(string _name = "virtual_interface_base");
        this.name = _name;
    endfunction : new

endclass : virtual_interface_base

`endif /* __VIRTUAL_INTERFACE_BASE_SVH__ */
