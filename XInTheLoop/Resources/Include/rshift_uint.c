// Return (a >> b) unsigned.
int rshift_uint(int a, int b)
{
    //ModelicaFormatMessage("rshift_uint(a=0x%x, b=0x%x) return=0x%x\n", a, b, ((unsigned)a >> b));
    return (unsigned)a >> b;
}
