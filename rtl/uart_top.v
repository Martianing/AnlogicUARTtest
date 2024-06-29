module uart_top(
    input   clk,
    input   RSTn,
    input   RX_Pin_In,		//F12
	 
    output  TX_Pin_Out,
	output  [7:0]LED_Out		//LED7-LED0
);

wire [7:0] data;
wire rx_done;   //synthesis keep;
rx_top u_rx_top(
    .CLK(clk), 
    .RSTn(RSTn), 
    .RX_Pin_In(RX_Pin_In), 
    .RX_En_Sig(1), 
    .RX_Data(data),
    .RX_Done_Sig(rx_done),
    .LED_Out(LED_Out)
);

wire tx_en;
wire TX_Done_Sig;
tx_top u_tx_top(
    .CLK(clk), 
    .RSTn(RSTn), 
    // .TX_En_Sig(tx_en),
    .TX_Data(data), 
    // .TX_Done_Sig(TX_Done_Sig),   
    .TX_Pin_Out(TX_Pin_Out)  
);

// reg tx_en_reg;

// always @(posedge clk or negedge RSTn) begin
//     if (!RSTn)
//         tx_en_reg <= 1'b0;
//     else if (rx_done)
//         tx_en_reg <= 1'b1;
//     else
//         tx_en_reg <= 1'b0;
// end

// assign tx_en = tx_en_reg;
// assign tx_en = (data & rx_done & TX_Done_Sig) ? 1 : 0;




endmodule