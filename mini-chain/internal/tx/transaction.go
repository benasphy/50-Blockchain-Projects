type Transaction struct {
    From      string
    To        string
    Value     uint64
    Nonce     uint64
    GasLimit  uint64
    Data      []byte

    Signature []byte
}