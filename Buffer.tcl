#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Open the Trace file
set tf [open out.tr w]
$ns trace-all $tf
$ns use-newtrace


#Create 12 nodes
for {set i 0} {$i < 12} {incr i} {
        set n$i [$ns node]
}

#Create links between the nodes
$ns duplex-link $n2 $n1 2Mb 10ms DropTail
$ns duplex-link $n3 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n0 2Mb 10ms DropTail
$ns duplex-link $n6 $n5 2Mb 10ms RED
$ns duplex-link $n7 $n5 2Mb 10ms RED
$ns duplex-link $n5 $n4 2Mb 10ms RED
$ns duplex-link $n10 $n9 2Mb 10ms FQ
$ns duplex-link $n11 $n9 2Mb 10ms FQ
$ns duplex-link $n9 $n8 2Mb 10ms FQ

#Tell the simulator to use dynamic routing
#$ns rtproto DV $n0 $n1 $n2 $n3 $n4 $n5
$ns rtproto Session

#Set Queue Size of link (n2-n3) to 10
$ns queue-limit $n1 $n0 10
$ns queue-limit $n5 $n4 10
$ns queue-limit $n9 $n8 10

#Give node position (for NAM)
$ns duplex-link-op $n2 $n1 orient right-down
$ns duplex-link-op $n3 $n1 orient right-up
$ns duplex-link-op $n1 $n0 orient right
#$ns duplex-link-op $n6 $n5 orient right-down
#$ns duplex-link-op $n7 $n5 orient right-up
#$ns duplex-link-op $n5 $n4 orient right
#$ns duplex-link-op $n10 $n9 orient right-down
#$ns duplex-link-op $n11 $n9 orient right-up
#$ns duplex-link-op $n9 $n8 orient right

#Monitor the queue for link (n2-n3). (for NAM)
$ns duplex-link-op $n1 $n0 queuePos 0.5
$ns duplex-link-op $n5 $n4 queuePos 0.5
$ns duplex-link-op $n9 $n8 queuePos 0.5

#Setup a TCP connection
set tcp1 [new Agent/TCP]
set tcp2 [new Agent/TCP]
set tcp3 [new Agent/TCP]
$tcp1 set class_ 2
$tcp2 set class_ 2
$tcp3 set class_ 2
$ns attach-agent $n2 $tcp1
$ns attach-agent $n6 $tcp2
$ns attach-agent $n10 $tcp3
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
set sink3 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
$ns attach-agent $n4 $sink2
$ns attach-agent $n8 $sink3
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$ns connect $tcp3 $sink3
$tcp1 set fid_ 1
$tcp2 set fid_ 1
$tcp3 set fid_ 1

#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
set ftp3 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2
$ftp3 attach-agent $tcp3
$ftp1 set type_ FTP
$ftp2 set type_ FTP
$ftp3 set type_ FTP


#Setup a UDP connection
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
set udp3 [new Agent/UDP]
$ns attach-agent $n3 $udp1
$ns attach-agent $n7 $udp2
$ns attach-agent $n11 $udp3
set null1 [new Agent/Null]
set null2 [new Agent/Null]
set null3 [new Agent/Null]
$ns attach-agent $n0 $null1
$ns attach-agent $n4 $null2
$ns attach-agent $n8 $null3
$ns connect $udp1 $null1
$ns connect $udp2 $null2
$ns connect $udp3 $null3
$udp1 set fid_ 2
$udp2 set fid_ 2
$udp3 set fid_ 2

#Setup a CBR over UDP connection
set cbr1 [new Application/Traffic/CBR]
set cbr2 [new Application/Traffic/CBR]
set cbr3 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr2 attach-agent $udp2
$cbr3 attach-agent $udp3
$cbr1 set type_ CBR
$cbr2 set type_ CBR
$cbr3 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr2 set packet_size_ 1000
$cbr3 set packet_size_ 1000
$cbr1 set rate_ 1.5mb
$cbr2 set rate_ 1.5mb
$cbr3 set rate_ 1.5mb
$cbr1 set random_ false
$cbr2 set random_ false
$cbr3 set random_ false


#Schedule events for the CBR and FTP agents
$ns at 0.0 "$cbr1 start"
$ns at 3.0 "$ftp1 start"
$ns at 9.0 "$ftp1 stop"
$ns at 6.0 "$cbr1 stop"

$ns at 0.0 "$cbr2 start"
$ns at 3.0 "$ftp2 start"
$ns at 9.0 "$ftp2 stop"
$ns at 6.0 "$cbr2 stop"

$ns at 0.0 "$cbr3 start"
$ns at 3.0 "$ftp3 start"
$ns at 9.0 "$ftp3 stop"
$ns at 6.0 "$cbr3 stop"

#hat kesilip acilmasi
#$ns rtmodel-at 1.0 down $n3 $n1
#$ns rtmodel-at 4.5 up $n3 $n1
#$ns rtmodel-at 2.0 down $n2
#$ns rtmodel-at 4.0 up $n2

#Detach tcp and sink agents (not really necessary)
#$ns at 4.5 "$ns detach-agent $n0 $tcp1 ; $ns detach-agent $n3 $sink1"
#$ns at 4.5 "$ns detach-agent $n4 $tcp2 ; $ns detach-agent $n7 $sink2"
#$ns at 4.5 "$ns detach-agent $n8 $tcp3 ; $ns detach-agent $n11 $sink3"

#Call the finish procedure after 10 seconds of simulation time
$ns at 10.0 "finish"

#Print CBR packet size and interval
#puts "CBR packet size = [$cbr1 set packet_size_]"
#puts "CBR interval = [$cbr1 set interval_]"

#puts "CBR packet size = [$cbr2 set packet_size_]"
#puts "CBR interval = [$cbr2 set interval_]"

#puts "CBR packet size = [$cbr3 set packet_size_]"
#puts "CBR interval = [$cbr3 set interval_]"

#Define a 'finish' procedure
proc finish {} {
        global ns nf tf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Close the Trace file
        close $tf
        #Execute NAM on the trace file
        exec nam out.nam &
	exec gawk -f throughput.awk out.tr > throughput.tr
	exec gnuplot Buffer.gp &
        exit 0
}

#Run the simulation
$ns run


