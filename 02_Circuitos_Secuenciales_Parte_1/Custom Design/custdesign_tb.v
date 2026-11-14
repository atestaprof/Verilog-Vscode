module custdesign_tb;

reg x, clk, reset;
wire y;
reg a, abar, b, bbar, r2, s2;

custdesign dut (
                  x,clk,reset,y);


initial begin
   clk = 0;
   forever #5 clk =~clk;
end

initial begin
   $dumpfile("custdesign.vcd");
   $dumpvars(0, custdesign_tb);
   $monitor("time = %0t, clk = %b, reset = %b, x = %b, y = %b", $time, clk, reset, x, y);
b = 1;
x = 1;
reset = 1;
#20 reset =0;
#200 $finish;
end
endmodule
