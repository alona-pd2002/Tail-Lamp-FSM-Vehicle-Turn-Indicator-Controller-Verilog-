module tail_lamp(
    input LEFT,           // Left turn request
    input RIGHT,          // Right turn request
    input EMERGENCY,      // Hazard mode
    input CLK,            // 100MHz clock
    input RST,            // Reset button
    output reg [5:0] led  // 6 LEDs: [5:3]=Left, [2:0]=Right
);

    // =====================================================
    // SLOW CLOCK GENERATION (2 Hz normal, 4 Hz emergency)
    // =====================================================

    wire clk_slow;

    // DIVIDE 100 MHz to 2 Hz output
    clockdivi #(26'd50_000_000) clkdiv_inst (
        .clock(CLK),
        .rst(RST),
        .clockout(clk_slow)
    );

    // =====================================================
    // INTERNAL STATE REGISTERS
    // =====================================================

    reg [1:0] seq = 0;           // sequence counter: 0,1,2,3
    reg dir = 0;                 // direction flag for emergency

    // =====================================================
    // MAIN STATE MACHINE
    // =====================================================

    always @(posedge clk_slow or posedge RST) begin
        if (RST) begin
            seq <= 0;
            dir <= 0;
        end

        else if (EMERGENCY) begin
            // Bidirectional pattern: 0,1,2,3,2,1,0...
            if (!dir)
                seq <= seq + 1;
            else
                seq <= seq - 1;

            if (seq == 2) dir <= 1;
            else if (seq == 1) dir <= 0;
        end

        else if (LEFT) begin
            seq <= seq + 1;
            if (seq == 3) seq <= 0;
        end

        else if (RIGHT) begin
            seq <= seq + 1;
            if (seq == 3) seq <= 0;
        end

        else begin
            seq <= 0;
        end
    end

    // =====================================================
    // LED OUTPUT LOGIC
    // =====================================================

    always @(*) begin
        if (RST)
            led = 6'b000000;

        // EMERGENCY MODE: both sides flash together
        else if (EMERGENCY) begin
            case (seq)
                2'd0: led = 6'b000000;
                2'd1: led = 6'b100001;
                2'd2: led = 6'b110011;
                2'd3: led = 6'b111111;
                default: led = 6'b000000;
            endcase
        end

        // LEFT TURN ONLY
        else if (LEFT) begin
            case (seq)
                2'd0: led = 6'b000000;
                2'd1: led = 6'b100000;
                2'd2: led = 6'b110000;
                2'd3: led = 6'b111000;
                default: led = 6'b000000;
            endcase
        end

        // RIGHT TURN ONLY
        else if (RIGHT) begin
            case (seq)
                2'd0: led = 6'b000000;
                2'd1: led = 6'b000001;
                2'd2: led = 6'b000011;
                2'd3: led = 6'b000111;
                default: led = 6'b000000;
            endcase
        end

        else
            led = 6'b000000;
    end

endmodule
