func GetBalance(
    address string,
) uint64 {

    return state
        .Accounts[address]
        .Balance
}