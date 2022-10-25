
`ifndef __GPIO_INTERFACE_SV__
`define __GPIO_INTERFACE_SV__

interface gpio_interface #(
    int GPIO_WIDTH = 8
);

   logic [GPIO_WIDTH - 1 : 0] gpio;
   
endinterface : gpio_interface

`endif /* __GPIO_INTERFACE_SV__ */

