transaction(publicKeys: [String], sigAlgos: [SignatureAlgorithm], hashAlgos: [HashAlgorithm], weights: [UFix64], contracts: {String: String}) {
	prepare(signer: auth(BorrowValue) &Account) {
		let acct = Account(payer: signer)

		if (sigAlgos.length != publicKeys.length || hashAlgos.length != publicKeys.length || weights.length != publicKeys.length) {
			panic("Length missmatch of passed arguments: public keys, signature algorithms, hashing algorithms and weights arrays must all have same length.")
		}

		for i, publicKey in publicKeys {
			let key = PublicKey(
				publicKey: publicKey.decodeHex(),
				signatureAlgorithm: sigAlgos[i]
			)

			acct.keys.add(
				publicKey: key,
				hashAlgorithm: hashAlgos[i],
				weight: weights[i]
			)
		}

		for contractName in contracts.keys {
			acct.contracts.add(name: contractName, code: contracts[contractName]!.decodeHex())
		}
	}
}
