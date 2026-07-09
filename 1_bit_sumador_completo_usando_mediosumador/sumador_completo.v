`timescale 1ns/1ps

/*// 1. Declaramos primero el componente básico
module medio_sumador(
    input  h_a,
    input  h_b,
    output h_sum,
    output h_carry
);
    assign h_sum   = h_a ^ h_b;
    assign h_carry = h_a & h_b;
endmodule
*/
// 2. Después declaramos el módulo jerárquico superior
module sumador_completo(
    input  i_a, 
    input  i_b, 
    input  i_cin, 
    output o_sum,      
    output o_nsum,     
    output o_carry,    
    output o_ncarry    
);

    wire w_sum1;
    wire w_carry1;
    wire w_carry2;

    // Ahora el linter ya sabe perfectamente qué es 'medio_sumador'
    medio_sumador h1 (
        .h_a     (i_a),   
        .h_b     (i_b),
        .h_sum   (w_sum1), 
        .h_carry (w_carry1)    
    );

    medio_sumador h2 (
        .h_a     (w_sum1),
        .h_b     (i_cin),
        .h_sum   (o_sum), 
        .h_carry (w_carry2)
    );

    assign o_carry  = w_carry1 | w_carry2;
    assign o_nsum   = ~o_sum;
    assign o_ncarry = ~o_carry;
  
endmodule
