module lfsr_tb;

reg reset, clk;
wire [3:0]data_out;
reg [3:0]new_out;
wire new_bit;


lfsr dut (
         .reset(reset),
         .clk(clk),
         .data_out(data_out)
         );

initial begin
   clk = 0;
   forever #5 clk = ~clk;
end

initial begin
   reset = 1;
   #20 reset = 0;
   #400 $finish;
end
// Modelo de referencia combinacional
assign new_bit = new_out[1] ^ new_out[0];

// Bloque Principal de Estímulos y Verificación
    initial begin
        // 1. Archivo VCD para GTKWave / TerosHDL
        $dumpfile("lfsr_tb.vcd");
        $dumpvars(0, lfsr_tb);

        // 2. Encabezado en consola
        $display("\n=== INICIANDO SIMULACIÓN LFSR DE 4 BITS ===");
        $display("Tiempo | Reset |   DUT (data_out)  |  Esperado (new_out)  | Estado");
        $display("------------------------------------------------------------------");

        // 3. Estímulos de Reset y finalización
        reset = 1;
        #20;
        reset = 0;

        #400;
        $display("------------------------------------------------------------------");
        $display("=== SIMULACIÓN FINALIZADA CON ÉXITO ===");
        $finish;
    end
// Proceso de verificación y actualización del modelo de referencia
always @(posedge clk) begin
        if (reset) begin
            new_out <= 4'b0001;
        end else begin
            new_out <= {new_bit, new_out[3:1]};
        end

        // Muestreamos la comparación tras un pequeño retardo para dejar estabilizar los Flip-Flops
        #1;
        if (new_out == data_out) begin
            $display("%70t ps |   %b   |    %b (%2d)     |     %b (%2d)       | [PASS]", 
                     $time, reset, data_out, data_out, new_out, new_out);
        end else begin
            $display("%70t ps |   %b   |    %b (%2d)     |     %b (%2d)       | [FAIL]", 
                     $time, reset, data_out, data_out, new_out, new_out);
        end
    end

endmodule
