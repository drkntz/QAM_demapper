transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+S:/projects/QAM_demapper {S:/projects/QAM_demapper/QAM_demapper.v}

