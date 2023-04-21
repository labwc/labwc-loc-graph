#!/bin/bash

type gnuplot >/dev/null 2>&1 || { printf 'fatal: need gnuplot\n'; exit 1; }

loc_file="data.txt"
loc_graph="graph.png"
gnuplot_commands=$(mktemp)
cat >"$gnuplot_commands" <<'EOF'
set title "lines of .c code vs time"
set xdata time
set term png
set timefmt "%Y-%m-%d"
set format x "%Y-%m"
set xlabel "Time"
set ylabel "LOC (using 'cloc src/')"
set xtics rotate by -45

set style line 1 lc rgb '#0066aa' pt 0 ps 1 lt 0 lw 0
set style line 2 lc rgb '#ff0000' pt 7 ps 1 lt 0 lw 0

set xrange ["2020-05-01":"2023-06-30"]
set yrange ["0":"14000"]

unset key

# Axes
set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror out scale 0.75

# Grid
set style line 12 lc rgb'#808080' lt 0 lw 1
set grid back ls 12
EOF
printf '%b\n' "set output \"$loc_graph\"" >>"$gnuplot_commands"
printf '%b\n' "plot \"$loc_file\" using 2:5 w p ls 1 ,\\" >>"$gnuplot_commands"
printf '%b\n' "              \"\" using 2:6 w p ls 2 ,\\" >>"$gnuplot_commands"
printf '%b\n' "              \"\" using 2:6:7 with labels font \"sans,8\" right offset -0.5,0.5 ls 1" >>"$gnuplot_commands"

trap "rm -f ${gnuplot_commands}" EXIT

gnuplot <"$gnuplot_commands"
rm -f "${gnuplot_commands}"
