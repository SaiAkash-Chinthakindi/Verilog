`timescale 1ns/1ps

module gates_tb;
  logic       A, B;
  logic [2:0] sel;
  logic       y;
  int errors = 0;
  
  gates_using_mux dut (.A(A), .B(B), .y(y), .sel(sel));

  typedef enum logic [2:0] {
    GATE_AND  = 3'd0,
    GATE_OR   = 3'd1,
    GATE_NOT  = 3'd2,
    GATE_NAND = 3'd3,
    GATE_NOR  = 3'd4,
    GATE_XOR  = 3'd5,
    GATE_XNOR = 3'd6
  } gate;

  function logic expected(logic a, logic b, gate g);
    case (g)
      GATE_AND : return a & b;
      GATE_OR  : return a | b;
      GATE_NOT : return ~a;
      GATE_NAND: return ~(a & b);
      GATE_NOR : return ~(a | b);
      GATE_XOR : return a ^ b;
      GATE_XNOR: return ~(a ^ b);
      default  : return 1'b0;
    endcase
  endfunction

  task automatic drive_and_check(logic a, logic b, gate g);
    A   = a;
    B   = b;
    sel = g;                 
    #1;                      
    if (y !== expected(a, b, g)) begin
      $error("%s A=%b B=%b : got %b expected %b",
             g.name(), a, b, y, expected(a, b, g));
      errors++;
    end
  endtask

  initial begin
    gate g;
    for (int gi = 0; gi <= 6; gi++) begin
      g = gate'(gi);
      for (int j = 0; j < 4; j++) begin
        drive_and_check(j[1], j[0], g);
      end
    end

    if (errors == 0) $display("PASS - all gates correct");
    else             $display("FAIL - %0d mismatch(es)", errors);
    $finish;
  end

endmodule
