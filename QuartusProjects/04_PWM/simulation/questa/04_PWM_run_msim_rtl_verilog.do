transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/dmart/Logica-Programable-/QuartusProjects/04_PWM/scripts {C:/Users/dmart/Logica-Programable-/QuartusProjects/04_PWM/scripts/clk_divider.v}
vlog -vlog01compat -work work +incdir+C:/Users/dmart/Logica-Programable-/QuartusProjects/04_PWM/scripts {C:/Users/dmart/Logica-Programable-/QuartusProjects/04_PWM/scripts/debouncer.v}

vlog -vlog01compat -work work +incdir+C:/Users/dmart/Logica-Programable-/QuartusProjects/04_PWM/testbenches {C:/Users/dmart/Logica-Programable-/QuartusProjects/04_PWM/testbenches/debouncer_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  debouncer_tb

add wave *
view structure
view signals
run -all
