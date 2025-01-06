`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 2023014973 �뼺�� 
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
reg START; // ��ȣ�� ������ Done�� 1�� �� ������ ���� ������� �۵�
reg [127:0] KEY; // Input Key
reg [127:0] TEXTIN; // Input Text
wire DONE; // Completed -> 1
wire [127:0] TEXTOUT; // Output Text
AES aes(CLK, nRST, ENCDEC, START, KEY, TEXTIN, DONE, TEXTOUT); // AES ���

always 
#5 CLK = ~CLK; // Clock

initial
begin
CLK = 0; nRST = 0; ENCDEC = 0; START = 0; // Reset
TEXTIN = 128'h328831e0435a3137f6309807a88da234; // Plain Text
KEY = 128'h2b28ab097eaef7cf15d2154f16a6883c; // Key
#20 nRST = 1; // End Reset
#10 ENCDEC = 0; START = 1; // Start with Encryption
#10 ENCDEC = 0; START = 0; // Start�� 0�� �ŵ� ��� ����
wait(DONE); // ���� �� ���� wait
$display("%h", TEXTOUT); // ��ȣȭ�� text ��� 

#10 nRST = 0; // Reset
TEXTIN = 128'h3902dc1925dc116a8409850b1dfb9732;
#10 nRST = 1; // End Reset
#10 ENCDEC = 1; START = 1; // Start with Dencryption
#10 ENCDEC = 0; START = 0; // Start�� 0�� �ŵ� ��� ����
wait(DONE); // ���� �� ���� wait
$display("%h", TEXTOUT); // �ص��� text ��� 
#10 $finish;
end 


endmodule
