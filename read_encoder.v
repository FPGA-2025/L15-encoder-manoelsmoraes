module Read_Encoder (
    input wire clk,            // Clock do sistema
    input wire rst_n,          // Reset síncrono (ativo baixo)
    input wire A,              // Sinal A (quadratura)
    input wire B,              // Sinal B (quadratura)
    output reg [1:0] dir       // Direção detectada: 00 → sem movimento, 01 → horário, 10 → anti-horário
);

    reg A_d, B_d;  // Valores anteriores de A e B

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset: sem movimento
            dir <= 2'b00;
            A_d <= 0;
            B_d <= 0;
        end else begin
            // Detectando mudanças nos sinais A e B
            if (A != A_d || B != B_d) begin
                // Detecção de movimento horário
                if (A_d == 0 && B_d == 0 && A == 1 && B == 0) begin
                    dir <= 2'b01;  // Sentido horário
                end
                // Detecção de movimento anti-horário
                else if (A_d == 0 && B_d == 0 && A == 0 && B == 1) begin
                    dir <= 2'b10;  // Sentido anti-horário
                end
                else begin
                    dir <= 2'b00;  // Sem movimento
                end
            end
        end

        // Atualizando os valores anteriores
        A_d <= A;
        B_d <= B;
    end

endmodule
