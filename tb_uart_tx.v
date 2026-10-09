`timescale 1ns/1ps
module tb_uart_tx;
    localparam CPB = 16;
    reg clk = 0, rst = 1, tx_start = 0;
    reg [7:0] tx_data = 8'hA5;
    wire tx, tx_busy;

    uart_tx #(.CLKS_PER_BIT(CPB)) dut (
        .clk(clk), .rst(rst), .tx_start(tx_start),
        .tx_data(tx_data), .tx(tx), .tx_busy(tx_busy)
    );

    always #5 clk = ~clk;

    task sample_bit;
        input expected;
        input [127:0] label_text;
        begin
            if (tx !== expected) begin
                $display("FAIL: %0s expected=%b got=%b",
                         label_text, expected, tx);
                $fatal(1);
            end
            $display("PASS: %0s", label_text);
        end
    endtask

    initial begin
        repeat (3) @(negedge clk);
        rst = 0;
        @(negedge clk);
        tx_start = 1;
        @(negedge clk);
        tx_start = 0;

        // Sample near the middle of the start bit.
        repeat (8) @(negedge clk);
        #1; sample_bit(0, "Start bit");

        // Each data bit lasts 16 clock cycles.
        repeat (16) @(negedge clk);
        #1; sample_bit(1, "Data bit 0");
        repeat (16) @(negedge clk);
        #1; sample_bit(0, "Data bit 1");
        repeat (16) @(negedge clk);
        #1; sample_bit(1, "Data bit 2");
        repeat (16) @(negedge clk);
        #1; sample_bit(0, "Data bit 3");
        repeat (16) @(negedge clk);
        #1; sample_bit(0, "Data bit 4");
        repeat (16) @(negedge clk);
        #1; sample_bit(1, "Data bit 5");
        repeat (16) @(negedge clk);
        #1; sample_bit(0, "Data bit 6");
        repeat (16) @(negedge clk);
        #1; sample_bit(1, "Data bit 7");
        repeat (16) @(negedge clk);
        #1; sample_bit(1, "Stop bit");

        // Wait for the design to return to idle.
        wait (tx_busy === 1'b0);
        $display("PASS: tx_busy returned low.");
        $display("PASS: UART transmission completed.");
        $finish;
    end
endmodule
