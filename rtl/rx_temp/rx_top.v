module rx_top
(
    input        CLK, 
	input        RSTn, 
	input        RX_Pin_In, 
	input        RX_En_Sig, 
	output [7:0] LED_Out,
	output [7:0] RX_Data,
	output RX_Done_Sig   //synthesis keep;
);


	 wire neg_sig; //synthesis keep;
	 wire BPS_CLK; //synthesis keep;
	 wire Count_Sig;  //synthesis keep;
 
	 
	reg CLK_500K; //synthesis keep;
	reg[9:0] cnt2;

	//产生500K时钟
	always @ (posedge CLK or negedge RSTn)	
		if(!RSTn) 
		  begin
			  cnt2 <= 10'd0;
			  CLK_500K <= 1'b0;
		  end
		else if(cnt2 == 10'd49) 
		  begin
			  cnt2 <= 10'd0;
			  CLK_500K <= ~CLK_500K;
		  end
		else cnt2 <= cnt2+1'b1;
	 
	/**********************************/
	 
	detect_module U1
	(
	   .CLK( CLK_500K ),
		.RSTn( RSTn ),
		.RX_Pin_In( RX_Pin_In ),    // input - from top
		.neg_sig( neg_sig ) 			// output - to U3
	);
	
   /**********************************/

	rx_bps_module U2
	(
	   .CLK( CLK_500K ),
		.RSTn( RSTn ),
		.Count_Sig( Count_Sig ),   // input - from U3
	   .BPS_CLK( BPS_CLK )        // output - to U3
	);	 
	
   /**********************************/
		 
	rx_control_module U3
	(
		.CLK( CLK_500K ),
	   .RSTn( RSTn ),
			  
		.neg_sig( neg_sig ),      // input - from U1
		.RX_En_Sig( RX_En_Sig ),  // input - from top
		.RX_Pin_In( RX_Pin_In ),  // input - from top
		.BPS_CLK( BPS_CLK ),      // input - from U2
			  
	   .Count_Sig( Count_Sig ),    // output - to U2
		.RX_Data( RX_Data ),        // output - to U4
		.RX_Done_Sig( RX_Done_Sig ) // output - to U4		  
	 );
	 
	/************************************/
	 
	LED_display_module U4
	(
		.CLK( CLK_500K ) ,	
		.RSTn( RSTn ) ,	
		.RX_Done_Sig( RX_Done_Sig ) ,	// input - from U3 
		.RX_Data( RX_Data ) ,	// input - from U3
		.LED_Out( LED_Out ) 	// output - to top
	);
	  
	/************************************/
	
	


	 	 
endmodule
