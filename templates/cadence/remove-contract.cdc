transaction(name: String) {
	prepare(signer: auth(RemoveContract) &Account) {
		signer.contracts.remove(name: name)
	}
}
