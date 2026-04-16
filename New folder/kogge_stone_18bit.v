`timescale 1ns/1ps
module kogge_stone_18bit (
    input  [17:0] x,
    input  [17:0] y,
    output [17:0] sum
);

    wire [17:0] g0, p0;
    wire [17:0] g1, p1;
    wire [17:0] g2, p2;
    wire [17:0] g3, p3;
    wire [17:0] g4, p4;
    wire [17:0] g5, p5; // Stage 5 added for 18-bit carry propagation

    // Stage 0 (Generate & Propagate)
    assign g0 = x & y;
    assign p0 = x ^ y;

    // Stage 1 (distance = 1)
    genvar i;
    generate
        for(i = 0; i < 18; i = i + 1) begin
            if(i == 0) begin
                assign g1[i] = g0[i];
                assign p1[i] = p0[i];
            end else begin
                assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
                assign p1[i] = p0[i] & p0[i-1];
            end
        end
    endgenerate

    // Stage 2 (distance = 2)
    generate
        for(i = 0; i < 18; i = i + 1) begin
            if(i < 2) begin
                assign g2[i] = g1[i];
                assign p2[i] = p1[i];
            end else begin
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
                assign p2[i] = p1[i] & p1[i-2];
            end
        end
    endgenerate

    // Stage 3 (distance = 4)
    generate
        for(i = 0; i < 18; i = i + 1) begin
            if(i < 4) begin
                assign g3[i] = g2[i];
                assign p3[i] = p2[i];
            end else begin
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
                assign p3[i] = p2[i] & p2[i-4];
            end
        end
    endgenerate

    // Stage 4 (distance = 8)
    generate
        for(i = 0; i < 18; i = i + 1) begin
            if(i < 8) begin
                assign g4[i] = g3[i];
                assign p4[i] = p3[i];
            end else begin
                assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
                assign p4[i] = p3[i] & p3[i-8];
            end
        end
    endgenerate

    // Stage 5 (distance = 16) - FIXED
    generate
        for(i = 0; i < 18; i = i + 1) begin
            if(i < 16) begin
                assign g5[i] = g4[i];
                assign p5[i] = p4[i];
            end else begin
                assign g5[i] = g4[i] | (p4[i] & g4[i-16]);
                assign p5[i] = p4[i] & p4[i-16];
            end
        end
    endgenerate

    // Carry calculation
    wire [18:0] c;
    assign c[0] = 1'b0;

    generate
        for(i = 0; i < 18; i = i + 1) begin
            assign c[i+1] = g5[i]; // Updated to use Stage 5
        end
    endgenerate

    // Final Sum
    assign sum = p0 ^ c[17:0];

endmodule
