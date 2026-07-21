module alu(
           a         ,  //input
           b         ,  //input
           select    ,  //input
           zero      ,  //zero bandera
           carry     ,  //carry bandera
           sign      ,  //sign bandera
           parity    ,  //parity bandera
           overflow  ,  //overflow bandera
           out          //output
           )         ;

input [3:0]a, b                                 ;
input [1:0] select                              ;
output reg [3:0]out                             ;
output reg zero, carry, sign, parity, overflow  ;

always @ (*)
   begin
      case (select)
         0 : {carry, out} = a + b   ;
         1 : {carry, out} = a - b   ;
         2 : {carry, out} = a * b   ;
         3 : {carry, out} = a / b   ;
      endcase

      zero     =  ~|out                                              ;
      sign     =  out[3]                                             ;
      parity   =  ~^out                                              ;
      overflow =  (a[3] & b[3] & ~out[3]) | (~a[3] & ~b[3] & out[3]) ;

   end
 
endmodule
