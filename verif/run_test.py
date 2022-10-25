#!/usr/bin/python3

import os;
import sys;
import getopt;
import datetime;


#***************************************************************************
#
#! Functions that prints APP help.
#
def print_help() :
    help_string = '';
    print(help_string);
#***************************************************************************

#***************************************************************************
#
#! Functions that prints APP info.
#
def app_info() :
    info_str = '';
    print(info_str);
#***************************************************************************

#***************************************************************************
#
#! Function that formats current date/time
#
def get_current_timedate() :
   now = datetime.datetime.now();
   dt_string = now.strftime("%Y-%m-%d %H:%M:%S");
   return dt_string;
#***************************************************************************

#
#! List of Stages
#
stages = {
    "setup_sim_env" : 0,
    "compile" : 1,
    "compile-tb" : 2,
    "simulate" : 3,
    "coverage" : 4,
    "synthesis" : 5
    };

#
#! APPlication options
#
app_opts = {
    "issue" : 0,
    "stage" : "",
    "design" : "",
    "top" : "top",
    "tool" : "altera",
    "user" : False,
    "cover" : False,
    "synth" : False,
    "force" : False,
    "help" : False,
    "version" : False 
    };


#
#! Parse command line arguments
#
try :
    opts, args = getopt.getopt(sys.argv[1 : ],
                                "hvu",
                                [
                                    "issue=",
                                    "stage=",
                                    "design=",
                                    "top=",
                                    "tool=",
                                    "user",
                                    "cover",
                                    "synth",
                                    "force",
                                    "help",
                                    "version"
                                ]);
    for opt, arg in opts :
        #! Help
        if opt in ("-h", "--help") :
            app_opts["help"] = True;
            break;
        #! Version
        elif opt in ("-v", "--version") :
            app_opts["version"] = True;
            break;
        #! USER
        elif opt in ("-u", "--user") :
            app_opts["user"] = True;
        #! Issue number
        elif opt in ("--issue") :
            app_opts["issue"] = arg;
        #! Stage
        elif opt in ("--stage") :
            app_opts["stage"] = arg;
        #! Top level design
        elif opt in ("--design") :
            app_opts["design"] = arg;
        #! Testbench
        elif opt in ("--top") :
            app_opts["top"] = arg;
        #! HDL tool
        elif opt in ("--tool") :
            app_opts["tool"] = arg;
        #! Coverage
        elif opt in ("--cover") :
            app_opts["cover"] = True;
        #! Synthesis
        elif opt in ("--synth") :
            app_opts["synth"] = True;
        #! Force issue 
        elif opt in ("--force") :
            app_opts["force"] = True;
except getopt.GetoptError :
    # 
    #! \TODO Example of usage
    #
    pass



hdl_tool = {};
env_is_set = 0;

#
#! Paths
#
path = {
    "root" : "..",
    "sim" : "./sim",
    "results" : "%s/test_results" %(app_opts["issue"]),
    "log" : "%s/test_results/log_files" %(app_opts["issue"])
};

#***************************************************************************
#
#! Function that reads tool config file and sets the tool's attribute 
#! in \@hdl_tool
#
def load_hdl_tool(_tool) :
    config_file = "./config/%s.config" %(_tool);
    is_exist = os.path.exists(config_file);
    print("Reading HDL tool configuration file: %s ..." %(config_file));
    if (is_exist) :
        f = open(config_file, 'r');
        for line in f.readlines() :
            l = line.split("::");
            hdl_tool[l[0]] = l[1].strip();
        f.close();
        return 0;
    else :
        print("Task specification file: %s ... does not exist!" %(config_file));
        return -1;
#***************************************************************************

#***************************************************************************
#
#! Function that validates the stage argument from CLI 
#
def check_stage_arg(_stage) :
    if _stage in stages :
        return 0;
    elif "" == _stage :
        return 1;
    else :
        return -1;
#***************************************************************************

#***************************************************************************
#
#! Stage 0: Setting up the simulation environment
#
def setup_sim_env() :
    print("Setting up simulation environment.");
    #
    #! Create log directory, if it does not exist
    #
    log_dir = path["sim"] + '/' + path["log"];
    print("Creating log directory - \"%s\" ..." %(log_dir));
    is_exist = os.path.exists(log_dir);
    if (0 == is_exist) :
        os.makedirs(log_dir);
    else :
        print("Log directory - \"%s\" already exists." %(log_dir));
    
    #! Move to the sim directory
    os.chdir(path["sim"]);
    os.system("pwd");
    #
    #! Create design file list
    #
    filelist = "issue%s.filelist" %(app_opts["issue"]);
    print("Creating compile file list - \"%s\" ..." %(filelist));
    os.system("find %s -name \"*.vhd\" > %s" %(
                path["root"] + "/../assignments/" + app_opts["issue"],
                #working_directory + _issue.get_hdl_path(), 
                filelist
                ));
    #
    #! Create desing.config file for modelsim  
    #
    work_lib = "issue_%s_lib" %(app_opts["issue"]);
    print("Creating config file for modelsim - design.config ...");
    os.system("echo \"quietly set TOP_NAME \"%s\"\" > design.config" %(app_opts["top"]));
    os.system("echo \"quietly set ISSUE %s\" >> design.config" %(app_opts["issue"]));
    os.system("echo \"quietly set TOP_LEVEL_NAME \"%s\"\" >> design.config" %(app_opts["design"]));
    os.system("echo \"quietly set TOP_ARCH rtl\" >> design.config"); # \TODO
    os.system("echo \"quietly set TOP_LEVEL_WRAPPER \"%s\"\" >> design.config" %(app_opts["design"] + "_wrapper"));
    os.system("echo \"quietly set ISSUE_LIB \"%s\"\" >> design.config" %(work_lib));
    os.system("echo \"quietly set TEST_LIST ../tests/\"%s\"/test.list\" >> design.config" %(app_opts["issue"]));
    os.system("echo \"quietly set ISSUE_SYNTH_LIB synth_lib\"  >> design.config");
    # Move back to the working directory
    os.chdir(path["root"]);
    os.system("pwd");
    
    return 1;
#***************************************************************************

#***************************************************************************
#
#! STAGE 1 : Compile design (VHDL) for the current task/issue.
#
def compile_design() :
    ret_val = 0;
    # Set value for the design filelist
    filelist = "issue%s.filelist" %(app_opts["issue"]);
    # Set value for working library
    work_lib = "issue_%s_lib" %(app_opts["issue"]);
    
    #! Move to the sim directory
    os.chdir(path["sim"]);
    os.system("pwd");
    #
    #! Altera's modelsim
    #! Questa'a questasim
    #
    if ("altera" == app_opts["tool"].lower()) :
        #! Delete librarie if exists
        is_exist = os.path.exists("libs/" + work_lib);
        if (is_exist) :
            os.system("rm -fr libs/%s" %(work_lib));
        #
        #! Create design library 
        #
        os.system("vlib libs");
        os.system("vlib libs/%s" %(work_lib));
        os.system("vmap %s libs/%s" %(work_lib, work_lib));
        #! Compile design 
        print("Compiling design for the issue %s." %(app_opts["issue"]));
        os.system("%s -work %s %s %s -l %s" %(
                    hdl_tool["vcom"], 
                    work_lib, 
                    hdl_tool["vcom_flags"], 
                    filelist, 
                    path["log"] + "/" + hdl_tool["vcom"] + ".log"
                    ));
    #
    #! GHDL 
    #
    elif ("ghdl" == app_opts["tool"].lower()) :
        fd = open(filelist);
        f = fd.readlines();
        files = "";
        for l in f :
            files += l.strip() + " ";
        #! Delete librarie if exists
        is_exist = os.path.exists("libs/" + work_lib);
        if (is_exist) :
            os.system("rm -fr libs/%s" %(work_lib));  
        os.system("mkdir libs");
        os.system("mkdir libs/%s" %(work_lib));
        os.system("%s %s --work=%s --workdir=./libs/%a  %s" %(
                    hdl_tool["vlib"],
                    hdl_tool["vlib_flags"],
                    work_lib, 
                    work_lib,
                    files
                    ));
        print("Compiling design for the issue %s." %(app_opts["issue"]));
        os.system("%s %s --work=%s --workdir=./libs/%s  %s" %(
                    hdl_tool["vcom"],
                    hdl_tool["vcom_flags"],
                    work_lib,
                    work_lib, 
                    app_opts["top"]
                    ));
    else :
        print("Unsupported vendor!!!");
        ret_val = -1;  
    
    # Move back to the working directory
    os.chdir(path["root"]);
    os.system("pwd");
    
    return ret_val;   
     

#***************************************************************************
#
#! STAGE 2 : Compile design for the current task/issue.
#
def compile_testbench() :
    
    #
    #! Create log directory, if it does not exist
    #
    log_dir = path["sim"] + '/' + path["log"];
    work_lib = "test_lib";
    dut_wrap_macro = " -define DUT_WRAPPER=%s " %(app_opts["design"] + "_wrapper");
    
    print("Creating log directory - \"%s\" ..." %(log_dir));
    is_exist = os.path.exists(log_dir);
    if (0 == is_exist) :
        os.makedirs(log_dir);
    else :
        print("Log directory - \"%s\" already exists." %(log_dir));
    
    #! Move to the sim directory
    os.chdir(path["sim"]);
    os.system("pwd");
    print("Compiling testbench...");
    #! Create librarie if not exists
    is_exist = os.path.exists("libs/" + work_lib);
    print("Compiling test_pkg");
    if (not is_exist) :
        #os.system("rm -fr libs/%s" %(work_lib));
        os.system("vlib libs/%s" %(work_lib));
        os.system("vmap %s libs/%s" %(work_lib, work_lib)); 
    
        #! Compile testbench
        os.system("%s -work %s %s %s -l %s" %(
                    hdl_tool["vlog"], 
                    work_lib, 
                    dut_wrap_macro + hdl_tool["vlog_flags"], 
                    "../tests/test.filelist", 
                    path["log"] + "/" + hdl_tool["vlog"] + "_test.log"
                    ));
    else :
        print("Testbench has already been compiled in ./libs/test_lib!");
        
    #! Delete librarie if exists
    is_exist = os.path.exists("libs/" + "work");
    if (is_exist) :
        os.system("rm -fr libs/work");
    
    #! Create design library 
    os.system("vlib libs/work");
    os.system("vmap work libs/work");   
    print("Compiling issue wrapper - %s..." %(app_opts["design"] + "_wrapper"));
    os.system("%s -work %s %s %s -l %s" %(
                hdl_tool["vlog"], 
                "work -L %s" %(work_lib), 
                dut_wrap_macro + hdl_tool["vlog_flags"], 
                "../tests/%s/wrapper.filelist" %(app_opts["issue"]), 
                path["log"] + "/" + hdl_tool["vlog"] + "_wrapper.log"
                ));
    print("Compiling top...");
    os.system("%s -work %s %s %s -l %s" %(
                hdl_tool["vlog"], 
                "work -L %s" %(work_lib),
                dut_wrap_macro + hdl_tool["vlog_flags"], 
                "../tests/top.filelist",
                path["log"] + "/" + hdl_tool["vlog"] + "_top.log"
                ));
    # Move back to the working directory
    os.chdir(path["root"]);
    os.system("pwd");


def simulate() : 
    #! Move to the sim directory
    os.chdir(path["sim"]);
    os.system("pwd");
    #! Run simulation
    print("Running simulation");
    
    if ("altera" == app_opts["tool"].lower()) :
    
        if (False == app_opts["user"]) :
            os.system("vsim -c -do ./modelsim/simulate -l %s" %(path["log"] + "/vsim.log"));
            print("Simulation results (logs, waves, coverage) \"%s\"" %(path["sim"] + '/' + path["results"]));
        else :
            os.system("vsim issue_%s_lib.%s -t 1ps -displaymsgmode both -L issue_%s_lib -c -do \"run -all;quit;\" -l %s" %(
                        app_opts["issue"], 
                        app_opts["top"],
                        app_opts["issue"],
                        path["log"] + "/vsim.log"));
    elif ("ghdl" == app_opts["tool"].lower()) :
        work_lib = "issue_%s_lib" %(app_opts["issue"]);
        os.system("%s %s --work=%s --workdir=./libs/%s  %s" %(
                    hdl_tool["vsim"],
                    hdl_tool["vsim_flags"],
                    work_lib, 
                    work_lib,
                    app_opts["top"]
                    ));
    else :
        print("Unsupported vendor");    
    
    # Move back to the working directory
    os.chdir(path["root"]);
    os.system("pwd");
    

def coverage() :
    if (True == app_opts["cover"]) :
        #! Move to the sim directory
        os.chdir(path["sim"]);
        os.system("pwd");
        #! Run simulation
        print("Generation coverage report");
        os.system("vsim -c -do ./modelsim/coverage -l %s" %(path["log"] + "/cover.log"));
        # Move back to the working directory
        os.chdir(path["root"]);
        os.system("pwd");
    else :
        print("Coverage flag is not specified!");
        
def synthesis() :
    print("Not implemented!");
    if (True == app_opts["synth"]) :
        print("Running synthesis");
    else :
        print("Synthesis flag is not specified!");

stage_func = [
    setup_sim_env,
    compile_design,
    compile_testbench,
    simulate,
    coverage,
    synthesis
];

def main() :
    #
    #! Print APP help and exit
    #
    if (True == app_opts["help"]) :
        print_help();
        exit();
    #
    #! Print APP version and exit
    #
    if (True == app_opts["version"]) :
        print("v2.1.1");
        exit();
    #
    #! Print app options
    #
    print(70*'*');
    print("App is running with the options:");
    for k, v in app_opts.items() :
        print("  %s : %s" %(k, v));
    print(70*'*');
    #
    #! Check the design top name
    #
    if ("" == app_opts["design"]) :
        design_file = "./tests/%s/design.name" %(app_opts["issue"]);
        is_exist = os.path.exists(design_file);
        print("Reading HDL design top file: %s ..." %(design_file));
        if (is_exist) :
            f = open(design_file, 'r');
            app_opts["design"] = f.read().strip();
            f.close();
        else :
            print("Task specification file: %s ... does not exist!" %(design_file));
            print_help();
            exit(-1);
    #
    #! Check for tool support and load tool. 
    #
    if (-1 == load_hdl_tool(app_opts["tool"])) :
        print("Unsupported tool vendor!");
        print("Supported vendor(s):");
        print("  - Altera,");
        print("  - ghdl");
        exit(-1);
    #
    #! Run stage(s)
    #  
    if (0 == check_stage_arg(app_opts["stage"])) :
        stage_func[stages["setup_sim_env"]]();
        stage_func[stages[app_opts["stage"]]]();
    elif (1 == check_stage_arg(app_opts["stage"])) :
        for f in stage_func :
            f();
    else :
        print("Specified stage \"%s\" does not exist!" %(app_opts["stage"]));
        
    
    
if "__main__" == __name__ :
    main();
    

