module Encoder (
    input wire clk,            // Clock do sistema
    input wire rst_n,          // Reset síncrono (ativo baixo)
    input wire horario,        // Sinal para rotação no sentido horário
    input wire antihorario,    // Sinal para rotação no sentido anti-horário
    output reg A,              // Sinal A (quadratura)
    output reg B               // Sinal B (quadratura)
);

    // Definindo estados de quadratura
    parameter CW_00 = 2'b00,    // Estado inicial
              CW_10 = 2'b01,    // Sentido horário
              CW_11 = 2'b11,
              CW_01 = 2'b10;

    parameter CCW_00 = 2'b00,   // Sentido anti-horário
              CCW_01 = 2'b10,
              CCW_11 = 2'b11,
              CCW_10 = 2'b01;

    reg [1:0] state;           // Estado interno (2 bits)

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset: retorna para o estado inicial (00)
            state <= CW_00;
            A <= 0;
            B <= 0;
        end else begin
            if (horario && !antihorario) begin
                // Sentido horário
                case (state)
                    CW_00: begin state <= CW_10; A <= 1; B <= 0; end
                    CW_10: begin state <= CW_11; A <= 1; B <= 1; end
                    CW_11: begin state <= CW_01; A <= 0; B <= 1; end
                    CW_01: begin state <= CW_00; A <= 0; B <= 0; end
                    default: state <= CW_00;
                endcase
            end else if (antihorario && !horario) begin
                // Sentido anti-horário
                case (state)
                    CCW_00: begin state <= CCW_01; A <= 0; B <= 1; end
                    CCW_01: begin state <= CCW_11; A <= 1; B <= 1; end
                    CCW_11: begin state <= CCW_10; A <= 1; B <= 0; end
                    CCW_10: begin state <= CCW_00; A <= 0; B <= 0; end
                    default: state <= CCW_00;
                endcase
            end
        end

        // Adicionando depuração para ver as transições
        $display("CLK=%0t, rst_n=%b, horario=%b, antihorario=%b, A=%b, B=%b, state=%b", 
                  $time, rst_n, horario, antihorario, A, B, state);
    end
endmodule
