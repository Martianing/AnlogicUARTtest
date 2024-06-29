`timescale 1ns / 1ps

module uart_top_tb;

    reg clk;
    reg RSTn;
    reg RX_Pin_In;
    wire TX_Pin_Out;
    wire [7:0] LED_Out;

    // Instantiate the uart_top module
    uart_top uut (
        .clk(clk),
        .RSTn(RSTn),
        .RX_Pin_In(RX_Pin_In),
        .TX_Pin_Out(TX_Pin_Out),
        .LED_Out(LED_Out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end

    initial begin
        // Initialize inputs
        RSTn = 0;
        RX_Pin_In = 1;

        // Apply reset
        #200;
        RSTn = 1;

        // Simulate UART data reception
        // Send a byte: 0xA5 (10100101)
        // UART frame: 1 start bit (0), 8 data bits (LSB first), 1 stop bit (1)
        
        // Start bit
        RX_Pin_In = 0;
        #(104167); // 9600 baud, 1 bit period = 1/9600s ≈ 104.17us

        // Data bits (LSB first)
        RX_Pin_In = 1; // bit 0
        #(104167);
        RX_Pin_In = 0; // bit 1
        #(104167);
        RX_Pin_In = 1; // bit 2
        #(104167);
        RX_Pin_In = 0; // bit 3
        #(104167);
        RX_Pin_In = 0; // bit 4
        #(104167);
        RX_Pin_In = 1; // bit 5
        #(104167);
        RX_Pin_In = 0; // bit 6
        #(104167);
        RX_Pin_In = 1; // bit 7
        #(104167);

        // Stop bit
        RX_Pin_In = 1;
        #(104167);

        // Wait for transmission to complete
        #10000000;

        // Finish simulation
        $stop;
    end

    // Monitor
    initial begin
        $monitor("Time=%t | RX_Pin_In=%h | TX_Pin_Out=%h | LED_Out=%b | rx_done=%b | data = %h | TX_Done_Sig = %b", 
                 $time, RX_Pin_In, TX_Pin_Out, LED_Out, uut.u_rx_top.RX_Done_Sig,uut.data,uut.TX_Done_Sig);
    end

endmodule
