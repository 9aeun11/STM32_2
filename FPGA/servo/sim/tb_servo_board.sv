`timescale 1ns/1ps
module tb_servo_board;
    reg clk=0, rst=1, left=0, right=0;
    wire servo;
    always #5 clk=~clk;
    servo_board #(.CLK_HZ(100_000), .DEBOUNCE_CYCLES(3)) dut (
        .clk_50mhz(clk), .rst_p(rst),
        .left_button(left), .right_button(right), .servo(servo)
    );
    task check(input [31:0] expected);
        begin
            #1;
            if (dut.u_servo.pulse_us !== expected)
                $fatal(1, "servo position expected=%0d got=%0d", expected, dut.u_servo.pulse_us);
        end
    endtask
    initial begin
        repeat (3) @(negedge clk);
        check(1500);
        rst=0;
        left=1;
        repeat (15) @(negedge clk);
        check(1400);
        repeat (20) @(negedge clk);
        check(1400);
        left=0;
        repeat (15) @(negedge clk);
        left=1;
        repeat (15) @(negedge clk);
        check(1300);
        left=0;
        right=1;
        repeat (15) @(negedge clk);
        check(1400);
        $display("PASS servo board: held button produces one step, release rearms, right steps");
        $finish;
    end
endmodule
