import Crypto

transaction(key: Crypto.KeyListEntry) {
	prepare(signer: auth(AddKey) &Account) {
		signer.keys.add(publicKey: key.publicKey, hashAlgorithm: key.hashAlgorithm, weight: key.weight)
	}
}
