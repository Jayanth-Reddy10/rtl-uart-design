`timescale 1ns / 1ps

module tb_uart_rx;

    reg clk;
    reg rst_n;
    reg rx_serial;

    wire [7:0] rx_data;
    wire rx_done;

    uart_rx uut (
        .clk(clk),
        .rst_n(rst_n),
        .rx_serial(rx_serial),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 50 MHz clock (20ns period)
    always #10 clk = ~clk;

    // Bit time for 9600 baud
    localparam BIT_TIME = 104000;  // ~104us

    initial begin
        clk = 0;
        rst_n = 0;
        rx_serial = 1;  // idle line high

        #100;
        rst_n = 1;

        #100;

        // Send 0xA5 (10100101)
        // Start bit
        rx_serial = 0;
        #(BIT_TIME);

        // Data bits LSB first
        rx_serial = 1; #(BIT_TIME); // bit0
        rx_serial = 0; #(BIT_TIME); // bit1
        rx_serial = 1; #(BIT_TIME); // bit2
        rx_serial = 0; #(BIT_TIME); // bit3
        rx_serial = 0; #(BIT_TIME); // bit4
        rx_serial = 1; #(BIT_TIME); // bit5
        rx_serial = 0; #(BIT_TIME); // bit6
        rx_serial = 1; #(BIT_TIME); // bit7

        // Stop bit
        rx_serial = 1;
        #(BIT_TIME);

        #200000;

        $stop;
    end

endmodule
