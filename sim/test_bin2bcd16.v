
module test_bin2bcd16
  ();

   reg        CLK;
   reg        RST;

   reg        en;
   reg [15:0] bin;

   wire [3:0] bcd0;
   wire [3:0] bcd1;
   wire [3:0] bcd2;
   wire [3:0] bcd3;
   wire [3:0] bcd4;

   wire       busy;
   wire       fin;

    bin2bcd16 inst
      (
       .CLK(CLK),
       .RST(RST),

       .en(en),
       .bin(bin),

       .bcd0(bcd0),
       .bcd1(bcd1),
       .bcd2(bcd2),
       .bcd3(bcd3),
       .bcd4(bcd4),

       .busy(busy),
       .fin(fin)
       );

   integer    i;
   
   initial begin
      CLK = 1'b0;
      RST = 1'b1;
      #10;
      RST = 1'b0;
      #10;
      RST = 1'b1;

      #10;
      for (i=0; i!=65535; i=i+1) begin
         en = 1;
         bin = i;
         #10;
         
         while (!fin) begin
            en = 0;
            #10;
         end
         $display("input %d, output %d %d %d %d %d", bin, bcd4, bcd3, bcd2, bcd1, bcd0);
         #10;
         while (busy) begin
            #10;
         end
      end // for (i=0; i!=65535; i=i+1)
      $finish;
      
   end
   
   always #5 CLK <= ~CLK;
   
endmodule
