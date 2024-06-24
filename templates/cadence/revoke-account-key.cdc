transaction(keyIndex: Int) {
	prepare(signer: auth(RevokeKey) &Account) {
		signer.keys.revoke(keyIndex: keyIndex)
	}
}
