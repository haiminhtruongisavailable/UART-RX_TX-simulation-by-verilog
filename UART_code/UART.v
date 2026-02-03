module UART 
  #(parameter CLKS_PER_BIT = 87)
  (
   input  wire clk,
   input  wire rst,
   input  wire rx_pin,
   output wire tx_pin
   );

  // Internal signals
  wire [7:0] rx_data;
  wire       rx_ready;
  reg  [7:0] tx_data;
  reg        tx_start;
  wire       tx_busy;
  wire       tx_done;

  // Instantiate UART RX module
  uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) rx_inst (
    .i_Clock(clk),
    .i_Rx_Serial(rx_pin),
    .o_Rx_DV(rx_ready),
    .o_Rx_Byte(rx_data)
  );

  // Instantiate UART TX module
  uart_tx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) tx_inst (
    .i_Clock(clk),
    .i_Tx_DV(tx_start),
    .i_Tx_Byte(tx_data),
    .o_Tx_Active(tx_busy),
    .o_Tx_Serial(tx_pin),
    .o_Tx_Done(tx_done)
  );

  // Simple loopback logic
  // When a byte is received and transmitter is not busy, send it back
  always @(posedge clk) begin
    if (rst) begin
      tx_data  <= 8'd0;
      tx_start <= 1'b0;
    end else begin
      if (rx_ready && !tx_busy) begin
        tx_data  <= rx_data;
        tx_start <= 1'b1;
      end else begin
        tx_start <= 1'b0;
      end
    end
  end

endmodule