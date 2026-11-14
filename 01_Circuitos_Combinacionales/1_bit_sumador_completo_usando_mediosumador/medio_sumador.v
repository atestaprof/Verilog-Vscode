
// module declaration for half adder
module medio_sumador(
	               h_a	   ,	//input
	               h_b	   ,	//input 
               	h_sum	   ,	//output
	               h_carry     //output
                  )        ;

//Port declaration

input  h_a	   ;
input  h_b	   ;
output h_sum	;
output h_carry	;
  
//acarreo y suma ecuaciones booleanas 

assign h_sum   =  h_a ^ h_b;	//xor 
assign h_carry =  h_a & h_b;	//and 
  
endmodule // half adder
