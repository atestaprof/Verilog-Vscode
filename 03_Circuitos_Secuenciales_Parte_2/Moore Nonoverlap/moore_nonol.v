module moore_nonol(
                   in                                       ,//input
                   clk                                      ,//clock
                   reset                                    ,//reset
                   out                                       //output
                   )                                        ;

//port declaration
input             in, clk, reset                            ;//input declaration
output reg        out                                       ;//output declaration
parameter         S0 = 0 , S1 = 1 , S2 = 2 , S3 = 3, S4 =4  ;//parameter declaration for states
reg       [2:0]   present_state,next_state                  ;//register declaration for states

/*State S0 is assigned to present state if the reset is 1 else the next state is assigned to present state*/
always @ (posedge clk or posedge reset)
   begin
      if(reset)
         present_state <= S0                             ;//if reset is true then go to state S0
      else    
         present_state <= next_state                     ;//if reset is false then make next state as present state
   end             

/*Here the states S0, S1, S2, S3 or S4 is assigned according to the input encountered (for the sequence 1101)*/
always @ (present_state or in)
   begin      
      case(present_state)    
         S0 : begin 
               out = 0                                      ;//output is 0 till the desired sequence is acquired
               next_state = in ? S1 : S0                    ;//next state will be S1 if input is 1 otherwise S0
              end
         S1 : begin 
               out = 0                                      ;//output is 0 till the desired sequence is acquired
               next_state = in ? S2 : S0                    ;//next state will be S2 if input is 1 otherwise S0
              end
         S2 : begin 
               out = 0                                      ;//output is 0 till the desired sequence is acquired
               next_state = in ? S2 : S3                    ;//next state will be S2 if input is 1 otherwise S3             
              end 
         S3 : begin 
               out = 0                                      ;//output is 0 till the desired sequence is acquired
               next_state = in ? S4 : S0                    ;//next state will be S4 if input is 1 otherwise S0
              end
         S4 : begin 
               out = 1                                      ;//output is 1 when the desired sequence is acquired
               next_state = in ? S1 : S0                    ;//next state will be S1 if input is 1 otherwise S0
              end
         default: next_state = S0                           ;//default values to S0
      endcase
   end

endmodule                                                //end of moore machine
