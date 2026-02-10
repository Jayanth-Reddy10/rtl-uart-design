`timescale 1ns / 1ps

module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx_serial,
    output reg        tx_busy
);

    wire baud_tick;

    baud_gen baud_inst (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick)
    );

    localparam IDLE  = 2'd0,
               START = 2'd1,
               DATA  = 2'd2,
               STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx_serial <= 1'b1;   // idle line HIGH
            tx_busy   <= 1'b0;
            bit_cnt   <= 0;
            data_reg  <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    tx_serial <= 1'b1;
                    tx_busy   <= 1'b0;

                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy  <= 1'b1;
                        state    <= START;
                    end
                end

                START: begin
                    if (baud_tick) begin
                        tx_serial <= 1'b0;  // start bit
                        bit_cnt   <= 0;
                        state     <= DATA;
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        tx_serial <= data_reg[bit_cnt];

                        if (bit_cnt == 3'd7)
                            state <= STOP;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        tx_serial <= 1'b1;  // stop bit
                        state     <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
