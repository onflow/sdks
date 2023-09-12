transaction(name: String, code: String) {
	prepare(signer: auth(UpdateContract) &Account) {
		signer.contracts.update(name: name, code: code.decodeHex())
	}
}
