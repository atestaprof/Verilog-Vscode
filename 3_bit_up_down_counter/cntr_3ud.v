module cntr_3ud(
    input            up_down,   // 1: Up, 0: Down
    input            clk,       // Clock
    input            reset,     // Reset
    output     [2:0] q,         // Salida directa del contador
    output     [2:0] nq         // Salida negada complementaria
);

    reg [2:0] bin_count;

    // Asignaciones continuas para las salidas didácticas
    assign q  = bin_count;
    assign nq = ~bin_count;

    always @(posedge clk) begin
        if (reset) begin
            bin_count <= 3'b000;
        end else begin
            if (up_down)
                bin_count <= bin_count + 1'b1;
            else
                bin_count <= bin_count - 1'b1;
        end
    end
endmodule
