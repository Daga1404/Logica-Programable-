transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/dmart/Logica-Programable-/QuartusProjects/02_BCD/scripts {C:/Users/dmart/Logica-Programable-/QuartusProjects/02_BCD/scripts/decoder_0_F.v}
vlog -vlog01compat -work work +incdir+C:/Users/dmart/Logica-Programable-/QuartusProjects/02_BCD/scripts {C:/Users/dmart/Logica-Programable-/QuartusProjects/02_BCD/scripts/bcd_decoder.v}

vlog -vlog01compat -work work +incdir+C:/Users/dmart/Logica-Programable-/QuartusProjects/02_BCD/scripts {C:/Users/dmart/Logica-Programable-/QuartusProjects/02_BCD/scripts/bcd_decoder_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  bcd_decoder_tb

add wave *
view structure
view signals
run -all
