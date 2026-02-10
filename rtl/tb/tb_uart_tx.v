`timescale 1ns / 1ps

module tb_uart_tx;

    reg clk;
    reg rst_n;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx_serial;
    wire tx_busy;

    uart_tx uut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_serial(tx_serial),
        .tx_busy(tx_busy)
    );

    // 50 MHz clock → 20ns period
    always #10 clk = ~clk;

    initial begin
        clk      = 0;
        rst_n    = 0;
        tx_start = 0;
        tx_data  = 8'h00;

        // Reset
        #100;
        rst_n = 1;

        #100;

        // Send 0xA5
        tx_data  = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(tx_busy == 0);

        #10000;

        // Send 0x3C
        tx_data  = 8'h3C;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(tx_busy == 0);

        #100000;

        $stop;
    end

endmodule
