`include "converter.v"

module converter_tb();
    // inicjalizacja n i p, gdzie 0 <= p <= n-2
    parameter n = 20;
    parameter p = 7;
    
    // reprezentacje resztowe R1, R2, R3 i R4
    reg [n-1 : 0] R1;
    reg [n : 0] R2;
    reg [2*n : 0] R3;
    reg [2*n+p-1 : 0] R4;

    // wspolczynnik k
    reg [4*n : 0] k;
    
    // wynik konwersji X
    wire [6*n+p : 0] X;

    // wartosci modulow
    wire [n : 0] m1 = 2**n - 1;
    wire [n : 0] m2 = 2**n + 1;
    wire [2*n : 0] m3 = 2**(2*n) + 1;
    wire [2*n+p : 0] m4 = 2**(2*n + p);

    // sprawdzanie wyniku
    wire [n-1 : 0] R1mod = X % m1;
    wire [n : 0] R2mod = X % m2;
    wire [2*n : 0] R3mod = X % m3;
    wire [2*n+p-1 : 0] R4mod = X % m4;

    // wywolanie konwertera
    converter converter_test(R1, R2, R3, R4, X);

    realtime capture = 0.0; 

    // test dla 1000 randomowych liczb
    initial begin
        capture = $realtime;
        $monitor("X = <%d, %d, %d, %d> = %d\n%d mod %d = %d\n%d mod %d = %d\n%d mod %d = %d\n%d mod %d = %d", R1, R2, R3, R4, X, X, m1, R1mod, X, m2, R2mod, X, m3, R3mod, X, m4, R4mod); 
        repeat (100) begin
            R1 = $urandom%(m1-1); R2 = $urandom%(m2/2-1); R3 = $urandom%(m3/2-1); R4 = $urandom%(m4-1);
            #1;
        end
        $display("Operations number: %t", $realtime-capture);
    end
    

endmodule