module LED_display_module
(
	CLK, RSTn, RX_Done_Sig, RX_Data, LED_Out, 
);
     input CLK;
     input RSTn;	 
	  input RX_Done_Sig;
	  input [7:0]RX_Data;
	   
     output [7:0]LED_Out;
	 
	  reg [7:0]rLED_Out;

	 always @ ( posedge CLK or negedge RSTn )
		if( !RSTn ) 
			rLED_Out <= 'd0;	 	
		else if( RX_Done_Sig == 1 )
			rLED_Out <= RX_Data;
		else 
			rLED_Out <= rLED_Out;
			
	assign LED_Out = rLED_Out;
	
endmodule