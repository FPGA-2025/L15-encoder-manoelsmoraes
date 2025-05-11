module Encoder (
    input wire clk,
    input wire rst_n,
    input wire horario,
    input wire antihorario,
    output reg A,
    output reg B
);

    // Estados codificados
    parameter S00 = 2'b00;
    parameter S01 = 2'b01;
    parameter S11 = 2'b11;
    parameter S10 = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S00;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;

        if (horario && !antihorario) begin
            case (state)
                S00: next_state = S01;
                S01: next_state = S11;
                S11: next_state = S10;
                S10: next_state = S00;
            endcase
        end else if (antihorario && !horario) begin
            case (state)
                S00: next_state = S10;
                S10: next_state = S11;
                S11: next_state = S01;
                S01: next_state = S00;
            endcase
        end
    end

    // Atualiza A e B com base no estado atual
    always @(*) begin
        case (state)
            S00: begin A = 0; B = 0; end
            S01: begin A = 0; B = 1; end
            S11: begin A = 1; B = 1; end
            S10: begin A = 1; B = 0; end
            default: begin A = 0; B = 0; end
        endcase
    end

endmodule
