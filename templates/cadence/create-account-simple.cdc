transaction(publicKeys: [String], sigAlgos: [SignatureAlgorithm], hashAlgos: [HashAlgorithm], weights: [UFix64] contracts: {String: String}) {
	prepare(signer: AuthAccount) {
		let acct = AuthAccount(payer: signer)

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

		for contract in contracts.keys {
			acct.contracts.add(name: contract, code: contracts[contract]!.decodeHex())
		}
	}
}
