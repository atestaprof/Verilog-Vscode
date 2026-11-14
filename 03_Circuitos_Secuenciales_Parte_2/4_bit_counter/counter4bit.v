`timescale 1ns/1ps

module counter4bit(
    input            reset,
    input            load,
    input            enable,
    input            clk,
    output reg [3:0] count_out,
    output reg [3:0] count
);

    // Parámetros de los estados/valores del contador
    parameter S0 = 8,  S1 = 7,  S2 = 11, S3 = 4,  S4 = 9,  S5 = 2,  S6 = 5, 
              S7 = 12, S8 = 6,  S9 = 3,  S10 = 15, S11 = 1, S12 = 14, S13 = 13;

    // Bloque 1: Registro secuencial para count_out (Único lugar donde se asigna)
    always @(posedge clk or posedge reset) begin
        if (reset)
            count_out <= S0;
        else if (enable)
            count_out <= count; // Solo se actualiza si está habilitado
    end

    // Bloque 2: Lógica combinacional/secuencial para calcular el siguiente estado ('count')
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= S0;
        end else begin
            if (!load) begin
                count <= S0;
            end else if (enable) begin
                case (count_out)
                    S0      : count <= S1;
                    S1      : count <= S2;
                    S2      : count <= S3;
                    S3      : count <= S4;
                    S4      : count <= S5;
                    S5      : count <= S6;
                    S6      : count <= S7;
                    S7      : count <= S8;
                    S8      : count <= S9;
                    S9      : count <= S10;
                    S10     : count <= S11;
                    S11     : count <= S12;
                    S12     : count <= S13;
                    S13     : count <= S0;
                    default : count <= S0;
                endcase
            end
        end
    end            

endmodule
