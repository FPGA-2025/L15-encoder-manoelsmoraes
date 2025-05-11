module Encoder (
    input wire clk,
    input wire rst_n,

    input wire horario,
    input wire antihorario,

    output reg A,
    output reg B
);
    reg [1:0] state;  // Controle de estado de 2 bits para o encoder

    // Máquina de estados para o Encoder
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 2'b00;  // Estado inicial após o reset
        end else begin
            if (horario && !antihorario) begin
                case (state)
                    2'b00: state <= 2'b10; // Roda para o sentido horário
                    2'b10: state <= 2'b11;
                    2'b11: state <= 2'b01;
                    2'b01: state <= 2'b00;
                    default: state <= 2'b00;  // Garantir um estado válido
                endcase
            end else if (antihorario && !horario) begin
                case (state)
                    2'b00: state <= 2'b01; // Roda para o sentido anti-horário
                    2'b01: state <= 2'b11;
                    2'b11: state <= 2'b10;
                    2'b10: state <= 2'b00;
                    default: state <= 2'b00;  // Garantir um estado válido
                endcase
            end
        end
    end

    // Geração das saídas A e B com base no estado
    always @(*) begin
        A = state[1];  // A é o bit mais significativo do estado
        B = state[0];  // B é o bit menos significativo do estado
    end
endmodule
