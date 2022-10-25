
`ifndef __FOUR_BIT_COMPARATOR_DEFINES_SVH__
`define __FOUR_BIT_COMPARATOR_DEFINES_SVH__

`ifndef FBC_X_WIDTH
    `define FBC_X_WIDTH 4
`endif /* FBC_X_WIDTH */

`ifndef FBC_Y_WIDTH
    `define FBC_Y_WIDTH 4
`endif /* FBC_Y_WIDTH */

`ifndef FBC_C_WIDTH
    `define FBC_C_WIDTH 3
    `define FBC_C_EQ    0
    `define FBC_C_GT    1
    `define FBC_C_LT    2
`endif /* FBC_C_WIDTH*/

`endif /* __FOUR_BIT_COMPARATOR_DEFINES_SVH__ */
