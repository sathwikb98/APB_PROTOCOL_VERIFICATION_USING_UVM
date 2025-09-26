`timescale 1ns/1ns



module slave2(
         input PCLK,PRESETn,
         input PSEL,PENABLE,PWRITE,
         input [7:0]PADDR,PWDATA,
        output [7:0]PRDATA2,
        output reg PREADY );

     reg [7:0]reg_addr;

     reg [7:0] mem2 [0:255];

    assign PRDATA2 =  mem2[reg_addr];

    always @(*)
       begin
         if(!PRESETn)
              PREADY = 0;
          else
    if(PSEL && !PENABLE && !PWRITE)
       begin PREADY = 0; end

    else if(PSEL && PENABLE && !PWRITE)
       begin  PREADY = 1;
                    reg_addr =  PADDR;
         end
          else if(PSEL && !PENABLE && PWRITE)
       begin  PREADY = 0; end

    else if(PSEL && PENABLE && PWRITE)
       begin  PREADY = 1;
              mem2[PADDR] = PWDATA; end

           else PREADY = 0;
        end
    endmodule
