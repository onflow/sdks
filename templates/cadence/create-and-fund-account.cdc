import Crypto
import "FlowToken"
import "FungibleToken"

transaction(publicKeys: [Crypto.KeyListEntry], contracts: {String: String}, fundAmount: UFix64) {
    let tokenReceiver: &{FungibleToken.Receiver}
    let sentVault: @FungibleToken.Vault

	prepare(signer: auth(BorrowValue) &Account) {
		let account = Account(payer: signer)

		// add all the keys to the account
		for key in publicKeys {
			account.keys.add(publicKey: key.publicKey, hashAlgorithm: key.hashAlgorithm, weight: key.weight)
		}

		// add contracts if provided
		for contract in contracts.keys {
			account.contracts.add(name: contract, code: contracts[contract]!.decodeHex())
		}

		self.tokenReceiver = account
          .capabilities.get<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)!
          .borrow()
          ?? panic("Unable to borrow receiver reference")

        let vaultRef = signer.storage.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Could not borrow reference to the owner's Vault!")

        self.sentVault <- vaultRef.withdraw(amount: fundAmount)
	}

	execute {
	    self.tokenReceiver.deposit(from: <-self.sentVault)
	}
}