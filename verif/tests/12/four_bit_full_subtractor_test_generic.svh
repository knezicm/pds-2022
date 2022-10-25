
`ifndef __FOUR_BIT_FULL_SUBTRACTOR_TEST_GENERIC_SV__
`define __FOUR_BIT_FULL_SUBTRACTOR_TEST_GENERIC_SV__

class four_bit_full_subtractor_test_generic extends test_base;
    
    four_bit_full_subtractor_vif_wrapper vif_h;
    
    function new(string _id = "four_bit_full_subtractor_test_generic", 
                virtual_interface_base _vif
                );
      super.new(_id);
      $cast(vif_h, _vif);
    endfunction : new

    extern task drive(bit [`FBFS_X_WIDTH - 1 : 0] _x, 
                        bit [`FBFS_Y_WIDTH - 1 : 0] _y
                        );

    extern virtual task vif_init();
    extern virtual task run_phase();
   
endclass : four_bit_full_subtractor_test_generic

task four_bit_full_subtractor_test_generic::vif_init();
    this.vif_h.x_vif.gpio <= 0;
    this.vif_h.y_vif.gpio <= 0;
    this.vif_h.b_vif.gpio[0] <= 0;
    #0;
endtask : vif_init

task four_bit_full_subtractor_test_generic::drive(bit [`FBFS_X_WIDTH - 1 : 0] _x, 
                                                    bit [`FBFS_Y_WIDTH - 1 : 0] _y
                                                    );
    this.vif_h.x_vif.gpio <= _x;
    this.vif_h.y_vif.gpio <= _y;
    #0;
endtask : drive

/*******************************************************************************************/
task four_bit_full_subtractor_test_generic::run_phase();
    bit [`FBFS_X_WIDTH - 1 : 0] x;
    bit [`FBFS_Y_WIDTH - 1 : 0] y;
    bit [`FBFS_X_WIDTH : 0] result;
    bit b_in;
    bit b_out;
   
    super.run_phase();
   
    this.info($sformatf("Starting test: %s", this.id), 1);
    this.vif_init();
    #100ns;
    for (int k = 0; k < 2; k++) begin
        this.vif_h.b_vif.gpio[`FBFS_B_IN] <= k;
        #100ns;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                this.drive(i, j);
                #5ns;
                result = i - j - k;
                b_out = result[4];
                this.info($sformatf("X = %1h, Y = %1h, X - Y = %1h, BIN = %b, BOUT = %b",
                        i, j, 
                        this.vif_h.d_vif.gpio,
                        this.vif_h.b_vif.gpio[`FBFS_B_IN],
                        this.vif_h.b_vif.gpio[`FBFS_B_OUT])
                        );
                this.check_data($sformatf("X(%1h) - Y(%1h)", i, j), 
                                result[3 : 0], 
                                this.vif_h.d_vif.gpio
                                );
                this.check_bit("BOUT", b_out, this.vif_h.b_vif.gpio[`FBFS_B_OUT]);
                #100ns;
            end 
        end
    end
    #100ns;
    this.info($sformatf("Ending test: %s", this.id), 1);

endtask : run_phase
/*******************************************************************************************/

`endif /* __FOUR_BIT_FULL_SUBTRACTOR_TEST_GENERIC_SV__ */

