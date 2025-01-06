`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 2023014973 노성민 
// 
// Create Date: 2024/11/11 18:28:08
// Module Name: TOP (stimulus)
// Project Name: Project_AES
// Tool Versions: Vivado 2019.1
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP();
reg CLK; // Clock
reg nRST; // Reset
reg ENCDEC; //0 -> Encryption, 1 -> Decryption
reg START; // 신호가 들어오면 Done이 1이 될 때까지 값에 상관없이 작동
reg [127:0] KEY; // Input Key
reg [127:0] TEXTIN; // Input Text
wire DONE; // Completed -> 1
wire [127:0] TEXTOUT; // Output Text
AES aes(CLK, nRST, ENCDEC, START, KEY, TEXTIN, DONE, TEXTOUT); // AES 모듈

always 
#5 CLK = ~CLK; // Clock

initial
begin
CLK = 0; nRST = 0; ENCDEC = 0; START = 0; // Reset
TEXTIN = 128'h328831e0435a3137f6309807a88da234; // Plain Text
KEY = 128'h2b28ab097eaef7cf15d2154f16a6883c; // Key
#20 nRST = 1; // End Reset
#10 ENCDEC = 0; START = 1; // Start with Encryption
#10 ENCDEC = 0; START = 0; // Start가 0이 돼도 계속 동작
wait(DONE); // 끝날 때 까지 wait
$display("%h", TEXTOUT); // 암호화된 text 출력 

#10 nRST = 0; // Reset
TEXTIN = 128'h3902dc1925dc116a8409850b1dfb9732;
#10 nRST = 1; // End Reset
#10 ENCDEC = 1; START = 1; // Start with Dencryption
#10 ENCDEC = 0; START = 0; // Start가 0이 돼도 계속 동작
wait(DONE); // 끝날 때 까지 wait
$display("%h", TEXTOUT); // 해독된 text 출력 
#10 $finish;
end 


endmodule
