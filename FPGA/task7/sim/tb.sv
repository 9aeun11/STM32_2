`timescale 1ns/1ns
module tb;
    reg clk=0,rst=1,rx_valid=0;
    reg [7:0] rx_data=0;
    wire led,rx_seen;
    wire [7:0] last_byte;
    always #5 clk=~clk;
    uart_led_command dut(clk,rst,rx_valid,rx_data,led,rx_seen,last_byte);
    task send(input [7:0] value);
        begin
            @(negedge clk); rx_data=value; rx_valid=1;
            @(negedge clk); rx_valid=0;
            @(posedge clk); #1;
        end
    endtask
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0,tb);
        repeat(2) @(negedge clk); rst=0;
        send(8'h31);
        if(led!==1 || last_byte!==8'h31) $fatal(1,"command 1");
        send(8'h31);
        if(led!==1 || last_byte!==8'h31) $fatal(1,"idempotent on");
        send(8'h32);
        if(led!==0 || last_byte!==8'h32) $fatal(1,"toggle off");
        send(8'h32);
        if(led!==1 || last_byte!==8'h32) $fatal(1,"toggle on");
        send(8'h30);
        if(led!==0 || last_byte!==8'h30) $fatal(1,"command 0");
        send(8'h41);
        if(led!==0 || last_byte!==8'h41) $fatal(1,"unknown command holds");
        $display("PASS UART LED commands: ASCII 0/1/2, repeat, hold unknown"); $finish;
    end
    initial begin #10000; $fatal(1,"timeout"); end
endmodule
