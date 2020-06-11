module converter(R1, R2, R3, R4, X);

    // inicjalizacja n i p, gdzie 0 <= p <= n-2
    parameter n = 20;
    parameter p = 7;

    // reprezentacje resztowe R1, R2, R3 i R4
    input [n-1 : 0] R1;
    input [n : 0] R2;
    input [2*n : 0] R3;
    input [2*n+p-1 : 0] R4; 

    // wynik konwersji X
    output [6*n+p : 0] X;

    // pomocnicze R fala i k
    wire [4*n-1 : 0] R1f;
    wire [4*n : 0] R2f;
    wire [(n+1+4*n) : 0] R3f;
    wire [(n-p-2+2*n+p+n+2) : 0] R4f;
    wire [4*n : 0] k;

    make_R1f _R1f (R1, R1f);
    make_R2f _R2f (R2, R2f);
    make_R3f _R3f (R3, R3f);
    make_R4f _R4f (R4, R4f);
    
    make_k _k (R2, R3, k);
    make_X _X (R1f, R2f, R3f, R4f, k, R4, X);

    //assign X = R3f;

endmodule


// Modul obliczajacy R1 fala
module make_R1f(R1, R1f);
    parameter n = 20;
    input [n-1 : 0] R1;
    output [4*n-1 : 0] R1f;

    assign R1f = {R1, R1, R1, R1};      // rownanie (9)
endmodule


// Modul obliczajacy R2 fala
module make_R2f(R2, R2f);
    parameter n = 20;
    input [n : 0] R2;
    output [4*n : 0] R2f;

    wire [n-1 : 0] R2d = R2[n-1 : 0];       // R2 daszek
    assign R2f = {R2d, ~R2d, R2d, ~R2d};    // rownanie (12)

endmodule


// Modul obliczajacy R3 fala
module make_R3f(R3, R3f);
    parameter n = 20;
    input [2*n : 0] R3;
    output [(n+1+4*n) : 0] R3f;

    wire [2*n-1 : 0] R3d = R3[2*n-1 : 0];                   // R3 daszek
    assign R3f = 2**(n+1) * {~R3d, R3d} % (2**(4*n)-1);     // rownanie (15)

endmodule


// Modul obliczajacy R4 fala
module make_R4f(R4, R4f);
    parameter n = 20;
    parameter p = 7;
    input [2*n+p-1 : 0] R4;
    output [(n-p-2+2*n+p+n+2) : 0] R4f;

    assign R4f = {{n-p-2{1'b1}}, ~R4, {n+2{1'b0}}};    // rownanie (18)

endmodule


// Modul wyznczajacy k
module make_k(R2, R3, k);
    parameter n = 20;
    parameter p = 7;

    input [n : 0] R2;
    input [2*n : 0] R3;
    output [4*n : 0] k;

    wire b1 = R2[n] & ~R3[2*n];     // b1 = r2(n) AND ~r3(2n)
    wire b2 = R2[n] ~^ R3[2*n];     // b2 = r2(n) XNOR r3(2n)
    assign k = { {n-2{1'b0}}, R3[2*n-1], ~R2[n-1], {n-2{1'b0}}, b1, b2, {n-1{R3[2*n-1]}}, ~R2[n-1], {n-1{1'b0}}, R2[n-1]};     // rownanie (23)

endmodule


// Modul obliczajacy szukana liczbe
module make_X(R1f, R2f, R3f, R4f, k, R4, X);
    parameter n = 20;
    parameter p = 7;

    input [4*n-1 : 0] R1f;
    input [4*n : 0] R2f;
    input [(n+1+4*n) : 0] R3f;
    input [(n-p-2+2*n+p+n+2) : 0] R4f;
    input [4*n : 0] k;
    input [2*n+p-1 : 0] R4;

    output [6*n+p : 0] X;

    wire [6*n+p : 0] right_side = (2**(n-p-2) * (R1f + R2f + R3f + R4f + k)) % (2**(4*n)-1);   // rownanie (20)
    wire [6*n+p : 0] _X = right_side * (2**(2*n+p)) + R4;                                      // wyznaczanie X z rownania (20)
    assign X = _X;

endmodule