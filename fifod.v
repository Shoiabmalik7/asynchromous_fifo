module async_fifo #(parameter DATA_WIDTH = 8, DEPTH = 16)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty);

//parameter DATA_WIDTH = 8; // Width of the data bus
//parameter DEPTH = 16; // Depth of the FIFO

reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
reg [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr; // Use $clog2 to determine width
reg [$clog2(DEPTH+1)-1:0] count; // Count needs to hold values up to DEPTH

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
        full <= 0;
        empty <= 1;
    end
    else
    begin
        if (wr_en && !full)
        begin
            memory[wr_ptr] <= data_in;
            wr_ptr <= (wr_ptr + 1) & (DEPTH-1);
            count <= count + 1;
            if (count == DEPTH)
                full <= 1;
            if (count == 1)
                empty <= 0;
        end
        if (rd_en && !empty)
        begin
            data_out <= memory[rd_ptr];
            rd_ptr <= (rd_ptr + 1) & (DEPTH-1);
            count <= count - 1;
            if (count == 1)
                empty <= 1;
            if (count == 0)
                full <= 0;
        end
    end
end

endmodule

