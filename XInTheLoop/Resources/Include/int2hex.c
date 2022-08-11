const char *int2hex(int value, int n_digits)
{
    char *spBuf = ModelicaAllocateStringWithErrorReturn(n_digits);
    if (!spBuf) {
        ModelicaError("int2hex(): ModelicaAllocateString failed\n");
        return "";
    }
    int i = n_digits;
    while (i > 0) {
        spBuf[--i] = "0123456789ABCDEF"[value & 0xf];
        value >>= 4;
    }
    return (const char*)spBuf;
}
