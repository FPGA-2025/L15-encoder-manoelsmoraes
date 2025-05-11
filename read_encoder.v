module Read_Encoder (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output reg [1:0] dir
);

    reg [1:0] prev_state;
    reg [1:0] curr_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_state <= 2'b00;
            curr_state <= 2'b00;
            dir <= 2'b00;
        end else begin
            curr_state <= {B, A};  // <<==== INVERTIDO para bater com a sequência quadratura

            case ({prev_state, curr_state})
                // CW: 00 → 01 → 11 → 10 → 00
                4'b0001, 4'b0111, 4'b1110, 4'b1000: dir <= 2'b01;
                // CCW: 00 → 10 → 11 → 01 → 00
                4'b0010, 4'b1011, 4'b1101, 4'b0100: dir <= 2'b10;
                default: dir <= 2'b00;
            endcase

            prev_state <= curr_state;
        end
    end

endmodule
