`timescale 1ns/1ps

module counter4bit_tb;

    // Declaración de señales de estímulo
    reg reset;
    reg load;
    reg enable;
    reg clk;
    
    // Conexiones del DUT
    wire [3:0] count_out;
    wire [3:0] count;
    
    // Registro de verificación
    reg [3:0] new_count;
    
    // Parámetros de estado
    parameter S0 = 8,  S1 = 7,  S2 = 11, S3 = 4,  S4 = 9,  S5 = 2,  S6 = 5, 
              S7 = 12, S8 = 6,  S9 = 3,  S10 = 15, S11 = 1, S12 = 14, S13 = 13;

    // Instanciación del Diseño Bajo Prueba (DUT)
    counter4bit dut (
        .reset     (reset),
        .load      (load),
        .enable    (enable),
        .clk       (clk),
        .count_out (count_out),
        .count     (count)
    );

    // Generador de Reloj (Periodo de 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Bloque Único de Estímulos, Consola y Archivo VCD
    initial begin
        // 1. Configuración de ondas para GTKWave
        $dumpfile("counter4bit_tb.vcd");
        $dumpvars(0, counter4bit_tb);

        // 2. Encabezado didáctico en consola para los alumnos
        $display("\n=== SIMULACIÓN DEL CONTADOR DE 4 BITS CON SECUENCIA PERSONALIZADA ===");
        $display("Tiempo   | Reset | Load | Enable | Count_Out (Estado Actual) | Count (Siguiente)");
        $display("--------------------------------------------------------------------------------");
        
        // El $monitor imprimirá automáticamente cada vez que cambien los estados o controles
        $monitor("%8t ns |   %b   |   %b  |   %b    |        %d (bin:%b)      |     %d", 
                 $time, reset, load, enable, count_out, count_out, count);

        // --- Secuencia Ordenada de Estímulos ---
        reset = 1; load = 0; enable = 0; // Estado inicial en Reset
        #20; 
        
        reset = 0; load = 1; enable = 1; // Activa el conteo síncrono
        #50; 
        
        load = 0;                        // Desactiva carga (Regresa a S0 síncronamente)
        #20; 
        
        load = 1; enable = 0;            // Mantener estado actual deshabilitando el reloj
        #20;
        
        enable = 1;                      // Retoma el conteo normal
        #100;
        
        $display("--------------------------------------------------------------------------------");
        $display("=== SIMULACIÓN FINALIZADA CON ÉXITO ===");
        $finish;
    end

    // Verificación Síncrona Predictiva
    always @(posedge clk) begin
        if (reset) begin
            new_count <= S0;
        end else begin
            case (count_out)
                S0      : new_count <= S1;
                S1      : new_count <= S2;
                S2      : new_count <= S3;
                S3      : new_count <= S4;
                S4      : new_count <= S5;
                S5      : new_count <= S6;
                S6      : new_count <= S7;
                S7      : new_count <= S8;
                S8      : new_count <= S9;
                S9      : new_count <= S10;
                S10     : new_count <= S11;
                S11     : new_count <= S12;
                S12     : new_count <= S13;
                S13     : new_count <= S0;
                default : new_count <= S0;
            endcase
        end    
    end

    // Comparador de banderas de verificación
    always @(posedge clk) begin
        #1; // Retraso de un delta para estabilización de impresión
        if (!reset && enable && load) begin
            if (count == new_count)
                $display("[CHECK] -> VERIFICACIÓN CORRECTA. Siguiente estado esperado: %d", new_count);
            else
                $display("[CHECK] -> ERROR DE TRANSICIÓN. Esperado: %d, Registrado: %d", new_count, count);
        end
    end

endmodule
