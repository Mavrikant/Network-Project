set term png
set title "TCP, UDP throughput on DropTail Buffer Type"
set xlabel "Time in second*10"
set ylabel "Throughput in bit"
set output "DropTail.png"
plot "throughput.tr" using 1:2 title 'TCP Flow' with lines, "throughput.tr" using 1:3 title 'CBR Flow' with lines



set title "TCP, UDP throughput on RED Buffer Type"
set xlabel "Time in second*10"
set ylabel "Throughput in bit"
set output "RED.png"
plot "throughput.tr" using 1:4 title 'TCP Flow' with lines, "throughput.tr" using 1:5 title 'CBR Flow' with lines



set title "TCP, UDP throughput on FQ Buffer Type"
set xlabel "Time in second*10"
set ylabel "Throughput in bit"
set output "FQ.png"
plot "throughput.tr" using 1:6 title 'TCP Flow' with lines, "throughput.tr" using 1:7 title 'CBR Flow' with lines
