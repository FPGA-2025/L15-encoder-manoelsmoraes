module Read_Encoder (
    input wire clk,
    input wire rst_n,

    input wire A,
    input wire B,

    output reg [1:0] dir
);
    reg [1:0] prev;  // Estado anterior para detectar as transições

    always @(posedge clk) begin
        if (!rst_n) begin
            prev <= 2'b00;
            dir  <= 2'b00;  // Resetando a direção durante o reset
        end else begin
            case ({prev, A, B})
                4'b00_10,  // Detecta a rotação no sentido horário
                4'b10_11,
                4'b11_01,
                4'b01_00: dir <= 2'b01;  

                4'b00_01,  // Detecta a rotação no sentido anti-horário
                4'b01_11,
                4'b11_10,
                4'b10_00: dir <= 2'b10;  

                default:  dir <= 2'b00;  // Caso não detectado, nenhuma direção
            endcase

            prev <= {A, B};  // Atualiza o estado anterior com as entradas A e B
        end
    end
endmodule
