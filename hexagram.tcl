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
        exit 0
}


#Create six nodes
for {set i 0} {$i < 6} {incr i} {
        set n$i [$ns node]
}

#Create links between the nodes
$ns duplex-link $n0 $n1 0.3Mb 19ms DropTail
$ns duplex-link $n0 $n2 0.15Mb 8ms DropTail
$ns duplex-link $n0 $n4 0.1Mb 16ms DropTail
$ns duplex-link $n0 $n5 5.6Mb 11ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 4ms DropTail
$ns duplex-link $n1 $n3 0.6Mb 20ms DropTail
$ns duplex-link $n1 $n5 4.0Mb 1ms DropTail
$ns duplex-link $n2 $n3 0.33Mb 6ms DropTail
$ns duplex-link $n2 $n4 6.8Mb 17ms DropTail
$ns duplex-link $n3 $n4 6.2Mb 13ms DropTail
$ns duplex-link $n3 $n5 2.0Mb 5ms DropTail
$ns duplex-link $n4 $n5 8.8Mb 14ms DropTail

#Tell the simulator to use dynamic routing
#$ns rtproto DV $n0 $n1 $n2 $n3 $n4 $n5
$ns rtproto Session

#Set Queue Size of link (n2-n3) to 10
#$ns queue-limit $n2 $n3 10

#Give node position (for NAM)
#$ns duplex-link-op $n0 $n1 orient left-up
#$ns duplex-link-op $n0 $n2 orient left-up
#$ns duplex-link-op $n0 $n4 orient right-up
#$ns duplex-link-op $n0 $n5 orient right-up
#$ns duplex-link-op $n1 $n2 orient up
#$ns duplex-link-op $n1 $n3 orient right-up
#$ns duplex-link-op $n1 $n5 orient right
#$ns duplex-link-op $n2 $n3 orient right-up
#$ns duplex-link-op $n2 $n4 orient right
#$ns duplex-link-op $n3 $n4 orient right-down
#$ns duplex-link-op $n3 $n5 orient right-down
#$ns duplex-link-op $n4 $n5 orient down


#Monitor the queue for link (n2-n3). (for NAM)
$ns duplex-link-op $n2 $n3 queuePos 0.5


#Setup a TCP connection
#set tcp [new Agent/TCP]
#$tcp set class_ 2
#$ns attach-agent $n0 $tcp
#set sink [new Agent/TCPSink]
#$ns attach-agent $n3 $sink
#$ns connect $tcp $sink
#$tcp set fid_ 1

#Setup a FTP over TCP connection
#set ftp [new Application/FTP]
#$ftp attach-agent $tcp
#$ftp set type_ FTP


#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n3 $udp
set null [new Agent/Null]
$ns attach-agent $n0 $null
$ns connect $udp $null
$udp set fid_ 2

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 0.1mb
$cbr set random_ false


#Schedule events for the CBR and FTP agents
$ns at 0.1 "$cbr start"
#$ns at 1.0 "$ftp start"
#$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

#hat kesilip acilmasi
$ns rtmodel-at 1.0 down $n3 $n1
$ns rtmodel-at 4.0 up $n3 $n1
$ns rtmodel-at 2.0 down $n2
$ns rtmodel-at 4.0 up $n2

#Detach tcp and sink agents (not really necessary)
#$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

#Run the simulation
$ns run

