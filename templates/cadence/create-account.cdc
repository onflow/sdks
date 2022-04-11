import Crypto

transaction(publicKeys: [Crypto.KeyListEntry], contracts: {String: String}) {
	prepare(signer: AuthAccount) {
		let acct = AuthAccount(payer: signer)

		
		for contract in contracts.keys {
			acct.contracts.add(name: contract, code: contracts[contract]!.decodeHex())
		}
	}
}
