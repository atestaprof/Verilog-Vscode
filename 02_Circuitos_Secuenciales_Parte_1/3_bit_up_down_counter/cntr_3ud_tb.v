`timescale 1ns/1ps

module cntr_3ud_tb;

    // 1. Declaración de señales de estímulo y monitoreo
    reg        clk;
    reg        reset;
    reg        up_down;
    
    wire [2:0] q;
    wire [2:0] nq;

    // 2. Instanciación del módulo (DUT)
    cntr_3ud cntr_3ud_inst (
        .clk     (clk),
        .reset   (reset),
        .up_down (up_down),
        .q       (q),
        .nq      (nq)
    );

    // 3. Generador de Reloj Sencillo (Periodo de 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // 4. Bloque Único de Estímulos, Monitoreo y Archivo VCD
    initial begin
        // Configuración para GTKWave
        $dumpfile("cntr_3ud_tb.vcd");
        $dumpvars(0, cntr_3ud_tb);

        // Imprime una cabecera estética en la consola para los alumnos
        $display("\n=== INICIANDO SIMULACIÓN DEL CONTADOR UP/DOWN DE 3 BITS ===");
        $display("Tiempo | Reset | Up_Down | Salida Q | Salida NQ (Complementaria)");
        $display("------------------------------------------------------------");
        
        // El comando $monitor se ejecuta automáticamente cada vez que cambie alguna de estas señales
        $monitor("%50t ns |   %b   |    %b    |   %b   |   %b", $time, reset, up_down, q, nq);

        // --- CASO 1: Condición de Reset Inicial ---
        reset = 1; up_down = 1;
        #20; // Esperamos 2 ciclos de reloj completos

        // --- CASO 2: Conteo Ascendente (Up) ---
        reset = 0; up_down = 1;
        #80; // Esperamos 8 ciclos de reloj para ver el ciclo completo (de 0 a 7)

        // --- CASO 3: Conteo Descendente (Down) ---
        up_down = 0;
        #80; // Esperamos otros 8 ciclos de reloj para ver el decremento

        // --- CASO 4: Reset sobre la marcha ---
        reset = 1;
        #20;

        $display("------------------------------------------------------------");
        $display("=== SIMULACIÓN FINALIZADA CON ÉXITO ===");
        $finish;
    end

endmodule
