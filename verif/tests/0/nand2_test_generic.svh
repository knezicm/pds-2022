
`ifndef __NAND2_TEST_GENERIC_SV__
`define __NAND2_TEST_GENERIC_SV__

class nand2_test_generic extends test_base;
    
    nand2_vif_wrapper vif_h;
    
    function new(string _id = "nand2_test_generic", 
                virtual_interface_base _vif
                );
      super.new(_id);
      $cast(vif_h, _vif);
    endfunction : new

    extern task drive(bit _a, 
                        bit _b
                        );

    extern virtual task vif_init();
    extern virtual task run_phase();
   
endclass : nand2_test_generic

task nand2_test_generic::vif_init();
    this.vif_h.in_vif.gpio <= 0;
    #0;
endtask : vif_init

task nand2_test_generic::drive(bit _a, 
                                bit _b
                                );
    this.vif_h.in_vif.gpio[`NAND2_A] <= _a;
    this.vif_h.in_vif.gpio[`NAND2_B] <= _b;
    #0;
endtask : drive

/*******************************************************************************************/
task nand2_test_generic::run_phase();
    bit a;
    bit b;
    bit y;
    
    super.run_phase();
   
    this.info($sformatf("Starting test: %s", this.id), 1);
    this.vif_init();
    #100ns;
   
       
    #100ns;
    for (int i = 0; i < 2; i++) begin
        for (int j = 0; j < 2; j++) begin
            a = i;
            b = j;
            this.drive(i, j);
            #5ns;
            y = ~(a & b);
            
            this.info($sformatf("A = %1b, B = %1b, not(A & B) = %1b",
                    this.vif_h.in_vif.gpio[`NAND2_A],
                    this.vif_h.in_vif.gpio[`NAND2_B],
                    this.vif_h.out_vif.gpio[`NAND2_Y]), 
                    1
                    );
           
            this.check_bit("~(A & B)", 
                            y, 
                            this.vif_h.out_vif.gpio[`NAND2_Y]
                            );
            #100ns;
        end 
    end
    #100ns;
    this.info($sformatf("Ending test: %s", this.id), 1);
    
endtask : run_phase
/*******************************************************************************************/

`endif /* __NAND2_TEST_GENERIC_SV__ */

