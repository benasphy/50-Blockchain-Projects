func ApplyTx(
    state *State,
    tx Transaction,
) error {

    sender :=
        state.Accounts[tx.From]

    receiver :=
        state.Accounts[tx.To]

    sender.Balance -= tx.Value

    receiver.Balance += tx.Value

    sender.Nonce++

    return nil
}