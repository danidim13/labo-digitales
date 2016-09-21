module LUT # (parameter SIZE=8)
(
 input wire [SIZE-1:0] A,
 input wire [1:0] B,
 output reg [SIZE+1:0] Result
);

wire [SIZE+1:0] wD0, wD1, wD2, wD3;

assign wD1 = {2'b0, A};
assign wD0 = wD1 ^ wD1; // Esto siempre es cero, de la longitud adecuada.
assign wD2 = {1'b0, A, 1'b0}; 
assign wD3 = wD2 + wD1;

always @ (A, B)
begin
	case (B)
	//-------------------------------------	
	2'b00:
	begin
		Result <= wD0;
	end
	//-------------------------------------	
	2'b01:
	begin
		Result <= wD1;
	end
	//-------------------------------------	
	2'b10:
	begin
		Result <= wD2;
	end
	//-------------------------------------	
	2'b11:
	begin
		Result <= wD3;
	end
	//-------------------------------------	
	endcase
end

endmodule



module Mult4x4
(
 input wire [3:0] A,
 input wire [3:0] B,
 output wire [7:0] Result
);

wire [5:0] wResInt1,wResInt2;

LUT # ( 4 ) LUT1
(
	.A(A),
	.B(B[1:0]),
	.Result(wResInt1)
);

LUT # ( 4 ) LUT2
(
	.A(A),
	.B(B[3:2]),
	.Result(wResInt2)
);

assign Result = ((wResInt2<<2) + wResInt1);

endmodule


module Mult16x16
(
 input wire [15:0] A,
 input wire [15:0] B,
 output wire [31:0] Result
);

wire [17:0] wResInt1,wResInt2,wResInt3,wResInt4,wResInt5,wResInt6,wResInt7,wResInt8;

LUT # ( 16 ) LUT1
(
	.A(A),
	.B(B[1:0]),
	.Result(wResInt1)
);

LUT # ( 16 ) LUT2
(
	.A(A),
	.B(B[3:2]),
	.Result(wResInt2)
);

LUT # ( 16 ) LUT3
(
	.A(A),
	.B(B[5:4]),
	.Result(wResInt3)
);

LUT # ( 16 ) LUT4
(
	.A(A),
	.B(B[7:6]),
	.Result(wResInt4)
);

LUT # ( 16 ) LUT5
(
	.A(A),
	.B(B[9:8]),
	.Result(wResInt5)
);

LUT # ( 16 ) LUT6
(
	.A(A),
	.B(B[11:10]),
	.Result(wResInt6)
);

LUT # ( 16 ) LUT7
(
	.A(A),
	.B(B[13:12]),
	.Result(wResInt7)
);

LUT # ( 16 ) LUT8
(
	.A(A),
	.B(B[15:14]),
	.Result(wResInt8)
);


assign Result = ({wResInt8, 14'b0} + {2'b0, wResInt7, 12'b0}
	+ {4'b0, wResInt6, 10'b0}  + {6'b0, wResInt5, 8'b0}
	+ {8'b0, wResInt4, 6'b0}   + {8'b0, wResInt3, 4'b0}
	+ {10'b0, wResInt2, 2'b0}  + {14'b0, wResInt1});

endmodule
