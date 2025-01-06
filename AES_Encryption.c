#include <stdio.h>
#include <string.h>
#include <stdlib.h>

static const unsigned char S_Box[256] = {
    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
};
static const unsigned char Rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36 };

static int ROUND = 0;
static int PRINT = 0;

void Key_Expansion(unsigned char in[4][4], unsigned char key[4][4]);
void Byte_Substitution(unsigned char in[4][4]);
void Shift_Row(unsigned char in[4][4]);
void Mix_Columns(unsigned char in[4][4]);
void Add_Round_Key(unsigned char in[4][4], unsigned char key[4][4]);

unsigned char xtime(unsigned char x);
void print(unsigned char uc[4][4]);

int main() {
    //unsigned char plain_text[17];
    //unsigned char key[17];
    unsigned char use_text[4][4] = { {0x32, 0x88, 0x31, 0xe0}, {0x43, 0x5a, 0x31, 0x37}, 
                                    {0xf6, 0x30, 0x98, 0x07}, {0xa8, 0x8d,0xa2,0x34} };
    unsigned char use_key[4][4] = { {0x2b, 0x28, 0xab, 0x09}, {0x7e, 0xae, 0xf7,0xcf}, 
                                    {0x15, 0xd2, 0x15, 0x4f}, {0x16, 0xa6, 0x88, 0x3c} };
    /*
    // 128bit plain text를 입력받은 후, use_text에 복사합니다.
    printf("Input the 16bytes plain text\n");
    if (fgets(plain_text, sizeof(plain_text), stdin) == NULL) {
        perror(plain_text);
        exit(-1);
    }
    memcpy(use_text, plain_text, 16);
    while (getchar() != '\n');
   
    // 128bit key를 입력받습니다.
    printf("Input the 16bytes key\n");
    if (fgets(key, sizeof(key), stdin) == NULL) {
        perror(key);
        exit(-1);
    }
    memcpy(use_key, key, 16);
    while (getchar() != '\n');

    printf("\nPlan text : \n");
    print(use_text);

    printf("\nOrigin Key: \n");
    print(use_key);*/

    printf("Plain text : \n");
    print(use_text);

    Add_Round_Key(use_text, use_key);
    for (ROUND = 1; ROUND <= 10; ROUND++) {
        unsigned char round_key[4][4];
        Key_Expansion(use_key, round_key);

        Byte_Substitution(use_text);
        Shift_Row(use_text);
        Mix_Columns(use_text);
        Add_Round_Key(use_text, round_key);

        memcpy(use_key, round_key, 16);
    }

    printf("\nCiphertext : \n");
    print(use_text);
}

void Key_Expansion(unsigned char in[4][4], unsigned char key[4][4]) {

    unsigned char temp[4];
    unsigned char r[4] = { 0 };

    //마지막 열을 temp에 shift하여 저장
    temp[0] = S_Box[in[1][3]];
    temp[1] = S_Box[in[2][3]];
    temp[2] = S_Box[in[3][3]];
    temp[3] = S_Box[in[0][3]];

    //Rcon 정의
    r[0] = Rcon[ROUND - 1];

    //key 정의

    for (int j = 0; j < 4; j++) {
        key[j][0] = in[j][0] ^ temp[j] ^ r[j];
    }

    //나머지 열 정의
    for (int i = 1; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            key[j][i] = in[j][i] ^ key[j][i - 1];
        }
    }

}
void Byte_Substitution(unsigned char in[4][4]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            in[i][j] = S_Box[in[i][j]];
        }
    }

    if (PRINT) {
        printf("\nByte Substitution: \n");
        print(in);
    }
}
void Shift_Row(unsigned char in[4][4]) {
    unsigned char temp;

    temp = in[1][0];
    in[1][0] = in[1][1];
    in[1][1] = in[1][2];
    in[1][2] = in[1][3];
    in[1][3] = temp;

    temp = in[2][0];
    in[2][0] = in[2][2];
    in[2][2] = temp;
    temp = in[2][1];
    in[2][1] = in[2][3];
    in[2][3] = temp;

    temp = in[3][0];
    in[3][0] = in[3][3];
    in[3][3] = in[3][2];
    in[3][2] = in[3][1];
    in[3][1] = temp;

    if (PRINT) {
        printf("\nShift Row: \n");
        print(in);
    }    
}
void Mix_Columns(unsigned char in[4][4]) {
    if (ROUND == 10) return;
    unsigned char temp[4];

    for (int c = 0; c < 4; c++) {
        temp[0] = in[0][c];
        temp[1] = in[1][c];
        temp[2] = in[2][c];
        temp[3] = in[3][c];

        in[0][c] = xtime(temp[0]) ^ (xtime(temp[1]) ^ temp[1]) ^ temp[2] ^ temp[3];
        in[1][c] = temp[0] ^ xtime(temp[1]) ^ (xtime(temp[2]) ^ temp[2]) ^ temp[3];
        in[2][c] = temp[0] ^ temp[1] ^ xtime(temp[2]) ^ (xtime(temp[3]) ^ temp[3]);
        in[3][c] = (xtime(temp[0]) ^ temp[0]) ^ temp[1] ^ temp[2] ^ xtime(temp[3]);
    }

    if (PRINT) {
        printf("\nMix Columns: \n");
        print(in);
    }
}
void Add_Round_Key(unsigned char in[4][4], unsigned char key[4][4]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            in[i][j] = in[i][j] ^ key[i][j];
        }
    }
    //printf("\nAdd Round Key: \n");
    //print(in);
}

unsigned char xtime(unsigned char x) {
    return (x << 1) ^ ((x & 0x80) ? 0x1B : 0x00);
}
void print(unsigned char uc[4][4]) {
    printf("\n");
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%02X ", uc[i][j]);
        }
        printf("\n");
    }
}