transaction(publicKeys: [String], contracts: {String: String}) {
	prepare(signer: AuthAccount) {
		let acct = AuthAccount(payer: signer)

		for publicKey in publicKeys {
		    let key = PublicKey(
			publicKey: publicKey.decodeHex(),
			signatureAlgorithm: SignatureAlgorithm.ECDSA_P256
		    )

		    acct.keys.add(
			publicKey: key,
			hashAlgorithm: HashAlgorithm.SHA3_256,
			weight: 10.0
		    )
		}

		for contract in contracts.keys {
			acct.contracts.add(name: contract, code: contracts[contract]!.decodeHex())
		}
	}
}
