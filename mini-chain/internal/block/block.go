type Block struct {
    Number       uint64
    Timestamp    int64
    PrevHash     string

    Transactions []Transaction

    Nonce        uint64
    Hash         string
}