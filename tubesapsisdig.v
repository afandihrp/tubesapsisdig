module tubesapsisdig (
    input wire clk,       // Input clock (e.g., 50 MHz)
    input wire reset,     // Active-high reset
    output reg red,       // Red LED output
    output reg yellow,    // Yellow LED output
    output reg green      // Green LED output
);

    // Define states using parameters
    parameter RED = 2'b00;
    parameter GREEN = 2'b01;
    parameter YELLOW = 2'b10;

    reg [1:0] current_state, next_state;

    // Clock divider for 1 Hz (1 second) pulse
    reg [20:0] clk_divider;  // Adjust bit width based on input clock frequency
    reg one_sec_pulse;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_divider <= 0;
            one_sec_pulse <= 0;
        end else begin
            if (clk_divider == 50_000_000 - 1) begin  // Assuming 50 MHz clock
                clk_divider <= 0;
                one_sec_pulse <= 1;
            end else begin
                clk_divider <= clk_divider + 1;
                one_sec_pulse <= 0;
            end
        end
    end

    // 60-second counter
    reg [5:0] sec_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sec_counter <= 0;
        end else if (one_sec_pulse) begin
            if (sec_counter == 59) 
                sec_counter <= 0;
            else 
                sec_counter <= sec_counter + 1;
        end
    end

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= RED;
        else if (one_sec_pulse) 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            RED: begin
                if (sec_counter < 20) // 20 seconds for Red
                    next_state = RED;
                else 
                    next_state = GREEN;
            end
            GREEN: begin
                if (sec_counter < 40) // 20 seconds for Green
                    next_state = GREEN;
                else 
                    next_state = YELLOW;
            end
            YELLOW: begin
                if (sec_counter < 60) // 20 seconds for Yellow
                    next_state = YELLOW;
                else 
                    next_state = RED;
            end
            default: next_state = RED;
        endcase
    end

    // Output logic
    always @(*) begin
        red = (current_state == RED);
        yellow = (current_state == YELLOW);
        green = (current_state == GREEN);
    end
endmodule