BEGIN {
	     recvdSize = 0
	     startTime = 1e6
	     stopTime = 0
	}
	{
           event = $1
           time = $2
           flow_id = $8
           pkt_id = $12
           pkt_size = $6
           flow_t = $5
           src = $3
           dst = $4
           level = "AGT"

	# DropTail TCP
	if (level == "AGT" && event == "-" && src == 1 && dst == 0 && flow_t == "tcp" && pkt_size>= 50) {
		droptail_tcp[int(time*10+1)]+=pkt_size
	     }

	# DropTail UDP
	if (level == "AGT" && event == "-" && src == 1 && dst == 0 && flow_t == "cbr" && pkt_size>= 50) {
		droptail_udp[int(time*10+1)]+=pkt_size
	     }

	# RED TCP
	if (level == "AGT" && event == "-" && src == 5 && dst == 4 && flow_t == "tcp" && pkt_size>= 50) {
		RED_tcp[int(time*10+1)]+=pkt_size
	     }

	# RED UDP
	if (level == "AGT" && event == "-" && src == 5 && dst == 4 && flow_t == "cbr" && pkt_size>= 50) {
		RED_udp[int(time*10+1)]+=pkt_size
	     }

	# FQ TCP
	if (level == "AGT" && event == "-" && src == 9 && dst == 8 && flow_t == "tcp" && pkt_size>= 50) {
		FQ_tcp[int(time*10+1)]+=pkt_size
	     }

	# FQ UDP
	if (level == "AGT" && event == "-" && src == 9 && dst == 8 && flow_t == "cbr" && pkt_size>= 50) {
		FQ_udp[int(time*10+1)]+=pkt_size
	     }


	}

	END {

		for (i=1; i<=100; i++) {
			print i",", droptail_tcp[i]",", droptail_udp[i]",", RED_tcp[i]",", RED_udp[i]",", FQ_tcp[i]",", FQ_udp[i]","
		}



#		print "DropTail TCP"
#		for (i in droptail_tcp) {
#			print i, droptail_tcp[i]
#		}
#
#		print "DropTail UDP"
#		for (i in droptail_udp) {
#			print i, droptail_udp[i]
#		}
#
#		print "RED TCP"
#		for (i in RED_tcp) {
#			print i, RED_tcp[i]
#		}
#
#		print "RED UDP"
#		for (i in RED_udp) {
#			print i, RED_udp[i]
#		}
#
#		print "FQ TCP"
#		for (i in FQ_tcp) {
#			print i, FQ_tcp[i]
#		}
#
#		print "FQ UDP"
#		for (i in FQ_udp) {
#			print i, FQ_udp[i]
#		}

	}
