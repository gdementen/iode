/*
SHA-1 in C
By Steve Reid <sreid@sea-to-sky.net>
100% Public Domain

Test Vectors (from FIPS PUB 180-1)
"abc"
  A9993E36 4706816A BA3E2571 7850C26C 9CD0D89D
"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
  84983E44 1C3BD26E BAAE4AA1 F95129E5 E54670F1
A million repetitions of "a"
  34AA973C D4C4DAA4 F61EEB2B DBAD2731 6534016F
*/

/* #define SHA1HANDSOFF  */
#include <stdio.h>
#include <string.h>

typedef signed char             int8_t;
typedef short int               int16_t;
typedef int                     int32_t;
typedef __int64                 int64_t;

typedef unsigned char             uint8_t;
typedef unsigned short int        uint16_t;
typedef unsigned int              uint32_t;

typedef struct {
    uint32_t state[5];
    uint32_t count[2];
    uint8_t  buffer[64];
} SHA1_CTX;

#define SHA1_DIGEST_SIZE 20

void SHA1_Init(SHA1_CTX* context);
void SHA1_Update(SHA1_CTX* context, const uint8_t* data, const size_t len);
void SHA1_Final(SHA1_CTX* context, uint8_t digest[SHA1_DIGEST_SIZE]);
void SHA1_Transform(uint32_t state[5], const uint8_t buffer[64]);
unsigned char *SCR_sha1(unsigned char *txt, unsigned char *res);

#define rol(value, bits) (((value) << (bits)) | ((value) >> (32 - (bits))))

/* blk0() and blk() perform the initial expand. */
/* I got the idea of expanding during the round function from SSLeay */
/* FIXME: can we do this in an endian-proof way? */
#ifdef WORDS_BIGENDIAN
#define blk0(i) block->l[i]
#else
#define blk0(i) (block->l[i] = (rol(block->l[i],24)&0xFF00FF00) \
    |(rol(block->l[i],8)&0x00FF00FF))
#endif
#define blk(i) (block->l[i&15] = rol(block->l[(i+13)&15]^block->l[(i+8)&15] \
    ^block->l[(i+2)&15]^block->l[i&15],1))

/* (R0+R1), R2, R3, R4 are the different operations used in SHA1 */
#define R0(v,w,x,y,z,i) z+=((w&(x^y))^y)+blk0(i)+0x5A827999+rol(v,5);w=rol(w,30);
#define R1(v,w,x,y,z,i) z+=((w&(x^y))^y)+blk(i)+0x5A827999+rol(v,5);w=rol(w,30);
#define R2(v,w,x,y,z,i) z+=(w^x^y)+blk(i)+0x6ED9EBA1+rol(v,5);w=rol(w,30);
#define R3(v,w,x,y,z,i) z+=(((w|x)&y)|(w&x))+blk(i)+0x8F1BBCDC+rol(v,5);w=rol(w,30);
#define R4(v,w,x,y,z,i) z+=(w^x^y)+blk(i)+0xCA62C1D6+rol(v,5);w=rol(w,30);


#ifdef VERBOSE  /* SAK */
void SHAPrintContext(SHA1_CTX *context, char *msg){
  printf("%s (%d,%d) %x %x %x %x %x\n",
	 msg,
	 context->count[0], context->count[1],
	 context->state[0],
	 context->state[1],
	 context->state[2],
	 context->state[3],
	 context->state[4]);
}
#endif /* VERBOSE */

/*NH Hash a single 512-bit block. This is the core of the algorithm. */
void SHA1_Transform(uint32_t state[5], const uint8_t buffer[64])
{
    uint32_t a, b, c, d, e;
    typedef union {
        uint8_t c[64];
        uint32_t l[16];
    } CHAR64LONG16;
    CHAR64LONG16* block;

#ifdef SHA1HANDSOFF
    static uint8_t workspace[64];
    block = (CHAR64LONG16*)workspace;
    memcpy(block, buffer, 64);
#else
    block = (CHAR64LONG16*)buffer;
#endif

    /* Copy context->state[] to working vars */
    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];
    e = state[4];

    /* 4 rounds of 20 operations each. Loop unrolled. */
    R0(a,b,c,d,e, 0); R0(e,a,b,c,d, 1); R0(d,e,a,b,c, 2); R0(c,d,e,a,b, 3);
    R0(b,c,d,e,a, 4); R0(a,b,c,d,e, 5); R0(e,a,b,c,d, 6); R0(d,e,a,b,c, 7);
    R0(c,d,e,a,b, 8); R0(b,c,d,e,a, 9); R0(a,b,c,d,e,10); R0(e,a,b,c,d,11);
    R0(d,e,a,b,c,12); R0(c,d,e,a,b,13); R0(b,c,d,e,a,14); R0(a,b,c,d,e,15);
    R1(e,a,b,c,d,16); R1(d,e,a,b,c,17); R1(c,d,e,a,b,18); R1(b,c,d,e,a,19);
    R2(a,b,c,d,e,20); R2(e,a,b,c,d,21); R2(d,e,a,b,c,22); R2(c,d,e,a,b,23);
    R2(b,c,d,e,a,24); R2(a,b,c,d,e,25); R2(e,a,b,c,d,26); R2(d,e,a,b,c,27);
    R2(c,d,e,a,b,28); R2(b,c,d,e,a,29); R2(a,b,c,d,e,30); R2(e,a,b,c,d,31);
    R2(d,e,a,b,c,32); R2(c,d,e,a,b,33); R2(b,c,d,e,a,34); R2(a,b,c,d,e,35);
    R2(e,a,b,c,d,36); R2(d,e,a,b,c,37); R2(c,d,e,a,b,38); R2(b,c,d,e,a,39);
    R3(a,b,c,d,e,40); R3(e,a,b,c,d,41); R3(d,e,a,b,c,42); R3(c,d,e,a,b,43);
    R3(b,c,d,e,a,44); R3(a,b,c,d,e,45); R3(e,a,b,c,d,46); R3(d,e,a,b,c,47);
    R3(c,d,e,a,b,48); R3(b,c,d,e,a,49); R3(a,b,c,d,e,50); R3(e,a,b,c,d,51);
    R3(d,e,a,b,c,52); R3(c,d,e,a,b,53); R3(b,c,d,e,a,54); R3(a,b,c,d,e,55);
    R3(e,a,b,c,d,56); R3(d,e,a,b,c,57); R3(c,d,e,a,b,58); R3(b,c,d,e,a,59);
    R4(a,b,c,d,e,60); R4(e,a,b,c,d,61); R4(d,e,a,b,c,62); R4(c,d,e,a,b,63);
    R4(b,c,d,e,a,64); R4(a,b,c,d,e,65); R4(e,a,b,c,d,66); R4(d,e,a,b,c,67);
    R4(c,d,e,a,b,68); R4(b,c,d,e,a,69); R4(a,b,c,d,e,70); R4(e,a,b,c,d,71);
    R4(d,e,a,b,c,72); R4(c,d,e,a,b,73); R4(b,c,d,e,a,74); R4(a,b,c,d,e,75);
    R4(e,a,b,c,d,76); R4(d,e,a,b,c,77); R4(c,d,e,a,b,78); R4(b,c,d,e,a,79);

    /* Add the working vars back into context.state[] */
    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;

    /* Wipe variables */
    a = b = c = d = e = 0;
}


/*NH SHA1Init - Initialize new context */
void SHA1_Init(SHA1_CTX* context)
{
    /* SHA1 initialization constants */
    context->state[0] = 0x67452301;
    context->state[1] = 0xEFCDAB89;
    context->state[2] = 0x98BADCFE;
    context->state[3] = 0x10325476;
    context->state[4] = 0xC3D2E1F0;
    context->count[0] = context->count[1] = 0;
}


/*NH Run your data through this. */
void SHA1_Update(SHA1_CTX* context, const uint8_t* data, const size_t len)
{
    size_t i, j;

#ifdef VERBOSE
    SHAPrintContext(context, "before");
#endif

    j = (context->count[0] >> 3) & 63;
    if ((context->count[0] += len << 3) < (len << 3)) context->count[1]++;
    context->count[1] += (len >> 29);
    if ((j + len) > 63) {
        memcpy(&context->buffer[j], data, (i = 64-j));
        SHA1_Transform(context->state, context->buffer);
        for ( ; i + 63 < len; i += 64) {
            SHA1_Transform(context->state, data + i);
        }
        j = 0;
    }
    else i = 0;
    memcpy(&context->buffer[j], &data[i], len - i);

#ifdef VERBOSE
    SHAPrintContext(context, "after ");
#endif
}

/*NH Add padding and return the message digest. */
void SHA1_Final(SHA1_CTX* context, uint8_t digest[SHA1_DIGEST_SIZE])
{
    uint32_t i;
    uint8_t  finalcount[8];

    for (i = 0; i < 8; i++) {
        finalcount[i] = (unsigned char)((context->count[(i >= 4 ? 0 : 1)]
         >> ((3-(i & 3)) * 8) ) & 255);  /* Endian independent */
    }
    SHA1_Update(context, (uint8_t *)"\200", 1);
    while ((context->count[0] & 504) != 448) {
        SHA1_Update(context, (uint8_t *)"\0", 1);
    }
    SHA1_Update(context, finalcount, 8);  /* Should cause a SHA1_Transform() */
    for (i = 0; i < SHA1_DIGEST_SIZE; i++) {
        digest[i] = (uint8_t)
         ((context->state[i>>2] >> ((3-(i & 3)) * 8) ) & 255);
    }

    /* Wipe variables */
    i = 0;
    memset(context->buffer, 0, 64);
    memset(context->state, 0, 20);
    memset(context->count, 0, 8);
    memset(finalcount, 0, 8);	/* SWR */

#ifdef SHA1HANDSOFF  /* make SHA1Transform overwrite its own static vars */
    SHA1_Transform(context->state, context->buffer);
#endif
}

/* =================================================================
Computes the sha-1 hash on a zstring.

&EN U_ch *txt : string to hash
&EN U_ch *res : result (buffer must contain enough space, ie 21 ?)

&RT res
------------------------------------------------------------------- */

unsigned char *SCR_sha1(unsigned char *txt, unsigned char *res)
{
    SHA1_CTX context;

    SHA1_Init(&context);
    SHA1_Update(&context, (uint8_t*)txt, strlen(txt));
    SHA1_Final(&context, res);
    res[SHA1_DIGEST_SIZE] = 0;
    return(res);
}

/*************************************************************/

#if 0
int main(int argc, char** argv)
{
int i, j;
SHA1_CTX context;
unsigned char digest[SHA1_DIGEST_SIZE], buffer[16384];
FILE* file;

    if (argc > 2) {
        puts("Public domain SHA-1 implementation - by Steve Reid <sreid@sea-to-sky.net>");
        puts("Modified for 16 bit environments 7/98 - by James H. Brown <jbrown@burgoyne.com>");	/* JHB */
        puts("Produces the SHA-1 hash of a file, or stdin if no file is specified.");
        return(0);
    }
    if (argc < 2) {
        file = stdin;
    }
    else {
        if (!(file = fopen(argv[1], "rb"))) {
            fputs("Unable to open file.", stderr);
            return(-1);
        }
    }
    SHA1_Init(&context);
    while (!feof(file)) {  /* note: what if ferror(file) */
        i = fread(buffer, 1, 16384, file);
        SHA1_Update(&context, buffer, i);
    }
    SHA1_Final(&context, digest);
    fclose(file);
    for (i = 0; i < SHA1_DIGEST_SIZE/4; i++) {
        for (j = 0; j < 4; j++) {
            printf("%02X", digest[i*4+j]);
        }
        putchar(' ');
    }
    putchar('\n');
    return(0);	/* JHB */
}
#endif



/* self test */

//#define TEST
#ifdef TEST

static char *test_data[] = {
    "abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
    "A million repetitions of 'a'"};
static char *test_results[] = {
    "A9993E36 4706816A BA3E2571 7850C26C 9CD0D89D",
    "84983E44 1C3BD26E BAAE4AA1 F95129E5 E54670F1",
    "34AA973C D4C4DAA4 F61EEB2B DBAD2731 6534016F"};


void digest_to_hex(const uint8_t digest[SHA1_DIGEST_SIZE], char *output)
{
    int i,j;
    char *c = output;

    for (i = 0; i < SHA1_DIGEST_SIZE/4; i++) {
        for (j = 0; j < 4; j++) {
            sprintf(c,"%02X", digest[i*4+j]);
            c += 2;
        }
        sprintf(c, " ");
        c += 1;
    }
    *(c - 1) = '\0';
}

/* Test */
int main(int argc, char** argv)
{
    int k;
    SHA1_CTX context;
    uint8_t digest[20];
    char output[80];

    fprintf(stdout, "verifying SHA-1 implementation... ");

    for (k = 0; k < 2; k++){
        /*SHA1_Init(&context);
        SHA1_Update(&context, (uint8_t*)test_data[k], strlen(test_data[k]));
        SHA1_Final(&context, digest);
        */
        SHA1(test_data[k], digest);
        
	digest_to_hex(digest, output);

        if (strcmp(output, test_results[k])) {
            fprintf(stdout, "FAIL\n");
            fprintf(stderr,"* hash of \"%s\" incorrect:\n", test_data[k]);
            fprintf(stderr,"\t%s returned\n", output);
            fprintf(stderr,"\t%s is correct\n", test_results[k]);
            return (1);
        }
    }
    // million 'a' vector we feed separately 
    SHA1_Init(&context);
    for (k = 0; k < 1000000; k++)
        SHA1_Update(&context, (uint8_t*)"a", 1);
    SHA1_Final(&context, digest);
    digest_to_hex(digest, output);
    if (strcmp(output, test_results[2])) {
        fprintf(stdout, "FAIL\n");
        fprintf(stderr,"* hash of \"%s\" incorrect:\n", test_data[2]);
        fprintf(stderr,"\t%s returned\n", output);
        fprintf(stderr,"\t%s is correct\n", test_results[2]);
        return (1);
    }

    // success 
    fprintf(stdout, "ok\n");
    return(0);
}
#endif // TEST