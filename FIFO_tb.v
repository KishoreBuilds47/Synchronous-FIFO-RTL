
`timescale 1ns/1ps

module tb_FIFO;

    reg clk;
    reg reset;
    reg read_en;
    reg write_en;
    reg [7:0] write_OP;

    wire [7:0] read_OP;

    integer i;

    FIFO dut (
        .clk(clk),
        .reset(reset),
        .read_en(read_en),
        .write_en(write_en),
        .write_OP(write_OP),
        .read_OP(read_OP)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    // Drive inputs away from the active rising edge
    task fifo_cycle;
        input wr;
        input rd;
        input [7:0] data;
        begin
            @(negedge clk);
            write_en = wr;
            read_en  = rd;
            write_OP = data;
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        clk      = 0;
        reset    = 1;
        read_en  = 0;
        write_en = 0;
        write_OP = 0;

        $display("       FIFO VERIFICATION");
        
        // Test 1: Reset
        repeat (2) @(negedge clk);
        reset = 0;
        @(posedge clk);
        #1;

        if (dut.count !== 0)
            $fatal(1, "FAIL: Reset");

        $display("PASS: Reset");

        // Test 2: Read while empty
        fifo_cycle(0, 1, 8'h00);

        if (dut.count !== 0)
            $fatal(1, "FAIL: Empty read");

        $display("PASS: Empty read protection");

        // Test 3: Write two values
        fifo_cycle(1, 0, 8'hA1);
        fifo_cycle(1, 0, 8'hB2);

        if (dut.count !== 2)
            $fatal(1, "FAIL: Write operations");

        $display("PASS: Write operations");

        // Test 4: FIFO order
        fifo_cycle(0, 1, 8'h00);

        if (read_OP !== 8'hA1)
            $fatal(1, "FAIL: Expected A1, got %h", read_OP);

        fifo_cycle(0, 1, 8'h00);

        if (read_OP !== 8'hB2)
            $fatal(1, "FAIL: Expected B2, got %h", read_OP);

        if (dut.count !== 0)
            $fatal(1, "FAIL: FIFO should be empty");

        $display("PASS: FIFO order");

        // Test 5: Simultaneous read/write while partially filled
        fifo_cycle(1, 0, 8'hC3);
        fifo_cycle(1, 0, 8'hD4);
        fifo_cycle(1, 1, 8'hE5);

        if (read_OP !== 8'hC3)
            $fatal(1, "FAIL: Simultaneous read data");

        if (dut.count !== 2)
            $fatal(1, "FAIL: Simultaneous count");

        fifo_cycle(0, 1, 8'h00);

        if (read_OP !== 8'hD4)
            $fatal(1, "FAIL: Expected D4, got %h", read_OP);

        fifo_cycle(0, 1, 8'h00);

        if (read_OP !== 8'hE5)
            $fatal(1, "FAIL: Expected E5, got %h", read_OP);

        $display("PASS: Simultaneous read/write");

        // Test 6: Fill all eight locations
        for (i = 0; i < 8; i = i + 1)
            fifo_cycle(1, 0, i + 8'h10);

        if (dut.count !== 8)
            $fatal(1, "FAIL: FIFO full");

        $display("PASS: FIFO full condition");

        // Test 7: Write while full must not overflow
        fifo_cycle(1, 0, 8'hFF);

        if (dut.count !== 8)
            $fatal(1, "FAIL: FIFO overflow");

        $display("PASS: Full protection");

        // Test 8: Read all eight values in order
        for (i = 0; i < 8; i = i + 1) begin
            fifo_cycle(0, 1, 8'h00);

            if (read_OP !== (i + 8'h10))
                $fatal(1, "FAIL: Read index %0d, got %h",i, read_OP);
        end

        if (dut.count !== 0)
            $fatal(1, "FAIL: FIFO drain");

        $display("PASS: Full FIFO readback");

        // Test 9: Pointer wraparound
        for (i = 0; i < 12; i = i + 1) begin
            fifo_cycle(1, 0, i);
            fifo_cycle(0, 1, 0);

            if (read_OP !== i[7:0])
                $fatal(1, "FAIL: Wraparound at index %0d", i);
        end

        $display("PASS: Pointer wraparound");

        $display("ALL TESTS PASSED!");

        $finish;
    end

endmodule
