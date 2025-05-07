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
            curr_state <= {A, B};

            case ({prev_state, {A, B}})
                // CW Transições válidas
                4'b0001: dir <= 2'b01;
                4'b0111: dir <= 2'b01;
                4'b1110: dir <= 2'b01;
                4'b1000: dir <= 2'b01;

                // CCW Transições válidas
                4'b0010: dir <= 2'b10;
                4'b1011: dir <= 2'b10;
                4'b1101: dir <= 2'b10;
                4'b0100: dir <= 2'b10;

                default: dir <= 2'b00;
            endcase

            prev_state <= curr_state;
        end
    end
endmodule