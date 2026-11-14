module moore_nonol_tb                                       ;//testbench module

reg in                                                      ;//register declration for input
reg clk                                                     ;//register declration for clock
reg reset                                                   ;//register declration for reset
wire out                                                    ;//wire declration for output
parameter       S0 = 0 , S1 = 1 , S2 = 2 , S3 = 3, S4 = 4   ;//parameter declaration for states
reg             new_out                                     ;//register declaration for test output
reg       [2:0] ps, ns                                      ;//register declaration for present state and next state

// Instantiate the design under test

moore_nonol dut (
                .in     (in   )                             ,//input
                .clk    (clk  )                             ,//clock
                .reset  (reset)                             ,//reset
                .out    (out  )                              //output
                 )            ;
    
initial begin
   clk            = 0                                       ;//initialize clock
   reset          = 1                                       ;//initialize reset
   #20 reset      = 0                                       ;//change reset value after 20ns
   forever #5 clk = ~clk                                    ;//clock
end

//always #5 clk = ~clk;  

initial begin
   $dumpfile("moore_nonol.vcd");
   $dumpvars(0, moore_nonol_tb);
  repeat(20)
      begin
         stimulus                                           ;//calling task
         if (out == new_out) 
           begin
             $display("input = %b, output = %b, new out = %b, Testcase Pass", in, out, new_out) ;//display for Testcase pass
             if (out == 1 && new_out == 1)
               $display("Sequence 1101 is detected")                                            ;//display for sequence detected
           end
         else
          $display("input = %b, output = %b, new out = %b, Testcase Fail", in, out, new_out)    ;//display for Testcase pass
      end
   $finish;
end
  
task stimulus;
  begin
    in = $random;@(posedge clk)                             ;//generation of input
  end
endtask

/*State S0 is assigned to present state if the reset is 1 else the next state is assigned to present state*/
always@(posedge clk or posedge reset)
   begin
      if(reset)
         ps <= S0                                           ;//ps is S0 for reset = 1   
      else     
         ps <= ns                                           ;//ps is ns for reset = 0
   end
 
/*Here the states S0, S1, S2, S3 or S4 is assigned according to the input encountered (for the sequence 1101)*/
always @ (ps or in)
   begin      
     case(ps)    
         S0 : begin
           	   if (in)
             		ns    = S1                             ;//next state will be S1 if input is 1 otherwise S0
           		else
             		ns    = S0                             ;
           		new_out  =  0                             ;//output is 0 till the desired sequence is acquired
              end
         S1 : begin 
              	if (in)
             		ns    = S2                             ;//next state will be S2 if input is 1 otherwise S0
           		else
             		ns    = S0                             ;
           		new_out  =  0                             ;//output is 0 till the desired sequence is acquired
              end
         S2 : begin 
              	if (in)
                  ns    = S2                             ;//next state will be S2 if input is 1 otherwise S3
           		else
             		ns    = S3                             ;
           		new_out  =  0                             ;//output is 0 till the desired sequence is acquired
              end 
       	 S3 : begin 
              	if (in)
                  ns    = S4                             ;//next state will be S4 if input is 1 otherwise S0
           		else
             		ns    = S0                             ;
           		new_out  =  0                             ;//output is 0 till the desired sequence is acquired
              end 
         S4 : begin 
              	if (in)
               	ns    = S1                             ;//next state will be S1 if input is 1 otherwise S0
           		else
             		ns    = S0                             ;
           		new_out  =  1                             ;//output is 1 when the 1101 sequence is acquired
              end 
         default: begin
               ns       = S0                             ;
               new_out  = 0                              ;
              end
      endcase
   end
        
endmodule                                                    //end of testbench 
