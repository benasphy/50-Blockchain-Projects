func MineBlock(
    block *Block,
) {

    for {

        hash := CalculateHash(
            block,
        )

        if strings.HasPrefix(
            hash,
            "0000",
        ) {
            block.Hash = hash
            break
        }

        block.Nonce++
    }
}