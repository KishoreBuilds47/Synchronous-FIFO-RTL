`timescale 1ns/1ps

module FIFO(
  input wire[7:0] write_OP,
  input wire clk,
  input wire reset,
  input wire read_en,
  input wire write_en,
  output reg[7:0] read_OP
);
  
  reg[2:0] read_ptr;
  reg[2:0] write_ptr;
  reg [7:0] FIFO [0:7];
  reg[3:0] count;
  
  wire full;
  wire empty;
  wire do_read;
  wire do_write;
  
  assign full = (count == 8);
  assign empty = (count == 0);
  assign do_read = !empty && read_en ;
  assign do_write = !full && write_en;
  
  
  always @(posedge clk) begin
    if(reset) begin
      //fifo should make all as zeroes
      read_OP <= 8'b0;
      read_ptr <= 3'b0;
      write_ptr <= 3'b0;
      count <= 4'b0;
      // add more things in future if wanted or remove the comment
    end
    else begin

      if(do_write && !do_read) begin
          //IF it is not full then add the byte
            
            FIFO[write_ptr] <= write_OP; 
            write_ptr <= write_ptr+1'b1; 
            count <= count +1'b1; 
            
          
        end
      else if(do_read && !do_write) begin
          //So if it is not free then we are going to read it
            
            read_OP <= FIFO[read_ptr]; 
            read_ptr <= read_ptr+1'b1;
            count <= count-1'b1; 
          
      end
      else if(do_read && do_write) begin
        FIFO[write_ptr] <= write_OP; 
        write_ptr <= write_ptr+1'b1;
        
        read_OP <= FIFO[read_ptr]; 
        read_ptr <= read_ptr+1'b1;
      end
    end
  end
endmodule
        
      