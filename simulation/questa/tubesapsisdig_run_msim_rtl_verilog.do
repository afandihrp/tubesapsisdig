transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/file\ code/quartus\ prime/tubes\ appsisdig {D:/file code/quartus prime/tubes appsisdig/tubesapsisdig.v}

