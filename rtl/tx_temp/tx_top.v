module tx_top
(
    input       CLK, 
    inout       RSTn, 
    input [7:0] TX_Data,    //the data recived to transmit
    input       TX_En_Sig,  //begin transmit data signal

    // output      TX_Done_Sig,
    output      TX_Pin_Out       //pin to TOP module and will use it to send the data to the computer
);
 
 
	wire BPS_CLK; //synthesis keep;

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
	// data_control_module U1
	// (
	// 	.CLK( CLK_500K ) ,	
	// 	.RSTn( RSTn ) ,	
	// 	.TX_Done_Sig( TX_Done_Sig ) ,	// input - from U3
	// 	.TX_En_Sig( TX_En_Sig ) ,	// output - to U2, U3
	// 	.TX_Data( TX_Data ) 	// output - to U3
	// );

    wire TX_Done_Sig;
    reg isTX;
    wire tx_en;

	reg [31:0]Count;
	
	parameter T05S = 32'd250_000;
			
	always @ ( posedge CLK_500K or negedge RSTn )
		begin
			if( !RSTn )
				begin
					isTX <= 0;
					// i <= 'd5;
				end
			else if( TX_Done_Sig == 1 )
				begin
					isTX <= 0;
					Count <= Count + 1'b1;
				end
			else if ( Count == T05S - 1 )
				begin
					isTX <= 1'b1;
					Count <= 0;
					// if( i == 'd5 )
					// 	i <= 0;
					// else 
					// 	i <= i +1'b1;  
				end
			else 
				Count <= Count + 1'b1; 
		end
	
	assign tx_en = isTX;
	  
   tx_bps_module U1
	(
	   .CLK( CLK_500K ),
	   .RSTn( RSTn ),
	   .Count_Sig( 1),    // input - from other modules
	   .BPS_CLK( BPS_CLK )         // output - to U2
	);



	tx_control_module U2
	(
		.CLK( CLK_500K ) ,	
		.RSTn( RSTn ) ,	
		.TX_En_Sig(tx_en) ,	// input - from other modules
		.BPS_CLK( BPS_CLK ) ,	// input - from U1
		.TX_Data( TX_Data ) ,	// input - from other modules
		.TX_Done_Sig( TX_Done_Sig ) ,	// output - to U1
		.TX_Pin_Out( TX_Pin_Out ) 	// output - to top 
	);



endmodule
