
`ifndef __TEST_BASE_SV__
`define __TEST_BASE_SV__

class test_base;
   /**
    * Test report attributes
    */    
   int unsigned info_cnt;
   int unsigned warning_cnt;
   int unsigned error_cnt;
   int unsigned fatal_cnt;
   
   /**
    * Test status attributes.
    */
   string id;
   string err_msg[$];
   int unsigned pass;
   int unsigned fail;
   bit end_of_test;
   
   function new(string _id = "test_base"); 
      this.id = _id;
      this.err_msg = {};
      this.pass = 0;
      this.fail = 0;
      this.end_of_test = 0;
      
      info_cnt = 0;
      warning_cnt = 0;
      error_cnt = 0;
      fatal_cnt = 0;
   endfunction : new
   
   /*************************************************************************************/
   function void passed();
      this.pass++;
   endfunction : passed
   /*************************************************************************************/
   
   /*************************************************************************************/
   function void failed(string _err_msg);
      this.fail++;
      this.err_msg.push_back(_err_msg);
   endfunction : failed
   /*************************************************************************************/
   
   /*************************************************************************************/
   /** 
    * Report methods
    */
   function void info(string _s,
                        bit _verbosity = 0
                        );
      if (_verbosity) begin
          $display("[INFO] (%t) %s: %s", $time, this.id, _s);
          this.info_cnt++;
      end
   endfunction : info 

   function void warning(string _s);
      $display("[WARNING] (%t) %s: %s", $time, this.id, _s);
      this.warning_cnt++;
   endfunction : warning 

   function void error(string _s);
      $display("[ERROR] (%t) %s: %s", $time, this.id, _s);
      this.error_cnt++;
   endfunction : error

   function void fatal(string _s);
      $display("[FATAL] (%t) %s: %s", $time, this.id, _s);
      this.fatal_cnt++;
      $fatal;
   endfunction : fatal
   /*************************************************************************************/
   
   /*************************************************************************************/
   function string report();
      string test_status;
      string str;
      $display("==============Test Results==============");            
      if (0 == this.fail) begin
         test_status = "PASSED";
      end else begin
         test_status = "FAILED";
         foreach(this.err_msg[i]) begin
            $display("[%d] - %s", i, this.err_msg[i]);
         end
      end
      $display("-------------------------------------");
      $display("Test Name: %s", this.id);
      $display("-------------------------------------");
      $display("Passed: %d", this.pass);
      $display("Failed: %d", this.fail);
      $display("Test Status: %s", test_status);
      $display("========================================");
      
      str = $sformatf("Test: %-30s - Status: %s", this.id, test_status);
      return str;
   endfunction : report
   /*************************************************************************************/ 
   
   /*************************************************************************************/
   /**
    * Check methods
    */
   function void check_bit(string _info,
                           bit _exp,
                           bit _act,
                           bit _v = 0
                           );
      if (_act == _exp) begin
         this.info($sformatf("Checking %s... OK. Expected = %d, Actual = %d",
                              _info,
                              _exp,
                              _act),
                              _v
                              );      
         this.passed();
      end else begin
         this.error($sformatf("Checking %s... OK. Expected = %d, Actual = %d",
                              _info,
                              _exp,
                              _act));
         this.failed($sformatf("[ERROR] (%t): Checking %s... NOK. Expected = %d, Actual = %d",
                  $time,
                  _info,
                  _exp,
                  _act));
      end 
   endfunction : check_bit
   /*************************************************************************************/
   
   /*************************************************************************************/
   function void check_data(string _info,
                              int unsigned _exp,
                              int unsigned _act,
                              bit _v = 0
                              );
      if (_act == _exp) begin
         this.info($sformatf("Checking %s... OK. Expected = %d, Actual = %d",
                              _info,
                              _exp,
                              _act),
                              _v
                              );
         this.passed();
      end else begin
         this.error($sformatf("Checking %s... OK. Expected = %d, Actual = %d",
                              _info,
                              _exp,
                              _act));  
         this.failed($sformatf("[ERROR] (%t): Checking %s... NOK. Expected = %d, Actual = %d",
                  $time,
                  _info,
                  _exp,
                  _act));
      end 
   endfunction : check_data
   /*************************************************************************************/
   
   /*************************************************************************************/
   /**
    * Phases
    */
   /** Reset phase(s) */
   extern virtual task pre_reset_phase();
   extern virtual task reset_phase();
   extern virtual task post_reset_phase();
   /** Configure phase(s) */
   extern virtual task pre_configure_phase();
   extern virtual task configure_phase();
   extern virtual task post_configure_phase();
   /** Run phase(s) */
   extern virtual task pre_run_phase();
   extern virtual task run_phase();
   extern virtual task post_run_phase();
   /** Check phase(s) */
   extern virtual task pre_check_phase();
   extern virtual task check_phase();
   extern virtual task post_check_phase();
   /** Report phase(s) */
   extern virtual task pre_report_phase();
   extern virtual task report_phase();
   extern virtual task post_report_phase(); 
   extern virtual task final_phase();
   /*************************************************************************************/
   
   
   /*************************************************************************************/
   /**
    * Main run phase
    */
   extern task run_test();
   /*************************************************************************************/
endclass : test_base

/*************************************************************************************/
task test_base::pre_reset_phase();
    this.end_of_test = 0;
    this.info("PRE_RESET_PHASE", 1);
endtask : pre_reset_phase

task test_base::reset_phase();
    this.info("RESET_PHASE", 1);
endtask : reset_phase

task test_base::post_reset_phase();
    this.info("POST_RESET_PHASE", 1);
endtask : post_reset_phase
/*************************************************************************************/

/*************************************************************************************/
task test_base::pre_configure_phase();
    this.info("PRE_CONFIGURE_PHASE", 1);
endtask : pre_configure_phase

task test_base::configure_phase();
    this.info("CONFIGURE_PHASE", 1);
endtask : configure_phase

task test_base::post_configure_phase();
    this.info("POST_CONFIGURE_PHASE", 1);
endtask : post_configure_phase
/*************************************************************************************/

/*************************************************************************************/
task test_base::pre_run_phase();
    this.info("PRE_RUN_PHASE", 1);
endtask : pre_run_phase

task test_base::run_phase();
    this.info("RUN_PHASE", 1);
endtask : run_phase

task test_base::post_run_phase();
    this.info("POST_RUN_PHASE", 1);
endtask : post_run_phase
/*************************************************************************************/

/*************************************************************************************/
task test_base::pre_check_phase();
    this.info("PRE_CHECK_PHASE", 1);
endtask : pre_check_phase

task test_base::check_phase();
    this.info("CHECK_PHASE", 1);
endtask : check_phase

task test_base::post_check_phase();
    this.info("POST_CHECK_PHASE", 1);
endtask : post_check_phase
/*************************************************************************************/

/*************************************************************************************/
task test_base::pre_report_phase();
    this.info("PRE_REPORT_PHASE", 1);
endtask : pre_report_phase

task test_base::report_phase();
    this.info("REPORT_PHASE", 1);
    this.report();
endtask : report_phase

task test_base::post_report_phase();
    this.info("POST_REPORT_PHASE", 1);
endtask : post_report_phase
/*************************************************************************************/

task test_base::final_phase();
    $display("==============Report Summary==============");
    $display("-------------------------------------");
    $display("INFO: %0d", this.info_cnt);
    $display("WARINIG: %0d", this.warning_cnt);
    $display("ERROR: %0d", this.error_cnt);
    $display("FATAL: %0d", fatal_cnt);
    $display("========================================");
    this.end_of_test = 1;
endtask : final_phase

/*************************************************************************************/
task test_base::run_test();
    this.info("Entering PRE_RESET_PHASE", 1);
    this.pre_reset_phase();
    this.info("Exiting PRE_RESET_PHASE", 1);
    this.info("Entering RESET_PHASE", 1);
    this.reset_phase();
    this.info("Exiting RESET_PHASE", 1);
    this.info("Entering POST_RESET_PHASE", 1);
    this.post_reset_phase();
    this.info("Exiting POST_RESET_PHASE", 1);
    
    this.info("Entering PRE_CONFIGURE_PHASE", 1);
    this.pre_configure_phase();
    this.info("Exiting PRE_CONFIGURE_PHASE", 1);
    this.info("Entering CONFIGURE_PHASE", 1);
    this.configure_phase();
    this.info("Exiting CONFIGURE_PHASE", 1);
    this.info("Entering POST_CONFIGURE_PHASE", 1);
    this.post_configure_phase();
    this.info("Exiting POST_CONFIGURE_PHASE", 1);
    
    this.info("Entering PRE_RUN_PHASE", 1);
    this.pre_run_phase();
    this.info("Exiting PRE_RUN_PHASE", 1);
    this.info("Entering RUN_PHASE", 1);
    this.run_phase();
    this.info("Exiting RUN_PHASE", 1);
    this.info("Entering POST_RUN_PHASE", 1);
    this.post_run_phase();
    this.info("Exiting POST_RUN_PHASE", 1);
    
    this.info("Entering PRE_CHECK_PHASE", 1);
    this.pre_check_phase();
    this.info("Exiting PRE_CHECK_PHASE", 1);
    this.info("Entering CHECK_PHASE", 1);
    this.check_phase();
    this.info("Exiting CHECK_PHASE", 1);
    this.info("Entering POST_CHECK_PHASE", 1);
    this.post_check_phase();
    this.info("Exiting POST_CHECK_PHASE", 1);
    
    this.info("Entering PRE_REPORT_PHASE", 1);
    this.pre_report_phase();
    this.info("Exiting PRE_REPORT_PHASE", 1);
    this.info("Entering REPORT_PHASE", 1);
    this.report_phase();
    this.info("Exiting REPORT_PHASE", 1);
    this.info("Entering POST_REPORT_PHASE", 1);
    this.post_report_phase();
    this.info("Exiting POST_REPORT_PHASE", 1);
    this.final_phase();
endtask : run_test

`endif /* __TEST_BASE_SV__ */

