`timescale 1ns/1ps

module alu_tb;  

    // Declaración de señales para el DUT
    reg  [3:0] a, b;
    reg  [1:0] select;
    wire [3:0] out;
    wire       zero, carry, sign, parity, overflow;

    // Registro de referencia para verificación
    reg [3:0] new_out;
    reg       expected_carry;

    // Instanciación del módulo ALU (DUT)
    alu dut (
        .a        (a),  
        .b        (b),  
        .select   (select),  
        .zero     (zero),  
        .carry    (carry),  
        .sign     (sign),  
        .parity   (parity),  
        .overflow (overflow),  
        .out      (out)             
    );

    // Bloque Principal de Estímulos y Verificación
    initial begin
        // Configuración para GTKWave / TerosHDL
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        $display("\n=== INICIANDO SIMULACIÓN DE LA ALU (4 BITS) ===");

        repeat (200) begin
            // Llamamos a la tarea pasando los argumentos de salida
            stimulus(a, b, select, new_out, expected_carry); 
            #5; // Tiempo para estabilización combinacional

            // Evaluación
            if (new_out == out && expected_carry == carry) begin
                $display("[PASS] | Op:%b | a:%b | b:%b | ALU_out:%b | Carry:%b | PASSED",
                         select, a, b, out, carry);
            end else begin
                $display("[FAIL] | Op:%b | a:%b | b:%b | ALU_out:%b (Esperado:%b) | Carry:%b (Esperado:%b) | FAILED",
                         select, a, b, out, new_out, carry, expected_carry);
            end
        end

        $display("=== SIMULACIÓN FINALIZADA ===");
        $finish;
    end

    // Tarea con argumentos explícitos de entrada/salida (Compatibilidad estándar Verilog)
    task stimulus;
        output [3:0] out_a;
        output [3:0] out_b;
        output [1:0] out_sel;
        output [3:0] exp_out;
        output       exp_carry;
        begin
            out_a   = $random;
            out_b   = $random;
            out_sel = $random;

            // Evitamos división entre cero
            if (out_sel == 2'b11 && out_b == 4'b0000) begin
                out_b = 4'b0001;
            end

            // Cálculo del resultado esperado
            case (out_sel)
                2'b00: {exp_carry, exp_out} = out_a + out_b;
                2'b01: {exp_carry, exp_out} = out_a - out_b;
                2'b10: {exp_carry, exp_out} = out_a * out_b;
                2'b11: {exp_carry, exp_out} = out_a / out_b;
            endcase
        end
    endtask

endmodule