
`ifndef __FOUR_BIT_COMPARATOR_TEST_GENERIC_SVH__
`define __FOUR_BIT_COMPARATOR_TEST_GENERIC_SVH__

class four_bit_comparator_test_generic extends test_base;

    four_bit_comparator_vif_wrapper vif_h;
    
    function new(string _id = "four_bit_comparator_test_generic", 
                virtual_interface_base _vif
                );
      super.new(_id);
      $cast(vif_h, _vif);
    endfunction : new

    extern task drive(bit [`FBC_X_WIDTH - 1 : 0] _x, 
                        bit [`FBC_Y_WIDTH - 1 : 0] _y
                        );

    extern virtual task vif_init();
    extern virtual task run_phase();
    
endclass : four_bit_comparator_test_generic

task four_bit_comparator_test_generic::vif_init();
    this.vif_h.x_vif.gpio <= 0;
    this.vif_h.y_vif.gpio <= 0;
    #0;
endtask : vif_init

task four_bit_comparator_test_generic::drive(bit [`FBC_X_WIDTH - 1 : 0] _x, 
                                                bit [`FBC_Y_WIDTH - 1 : 0] _y
                                                );
    this.vif_h.x_vif.gpio <= _x;
    this.vif_h.y_vif.gpio <= _y;
    #0;
endtask : drive

/*******************************************************************************************/
task four_bit_comparator_test_generic::run_phase();
    bit [`FBC_X_WIDTH - 1 : 0] x;
    bit [`FBC_Y_WIDTH - 1 : 0] y;
    bit [`FBC_C_WIDTH - 1 : 0] result;
   
    super.run_phase();
   
    this.info($sformatf("Starting test: %s", this.id), 1);
    this.vif_init();
    #100ns;
    for (int k = 0; k < 2; k++) begin
        #100ns;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                this.drive(i, j);
                #5ns;
                result = 0;
                if (i > j) begin
                    result[`FBC_C_GT] = 1;
                end else if (i < j) begin
                    result[`FBC_C_LT] = 1;
                end else begin
                    result[`FBC_C_EQ] = 1;
                end
                
                this.info($sformatf("X = %1h, Y = %1h, XEQY: %b, XGTY: %b, XLTY: %b",
                        i, j, 
                        this.vif_h.c_vif.gpio[`FBC_C_EQ],
                        this.vif_h.c_vif.gpio[`FBC_C_GT],
                        this.vif_h.c_vif.gpio[`FBC_C_LT]) ,1);
                this.check_data($sformatf("X(%1h) - Y(%1h)", i, j), 
                                result, 
                                this.vif_h.c_vif.gpio, 1);
                #100ns;
            end 
        end
    end
    #100ns;
    this.info($sformatf("Ending test: %s", this.id), 1);

endtask : run_phase
/*******************************************************************************************/

`endif /* __FOUR_BIT_COMPARATOR_TEST_GENERIC_SVH__ */

