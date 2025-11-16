module clockdivi #(parameter MAX = 50_000_000)(
    input clock,
    input rst,
    output reg clockout
);
    reg [31:0] count = 0;

    always @(posedge clock or posedge rst) begin
        if (rst) begin
            count <= 0;
            clockout <= 0;
        end
        else begin
            if (count >= MAX) begin
                clockout <= ~clockout;
                count <= 0;
            end else
                count <= count + 1;
        end
    end

endmodule
