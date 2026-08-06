`timescale 1ns/1ps

module dff_async_tb;

   // Declaración de señales
   reg  d, clk, reset;
   wire q, qb;

   // Instanciación del DUT (D Flip-Flop Asíncrono)
   dff_async dut (
      .i_d   (d),
      .clk   (clk),
      .reset (reset),
      .o_q   (q),
      .o_qb  (qb)
   );

   // Generador de Reloj (Período = 2 unidades de tiempo)
   initial begin
      clk = 1'b0;
      forever #1 clk = ~clk;
   end

   // Bloque Principal de Estímulos y Verificación
   initial begin
      // 1. Configuración de volcado VCD para GTKWave / TerosHDL
      $dumpfile("dff_async_tb.vcd");
      $dumpvars(0, dff_async_tb);

      // 2. Encabezado en Consola
      $display("\n=== INICIANDO SIMULACIÓN FLIP-FLOP D ASÍNCRONO ===");
      $display("Tiempo | clk | reset | d | q | qb | Estado");
      $display("--------------------------------------------------");

      // 3. Ejecución de pruebas aleatorias
      repeat (100) begin
         stimulus();
         
         // Evaluación con retardo estratégico para evitar condiciones de carrera en lectura
         #0.1;
         if (reset == 1) begin
            if (q == 1'b0 && qb == 1'b1)
               $display("%6t ps |  %b  |   %b   | %b | %b | %b  | [PASS - RESET ACTIVE]", $time, clk, reset, d, q, qb);
            else
               $display("%6t ps |  %b  |   %b   | %b | %b | %b  | [FAIL - RESET ERROR]",  $time, clk, reset, d, q, qb);
         end else begin
            if (q == d && qb == ~d)
               $display("%6t ps |  %b  |   %b   | %b | %b | %b  | [PASS]", $time, clk, reset, d, q, qb);
            else
               $display("%6t ps |  %b  |   %b   | %b | %b | %b  | [FAIL]", $time, clk, reset, d, q, qb);
         end
      end

      $display("--------------------------------------------------");
      $display("=== SIMULACIÓN FINALIZADA ===");
      $finish;
   end

   // Task para generación aleatoria de entradas
   task stimulus;
      begin
         d = $random; 
         reset = $random;
         #5; // Mantiene el estímulo durante 5 unidades de tiempo
      end
   endtask

endmodule