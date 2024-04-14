module async_fifo_tb;

// Parameters
parameter DATA_WIDTH = 8;
parameter DEPTH = 16;

// Signals
reg clk = 0;
reg rst = 1;
reg wr_en = 0;
reg rd_en = 0;
reg [DATA_WIDTH-1:0] data_in = 0;
wire [DATA_WIDTH-1:0] data_out;
wire full;
wire empty;

// Instantiate FIFO
async_fifo dut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// Clock generation
always #5 clk = ~clk;

// Test stimuli
initial begin
    // Reset
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;
    #10 rst = 0;

    // Write data
    #20;
    wr_en = 1;
    data_in = 8'hFF;
    #10;
    wr_en = 0;

    // Read data
    #30;
    rd_en = 1;
    #10;
    rd_en = 0;

    // Additional test cases here...

    #100;
    $finish;
end

endmodule