
module bin2bcd32
  (
   input        CLK,
   input        RST,

   input        en,
   input [31:0] bin,

   output [3:0] bcd0,
   output [3:0] bcd1,
   output [3:0] bcd2,
   output [3:0] bcd3,
   output [3:0] bcd4,
   output [3:0] bcd5,
   output [3:0] bcd6,
   output [3:0] bcd7,
   output [3:0] bcd8,
   output [3:0] bcd9,

   output       busy,
   output       fin
   );

   reg [31:0]   bin_r;
   reg [4:0]    bitcount;
   reg [3:0]    bcd[0:9];
   wire [3:0]   bcdp[0:9];

   assign bcd0 = bcd[0];
   assign bcd1 = bcd[1];
   assign bcd2 = bcd[2];
   assign bcd3 = bcd[3];
   assign bcd4 = bcd[4];
   assign bcd5 = bcd[5];
   assign bcd6 = bcd[6];
   assign bcd7 = bcd[7];
   assign bcd8 = bcd[8];
   assign bcd9 = bcd[9];

   localparam s_idle = 2'b00;
   localparam s_busy = 2'b01;
   localparam s_fin  = 2'b10;
   reg [1:0]    state;

   assign busy = state != s_idle;
   assign fin  = state == s_fin;

   always @(posedge CLK or negedge RST)
     if (!RST) begin
        state <= s_idle;
     end else begin
        case (state)
          s_idle: 
            if (en)
              state <= s_busy;

          s_busy:
            if (bitcount == 5'd31)
              state <= s_fin;

          s_fin:
            state <= s_idle;

          default: ;
        endcase
     end

   always @(posedge CLK) begin
      case (state)
        s_idle: 
          if (en)
            bin_r <= bin;
        s_busy:
          bin_r <= {bin_r[30:0], 1'b0};
        default: ;
      endcase
   end

   always @(posedge CLK or negedge RST)
     if (!RST) begin
        bitcount <= 5'd0;
     end else begin
        case (state)
          s_busy:
            bitcount <= bitcount + 5'd1;
          
          default: 
            bitcount <= 5'd0;
        endcase
     end

   generate
      genvar g;

      for (g=0; g<=9; g=g+1) begin : GEN_BCD

         wire [3:0] s;
         wire [3:0] prev;

         assign bcdp[g] = (bcd[g] >= 4'd5) ? bcd[g] + 4'd3 : bcd[g];

         if (g != 0) begin
            assign prev = bcdp[g-1];
         end else begin // if (g != 0)
            assign prev = {bin_r[31], 3'b0};
         end
         assign s 
           = ((bcdp[g] << 1) | (prev >> 3));

         always @(posedge CLK or negedge RST)
           if (!RST) begin
              bcd[g] <= 4'd0;
           end else begin
              case (state)
                s_idle: 
                  bcd[g] <= 4'd0;

                s_busy:
                  bcd[g] <= s;

                default: ;
              endcase
           end

      end
   endgenerate

endmodule
