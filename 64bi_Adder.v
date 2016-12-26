module Full_Adder(A, B, Cin, S, Cout);
	input  A, B, Cin;
	output S, Cout;
	wire   aOrb, aOrbAndCin, aAndb;
	xor #(3) xor1(S, A, B, Cin);
	or  #(2) or1(aOrb, A, B);
	and #(2) and1(aOrbAndCin, aOrb, Cin);
	and #(2) and2(aAndb, A, B);
	or  #(2) or2(Cout, aOrbAndCin, aAndb);
endmodule

module CarryLookahead_Adder(A, B, Cin, S, Cout);
	input [3:0]A;
	input [3:0]B;
	input Cin;

	output [3:0]S;
	output Cout;

	wire g0,g1,g2,g3;
	wire p0,p1,p2,p3;
	wire c1, c2, c3;
	wire w1, w2, w3, w4;

	and  #(2) p0maker(p0, A[0], B[0]);
	and  #(2) p1maker(p1, A[1], B[1]);
	and  #(2) p2maker(p2, A[2], B[2]);
	and  #(2) p3maker(p3, A[3], B[3]);

	xor  #(2) g0maker(g0, A[0], B[0]);
	xor  #(2) g1maker(g1, A[1], B[1]);
	xor  #(2) g2maker(g2, A[2], B[2]);
	xor  #(2) g3maker(g3, A[3], B[3]);
	
	
	and  #(2) and1(w1, Cin, p0);
	
	and  #(3) and2(w2, Cin, p0, p1);
	and  #(2) and3(w3, g0, p1);
	
	and  #(4) and4(w4, Cin, p0, p1, p2);
	and  #(3) and5(w4, g0, p1, p2);
	and  #(2) and6(w4, g1, p2);

	and  #(5) and7(w4, Cin, p0, p1, p2, p3);
	and  #(4) and8(w4, g0, p1, p2, p3);
	and  #(3) and9(w4, g1, p2, p3);
	and  #(2) and10(w4, g2, p3);

	or   #(2) orc1(c1, g0, w1);
	or   #(2) orc2(c2, g1, w2, w3);
	or   #(2) orc3(c3, g2, w4, w5, w6);
	or   #(2) orc4(Cout, g3, w7, w8, w9, w10);


	xor  #(2) xors0(S[0],p0, c0);
	xor  #(2) xors1(S[1],p1, c1);
	xor  #(2) xors2(S[2],p2, c2);
	xor  #(2) xors3(S[3],p3, c3);
endmodule

module RC_Adder_16bit(A,B,Cin,S,Cout);
	input [15:0]A;
	input [15:0]B;
	input Cin;
	output [15:0]S;
	output Cout;

	wire wc0, wc1, wc2, wc3, wc4, wc5, wc6, wc7, wc8, wc9, wc10, wc11, wc12, wc13, wc14;
	//16-bit adder1 description

	Full_Adder fa0(A[0], B[0], 1'b0, wc0);
	Full_Adder fa1(A[1], B[1], wc0 , wc1);
	Full_Adder fa2(A[2], B[2], wc1 , wc2);
	Full_Adder fa3(A[3], B[3], wc2 , wc3);
	Full_Adder fa4(A[4], B[4], wc3 , wc4);
	Full_Adder fa5(A[5], B[5], wc4 , wc5);
	Full_Adder fa6(A[6], B[6], wc5 , wc6);
	Full_Adder fa7(A[7], B[7], wc6 , wc7);
	Full_Adder fa8(A[8], B[8], wc7 , wc8);
	Full_Adder fa9(A[9], B[9], wc8 , wc9);
	Full_Adder fa10(A[10], B[10], wc9 , wc10);
	Full_Adder fa11(A[11], B[11], wc10, wc11);
	Full_Adder fa12(A[12], B[12], wc11 , wc12);
	Full_Adder fa13(A[13], B[13], wc12 , wc13);
	Full_Adder fa14(A[14], B[14], wc13 , wc14);
	Full_Adder fa15(A[15], B[15], wc14 , Cout);
endmodule

module CL_Adder_16bit(A,B,Cin,S,Cout);
	input [15:0]A;
	input [15:0]B;
	input Cin;
	output [15:0]S;
	output Cout;
	
	//16-bit adder2 description

	wire c1, c2, c3;
	CarryLookahead_Adder cla1(A[3:0], B[3:0], Cin, S[3:0], c1);
	CarryLookahead_Adder cla2(A[7:4], B[7:4], c1, S[7:4], c2);
	CarryLookahead_Adder cla3(A[11:8], B[11:8], c2, S[11:8], c3);
	CarryLookahead_Adder cla4(A[15:12], B[15:12], c3, S[15:12], Cout);
endmodule

module Adder16_TB;
	reg [15:0]num1;
	reg [15:0]num2;

	wire [15:0]sumAdder1;
	wire [15:0]sumAdder2;
	reg c1, c2;
	
	wire cout1, cout2;

	RC_Adder_16bit adder1(num1, num2, c1, sumAdder1, cout1);
	CL_Adder_16bit adder2(num1, num2, c2, sumAdder2, cout2);

	initial
		begin
			#1
			    num1 = 16'b0000000000000000;
			    num2 = 16'b0000000000000000;
			    c1   = 1'b0;
			    c2   = 1'b0;
			#200  
			    num1 = 16'b0010010011010111;
			    num2 = 16'b0000010000011111;
			    c1   = 1'b0;
			    c2   = 1'b0;
			#400
			    num1 = 16'b1111110111101000;
			    num2 = 16'b0000010000011111;
			    c1   = 1'b0;
			    c2   = 1'b0;
		end

	initial
		$monitor("num1 = %b  num2 = %b RC_Result = %b CL_Result = %b time = %0d", num1, num2, {c1,sumAdder1}, {c2,sumAdder2}, $time);

endmodule
