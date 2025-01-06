`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 2023014973 노성민 
// 
// Create Date: 2024/11/10 23:29:36
// Module Name: AES
// Project Name: Project_AES
// Tool Versions: Vivado 2019.1
// 
//////////////////////////////////////////////////////////////////////////////////


module AES(
    input CLK, // Clock
    input nRST, // Reset
    input ENCDEC, //0 -> Encryption, 1 -> Decryption
    input START, // 신호가 들어오면 Done이 1이 될 때까지 값에 상관없이 작동
    input [127:0] KEY, // Input Key
    input [127:0] TEXTIN, // Input Text
    output reg DONE, // Completed -> 1
    output reg [127:0] TEXTOUT); // Output Text
integer round; // 수행 라운드 - 연산용
integer this_round; // 현재 라운드 - waveform에서 명시
integer encdec; // ENCDEC 저장
integer start; // Start 저장
reg [127:0] use_text; // 직접 사용을 방지하기 위한 작업용 text
reg [127:0] round_key; // 직접 사용을 방지하기 위한 round별 작업용 text
integer i; // for문을 위한 정수 i
always @(negedge nRST or posedge CLK) begin
if(!nRST) begin // Reset
       DONE = 0;
       TEXTOUT = 0;
       round = -1;
       start = 0;
       use_text = 0;
       round_key = 0;
    end 
else if (round ==  -1 && START && ~DONE) begin // Start에 처음 신호가 들어왔을 때
    if(ENCDEC == 0) begin //Encryption 
        round = 0; // Encryption은 round 0부터 시작
        encdec = 0; // encryption
        start = 1; // start 신호 저장
        end 
    else begin //Decryption
        round = 10; // Decryption은 round 10부터 시작
        encdec = 1; // decryption
        start = 1;  // start 신호 저장
        use_text = TEXTIN; 
        end   
    end
else if (!encdec && ~DONE && start) begin // encryption 수행
    if(round == 0) begin // 0 round
        Add_Round_Key(TEXTIN, KEY, use_text); // 0 round : Add Round Key
        round_key = KEY; // 입력된 key를 round_key에 저장
        round = round + 1; end // 다음 round로
    else if(round <= 10) begin // 나머지 rounds
        Key_Expansion(round_key, round, round_key); // n round : Key Expansion
        Byte_Substitution(use_text, use_text); // n round : Byte Substitution
        Shift_Rows(use_text, use_text); // n round : Shift Rows
        if (round != 10) Mix_Columns(use_text, use_text); // n round : Mix Columns (마지막 10 round 제외)
        Add_Round_Key(use_text, round_key, use_text); // n round : Add Round Key
        round = round + 1; // 다음 round로
        if(round == 11) begin // 마지막 round였을 시
            DONE = 1; // 완료
            TEXTOUT = use_text; // output 명시
            //round = -1; // round 초기화 
            end
    end
end
else if (encdec && ~DONE && start) begin // decryption 수행
    if(round == 0) begin // 마지막 0 round 
            round_key = KEY; // 0 round의 key는 input key    
            Add_Round_Key(use_text, KEY, use_text); // 0 round : Add Round Key
            DONE = 1; // 완료
            TEXTOUT = use_text; // output 명시
            round = round - 1; // round 명시
            end
    else if(0 < round) begin // n round
        round_key = KEY; // round key 초기화
        case (round)
            1: Key_Expansion(round_key,1,round_key);  
            2: begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key); 
              end
            3:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
              end
            4:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
              end
            5:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
                Key_Expansion(round_key,5,round_key);
              end
            6:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
                Key_Expansion(round_key,5,round_key);
                Key_Expansion(round_key,6,round_key);
              end
            7:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
                Key_Expansion(round_key,5,round_key);
                Key_Expansion(round_key,6,round_key);
                Key_Expansion(round_key,7,round_key);
              end
            8:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
                Key_Expansion(round_key,5,round_key);
                Key_Expansion(round_key,6,round_key);
                Key_Expansion(round_key,7,round_key);
                Key_Expansion(round_key,8,round_key);
              end
            9:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
                Key_Expansion(round_key,5,round_key);
                Key_Expansion(round_key,6,round_key);
                Key_Expansion(round_key,7,round_key);
                Key_Expansion(round_key,8,round_key);
                Key_Expansion(round_key,9,round_key);
              end
            10:begin
                Key_Expansion(round_key,1,round_key);  
                Key_Expansion(round_key,2,round_key);
                Key_Expansion(round_key,3,round_key);  
                Key_Expansion(round_key,4,round_key); 
                Key_Expansion(round_key,5,round_key);
                Key_Expansion(round_key,6,round_key);
                Key_Expansion(round_key,7,round_key);
                Key_Expansion(round_key,8,round_key);
                Key_Expansion(round_key,9,round_key);
                Key_Expansion(round_key,10,round_key);
              end
            default: begin end // round에 맞는 key 연산
        endcase
        /*for (i = 1; i <= round; i = i+1)
               Key_Expansion(round_key, i, round_key);*/ //synthesis 무한반복으로 만들어버림
        Add_Round_Key(use_text, round_key, use_text); // n round : Add Round Key
        if (round != 10) Reverse_Mix_Columns(use_text, use_text); // n round : Reverse Mix Columns (첫 10 round 제외)
        Reverse_Shift_Rows(use_text, use_text); // n round : Reverse Shift Rows
        Reverse_Byte_Substitution(use_text, use_text); // n round : Reverse Byte Substitution
        round = round - 1; // 이전 라운드로
    end
end
end
always @(round) begin // round 명시
    if(start == 0) this_round = -1; // 시작 전에는 -1
    else if(!encdec) // Encryption 시
        this_round = round - 1;
    else this_round = round + 1; // Decryption 시
end

function [7:0] SBox; // S_Box 변환 함수
input [7:0] in;
reg[7:0] S_Box[0:255];
begin
S_Box[0] = 8'h63; S_Box[1] = 8'h7C; S_Box[2] = 8'h77; S_Box[3] = 8'h7B; S_Box[4] = 8'hF2; S_Box[5] = 8'h6B; S_Box[6] = 8'h6F; S_Box[7] = 8'hC5;
S_Box[8] = 8'h30; S_Box[9] = 8'h01; S_Box[10] = 8'h67; S_Box[11] = 8'h2B; S_Box[12] = 8'hFE; S_Box[13] = 8'hD7; S_Box[14] = 8'hAB; S_Box[15] = 8'h76; 
S_Box[16] = 8'hCA; S_Box[17] = 8'h82; S_Box[18] = 8'hC9; S_Box[19] = 8'h7D; S_Box[20] = 8'hFA; S_Box[21] = 8'h59; S_Box[22] = 8'h47; S_Box[23] = 8'hF0;
S_Box[24] = 8'hAD; S_Box[25] = 8'hD4; S_Box[26] = 8'hA2; S_Box[27] = 8'hAF; S_Box[28] = 8'h9C; S_Box[29] = 8'hA4; S_Box[30] = 8'h72; S_Box[31] = 8'hC0;
S_Box[32] = 8'hB7; S_Box[33] = 8'hFD; S_Box[34] = 8'h93; S_Box[35] = 8'h26; S_Box[36] = 8'h36; S_Box[37] = 8'h3F; S_Box[38] = 8'hF7; S_Box[39] = 8'hCC;
S_Box[40] = 8'h34; S_Box[41] = 8'hA5; S_Box[42] = 8'hE5; S_Box[43] = 8'hF1; S_Box[44] = 8'h71; S_Box[45] = 8'hD8; S_Box[46] = 8'h31; S_Box[47] = 8'h15;
S_Box[48] = 8'h04; S_Box[49] = 8'hC7; S_Box[50] = 8'h23; S_Box[51] = 8'hC3; S_Box[52] = 8'h18; S_Box[53] = 8'h96; S_Box[54] = 8'h05; S_Box[55] = 8'h9A;
S_Box[56] = 8'h07; S_Box[57] = 8'h12; S_Box[58] = 8'h80; S_Box[59] = 8'hE2; S_Box[60] = 8'hEB; S_Box[61] = 8'h27; S_Box[62] = 8'hB2; S_Box[63] = 8'h75;
S_Box[64] = 8'h09; S_Box[65] = 8'h83; S_Box[66] = 8'h2C; S_Box[67] = 8'h1A; S_Box[68] = 8'h1B; S_Box[69] = 8'h6E; S_Box[70] = 8'h5A; S_Box[71] = 8'hA0;
S_Box[72] = 8'h52; S_Box[73] = 8'h3B; S_Box[74] = 8'hD6; S_Box[75] = 8'hB3; S_Box[76] = 8'h29; S_Box[77] = 8'hE3; S_Box[78] = 8'h2F; S_Box[79] = 8'h84;
S_Box[80] = 8'h53; S_Box[81] = 8'hD1; S_Box[82] = 8'h00; S_Box[83] = 8'hED; S_Box[84] = 8'h20; S_Box[85] = 8'hFC; S_Box[86] = 8'hB1; S_Box[87] = 8'h5B;
S_Box[88] = 8'h6A; S_Box[89] = 8'hCB; S_Box[90] = 8'hBE; S_Box[91] = 8'h39; S_Box[92] = 8'h4A; S_Box[93] = 8'h4C; S_Box[94] = 8'h58; S_Box[95] = 8'hCF;
S_Box[96] = 8'hD0; S_Box[97] = 8'hEF; S_Box[98] = 8'hAA; S_Box[99] = 8'hFB; S_Box[100] = 8'h43; S_Box[101] = 8'h4D; S_Box[102] = 8'h33; S_Box[103] = 8'h85;
S_Box[104] = 8'h45; S_Box[105] = 8'hF9; S_Box[106] = 8'h02; S_Box[107] = 8'h7F; S_Box[108] = 8'h50; S_Box[109] = 8'h3C; S_Box[110] = 8'h9F; S_Box[111] = 8'hA8;
S_Box[112] = 8'h51; S_Box[113] = 8'hA3; S_Box[114] = 8'h40; S_Box[115] = 8'h8F; S_Box[116] = 8'h92; S_Box[117] = 8'h9D; S_Box[118] = 8'h38; S_Box[119] = 8'hF5;
S_Box[120] = 8'hBC; S_Box[121] = 8'hB6; S_Box[122] = 8'hDA; S_Box[123] = 8'h21; S_Box[124] = 8'h10; S_Box[125] = 8'hFF; S_Box[126] = 8'hF3; S_Box[127] = 8'hD2;
S_Box[128] = 8'hCD; S_Box[129] = 8'h0C; S_Box[130] = 8'h13; S_Box[131] = 8'hEC; S_Box[132] = 8'h5F; S_Box[133] = 8'h97; S_Box[134] = 8'h44; S_Box[135] = 8'h17;
S_Box[136] = 8'hC4; S_Box[137] = 8'hA7; S_Box[138] = 8'h7E; S_Box[139] = 8'h3D; S_Box[140] = 8'h64; S_Box[141] = 8'h5D; S_Box[142] = 8'h19; S_Box[143] = 8'h73;
S_Box[144] = 8'h60; S_Box[145] = 8'h81; S_Box[146] = 8'h4F; S_Box[147] = 8'hDC; S_Box[148] = 8'h22; S_Box[149] = 8'h2A; S_Box[150] = 8'h90; S_Box[151] = 8'h88; 
S_Box[152] = 8'h46; S_Box[153] = 8'hEE; S_Box[154] = 8'hB8; S_Box[155] = 8'h14; S_Box[156] = 8'hDE; S_Box[157] = 8'h5E; S_Box[158] = 8'h0B; S_Box[159] = 8'hDB;
S_Box[160] = 8'hE0; S_Box[161] = 8'h32; S_Box[162] = 8'h3A; S_Box[163] = 8'h0A; S_Box[164] = 8'h49; S_Box[165] = 8'h06; S_Box[166] = 8'h24; S_Box[167] = 8'h5C;
S_Box[168] = 8'hC2; S_Box[169] = 8'hD3; S_Box[170] = 8'hAC; S_Box[171] = 8'h62; S_Box[172] = 8'h91; S_Box[173] = 8'h95; S_Box[174] = 8'hE4; S_Box[175] = 8'h79;
S_Box[176] = 8'hE7; S_Box[177] = 8'hC8; S_Box[178] = 8'h37; S_Box[179] = 8'h6D; S_Box[180] = 8'h8D; S_Box[181] = 8'hD5; S_Box[182] = 8'h4E; S_Box[183] = 8'hA9;
S_Box[184] = 8'h6C; S_Box[185] = 8'h56; S_Box[186] = 8'hF4; S_Box[187] = 8'hEA; S_Box[188] = 8'h65; S_Box[189] = 8'h7A; S_Box[190] = 8'hAE; S_Box[191] = 8'h08;
S_Box[192] = 8'hBA; S_Box[193] = 8'h78; S_Box[194] = 8'h25; S_Box[195] = 8'h2E; S_Box[196] = 8'h1C; S_Box[197] = 8'hA6; S_Box[198] = 8'hB4; S_Box[199] = 8'hC6;
S_Box[200] = 8'hE8; S_Box[201] = 8'hDD; S_Box[202] = 8'h74; S_Box[203] = 8'h1F; S_Box[204] = 8'h4B; S_Box[205] = 8'hBD; S_Box[206] = 8'h8B; S_Box[207] = 8'h8A;
S_Box[208] = 8'h70; S_Box[209] = 8'h3E; S_Box[210] = 8'hB5; S_Box[211] = 8'h66; S_Box[212] = 8'h48; S_Box[213] = 8'h03; S_Box[214] = 8'hF6; S_Box[215] = 8'h0E;
S_Box[216] = 8'h61; S_Box[217] = 8'h35; S_Box[218] = 8'h57; S_Box[219] = 8'hB9; S_Box[220] = 8'h86; S_Box[221] = 8'hC1; S_Box[222] = 8'h1D; S_Box[223] = 8'h9E;
S_Box[224] = 8'hE1; S_Box[225] = 8'hF8; S_Box[226] = 8'h98; S_Box[227] = 8'h11; S_Box[228] = 8'h69; S_Box[229] = 8'hD9; S_Box[230] = 8'h8E; S_Box[231] = 8'h94;
S_Box[232] = 8'h9B; S_Box[233] = 8'h1E; S_Box[234] = 8'h87; S_Box[235] = 8'hE9; S_Box[236] = 8'hCE; S_Box[237] = 8'h55; S_Box[238] = 8'h28; S_Box[239] = 8'hDF;
S_Box[240] = 8'h8C; S_Box[241] = 8'hA1; S_Box[242] = 8'h89; S_Box[243] = 8'h0D; S_Box[244] = 8'hBF; S_Box[245] = 8'hE6; S_Box[246] = 8'h42; S_Box[247] = 8'h68;
S_Box[248] = 8'h41; S_Box[249] = 8'h99; S_Box[250] = 8'h2D; S_Box[251] = 8'h0F; S_Box[252] = 8'hB0; S_Box[253] = 8'h54; S_Box[254] = 8'hBB; S_Box[255] = 8'h16;

SBox = S_Box[in];
end
endfunction

function [7:0] findIndexInSBox; // 값으로 S_Box 인덱스를 검색하는 함수
input [7:0] value;
integer i;
begin
for ( i = 0; i < 256; i = i + 1) begin
    if(SBox(i) == value)   
        findIndexInSBox = i; end
end
endfunction

function [7:0] Rcons; // round에 따른 Rcon 반환 함수 ( round - 1을 input으로 주어야 함)
input [7:0] in;
reg [7:0] Rcon[0:9];
begin
Rcon[0] = 8'h01; Rcon[1] = 8'h02;
Rcon[2] = 8'h04; Rcon[3] = 8'h08;
Rcon[4] = 8'h10; Rcon[5] = 8'h20;
Rcon[6] = 8'h40; Rcon[7] = 8'h80;
Rcon[8] = 8'h1B; Rcon[9] = 8'h36;
Rcons = Rcon[in];
end
endfunction

function [7:0] xtime; // Mix columns 곱 연산 함수 
input [7:0] x;
begin
 xtime =  (x << 1) ^ ((x & 8'h80) ? 8'h1B : 8'h00);
end
endfunction

function [7:0] multiply; // Reverse Mix columns 연산 함수 
input [7:0] x;
input [7:0] y;
reg [7:0] result;
begin
result = 8'h00;
while(y) begin
    if (y & 8'h01) result = result ^ x; //01
    x = (x << 1) ^ (x & 8'h80 ? 8'h1B : 8'h00); //00
    y = y >> 1;
    multiply = result;
    end
end    
endfunction

task Add_Round_Key; // Add Round Key
input [127:0] in;
input [127:0] key;
output reg [127:0] out;
integer i;
begin
for (i = 0; i < 128; i = i + 1) 
    out[i] = in[i] ^ key[i];  
end
endtask

task Key_Expansion; // Key Expansion
input [127:0] inp;
input [7:0] round;
output reg [127:0] keys;
reg [7:0] temp[0:3];
reg [7:0] r[0:3];
integer i, j;
reg [7:0] in[0:3][0:3];
reg [7:0] key[0:3][0:3];
begin
for (i = 0; i < 4; i = i + 1) begin 
    for (j = 0; j < 4; j = j + 1) begin
        in[3-i][3-j] = inp[(i * 32) + (j * 8) +: 8]; // 2차원 배열로 바꿔주는 연산 : LSB가 이차원 배열의 첫번째로 가야 함
    end
end
temp[0] = SBox(in[1][3]);
temp[1] = SBox(in[2][3]);
temp[2] = SBox(in[3][3]);
temp[3] = SBox(in[0][3]);
    
r[0] = Rcons(round - 1);
r[1] = 8'h00; r[2] = 8'h00; r[3] = 8'h00;

for (j = 0; j < 4; j = j+1)
    key[j][0] = in[j][0] ^ temp[j] ^ r[j]; 

for (i = 1; i < 4; i = i + 1) 
    for (j = 0; j < 4; j = j + 1) 
        key[j][i] = in[j][i] ^ key[j][i - 1];

for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        keys[(i * 32) + (j * 8) +: 8] = key[3-i][3-j]; // 128 bit 로 바꿔주는 연산 : 배열의 앞부분이 LSB로 가야 함
    end
end
end
endtask

task Byte_Substitution; // Byte Substitution
input [127:0] in;
output reg [127:0] out;
reg [7:0] byte;
integer i;
begin
for(i = 0; i < 16; i = i + 1)begin
         byte = in[i*8 +: 8];
         out[i*8 +: 8] = SBox(byte); end
end
endtask

task Shift_Rows;
input [127:0] inp;
output reg [127:0] outs;
reg [7:0] in[0:3][0:3];
reg [7:0] out[0:3][0:3];
integer i, j;
begin
for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        in[3-i][3-j] = inp[(i * 32) + (j * 8) +: 8]; // 2차원 배열로 바꿔주는 연산 : LSB가 이차원 배열의 첫번째로 가야 함
    end
end
out[0][0] = in[0][0];
out[0][1] = in[0][1];
out[0][2] = in[0][2];
out[0][3] = in[0][3];

out[1][0] = in[1][1];
out[1][1] = in[1][2];
out[1][2] = in[1][3];
out[1][3] = in[1][0];

out[2][0] = in[2][2];
out[2][2] = in[2][0];
out[2][1] = in[2][3];
out[2][3] = in[2][1];

out[3][0] = in[3][3];
out[3][3] = in[3][2];
out[3][2] = in[3][1];
out[3][1] = in[3][0];

for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        outs[(i * 32) + (j * 8) +: 8] = out[3-i][3-j]; // 128 bit 로 바꿔주는 연산 : 배열의 앞부분이 LSB로 가야 함
    end
end

end
endtask

task Mix_Columns; // Mix Columns
input [127:0] inp;
output reg [127:0] outs;
reg [7:0] in[0:3][0:3];
reg [7:0] out[0:3][0:3];
reg [7:0] temp[0:3];
integer i, j, c;
begin
for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        in[3-i][3-j] = inp[(i * 32) + (j * 8) +: 8]; // 2차원 배열로 바꿔주는 연산 : LSB가 이차원 배열의 첫번째로 가야 함
    end
end

for ( c = 0; c < 4; c = c+1) begin
    temp[0] = in[0][c];
    temp[1] = in[1][c];
    temp[2] = in[2][c];
    temp[3] = in[3][c]; 

    out[0][c] = xtime(temp[0]) ^ (xtime(temp[1]) ^ temp[1]) ^ temp[2] ^ temp[3];
    out[1][c] = temp[0] ^ xtime(temp[1]) ^ (xtime(temp[2]) ^ temp[2]) ^ temp[3];
    out[2][c] = temp[0] ^ temp[1] ^ xtime(temp[2]) ^ (xtime(temp[3]) ^ temp[3]);
    out[3][c] = (xtime(temp[0]) ^ temp[0]) ^ temp[1] ^ temp[2] ^ xtime(temp[3]);end

        
for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        outs[(i * 32) + (j * 8) +: 8] = out[3-i][3-j]; // 128 bit 로 바꿔주는 연산 : 배열의 앞부분이 LSB로 가야 함
    end
end        
end
endtask

task Reverse_Mix_Columns; // Reverse Mix Columns
input [127:0] inp;
output reg [127:0] outs;
reg [7:0] in[0:3][0:3];
reg [7:0] out[0:3][0:3];
reg [7:0] temp [0:3];
integer i, j, c;
begin
for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        in[3-i][3-j] = inp[(i * 32) + (j * 8) +: 8]; // 2차원 배열로 바꿔주는 연산 : LSB가 이차원 배열의 첫번째로 가야 함     
    end
end
for (c = 0; c < 4; c = c + 1) begin
     temp[0] = in[0][c];
     temp[1] = in[1][c];
     temp[2] = in[2][c];
     temp[3] = in[3][c];
     
     out[0][c] = multiply(temp[0], 8'h0E) ^ multiply(temp[1], 8'h0B) ^ multiply(temp[2], 8'h0D) ^ multiply(temp[3], 8'h09);
     out[1][c] = multiply(temp[0], 8'h09) ^ multiply(temp[1], 8'h0E) ^ multiply(temp[2], 8'h0B) ^ multiply(temp[3], 8'h0D);
     out[2][c] = multiply(temp[0], 8'h0D) ^ multiply(temp[1], 8'h09) ^ multiply(temp[2], 8'h0E) ^ multiply(temp[3], 8'h0B);
     out[3][c] = multiply(temp[0], 8'h0B) ^ multiply(temp[1], 8'h0D) ^ multiply(temp[2], 8'h09) ^ multiply(temp[3], 8'h0E); 
     end
for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        outs[(i * 32) + (j * 8) +: 8] = out[3-i][3-j]; // 128 bit 로 바꿔주는 연산 : 배열의 앞부분이 LSB로 가야 함
    end
end   

end
endtask

task Reverse_Shift_Rows; // Reverse Shift Rows
input [127:0] inp;
output reg [127:0] outs;
reg [7:0] in[0:3][0:3];
reg [7:0] out[0:3][0:3];
integer i, j;
begin
for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        in[3-i][3-j] = inp[(i * 32) + (j * 8) +: 8]; // 2차원 배열로 바꿔주는 연산 : LSB가 이차원 배열의 첫번째로 가야 함
    end
end

out[0][3] = in[0][3];
out[0][2] = in[0][2];
out[0][1] = in[0][1];
out[0][0] = in[0][0];

out[1][3] = in[1][2];
out[1][2] = in[1][1];
out[1][1] = in[1][0];
out[1][0] = in[1][3];

out[2][0] = in[2][2];
out[2][2] = in[2][0];
out[2][1] = in[2][3];
out[2][3] = in[2][1];

out[3][0] = in[3][1];
out[3][1] = in[3][2];
out[3][2] = in[3][3];
out[3][3] = in[3][0];

for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
        outs[(i * 32) + (j * 8) +: 8] = out[3-i][3-j]; // 128 bit 로 바꿔주는 연산 : 배열의 앞부분이 LSB로 가야 함
    end
end 
end
endtask

task Reverse_Byte_Substitution; 
input [127:0] in;
output reg [127:0] out;
integer i;
begin
for(i = 0; i < 128; i = i + 8)
    out[i +: 8] = findIndexInSBox(in[i +: 8]);
end
endtask
endmodule
