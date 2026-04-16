`timescale 1ns/1ps
module csa_kogge_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    output [17:0] final_sum
);

    wire [15:0] save_sum;
    wire [15:0] save_carry;

    // =========================
    // 🔹 CSA Stage
    // =========================
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : csa_stage
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(save_sum[i]),
                .cout(save_carry[i])
            );
        end
    endgenerate

    // =========================
    // 🔹 Kogge-Stone Stage
    // =========================
    wire [17:0] x = {2'b00, save_sum};
    wire [17:0] y = {1'b0, save_carry, 1'b0};

    kogge_stone_18bit ksa (
        .x(x),
        .y(y),
        .sum(final_sum)
    );

endmodule
