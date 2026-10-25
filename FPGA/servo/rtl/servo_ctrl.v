`timescale 1ns/1ps
module servo_ctrl #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz,rst_p,left_pulse,right_pulse,
    output wire servo
);
    wire [31:0] pulse_us;
    servo_position u_position(clk_50mhz,rst_p,left_pulse,right_pulse,pulse_us);
    servo_pwm #(.CLK_HZ(CLK_HZ)) u_pwm(clk_50mhz,rst_p,pulse_us,servo);
endmodule

module servo_position(
    input wire clk_50mhz,rst_p,left_pulse,right_pulse,
    output reg [31:0] pulse_us
);
    always @(posedge clk_50mhz)
        if(rst_p) pulse_us<=1500;
        else if(left_pulse && !right_pulse && pulse_us>1000) pulse_us<=pulse_us-100;
        else if(right_pulse && !left_pulse && pulse_us<2000) pulse_us<=pulse_us+100;
endmodule

module servo_pwm #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz,rst_p,
    input wire [31:0] pulse_us,
    output wire servo
);
    localparam FRAME_CYCLES=CLK_HZ/50;
    reg [31:0] count;
    reg [31:0] width_cycles;
    always @(posedge clk_50mhz) begin
        if(rst_p) begin count<=0; width_cycles<=(CLK_HZ/1000)*3/2; end
        else if(count==FRAME_CYCLES-1) begin
            count<=0;
            // For whole-MHz clocks, convert microseconds directly to cycles.
            // The fallback keeps the low-frequency simulation parameter exact.
            width_cycles <= (CLK_HZ % 1_000_000 == 0)
                ? pulse_us * (CLK_HZ / 1_000_000)
                : pulse_us * (CLK_HZ / 1000) / 1000;
        end
        else count<=count+1;
    end
    assign servo=!rst_p && (count<width_cycles);
endmodule
