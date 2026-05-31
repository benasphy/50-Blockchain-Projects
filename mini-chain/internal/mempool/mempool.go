type Mempool struct {
    Pending []Transaction
}

func (m *Mempool) Add(
    tx Transaction,
) {
    m.Pending =
        append(
            m.Pending,
            tx,
        )
}