import Crypto
import "FlowToken"
import "FungibleToken"

transaction(publicKeys: [Crypto.KeyListEntry], contracts: {String: String}, fundAmount: UFix64) {
    let tokenReceiver: &{FungibleToken.Receiver}
    let sentVault: @FungibleToken.Vault

	prepare(signer: AuthAccount) {
		let account = AuthAccount(payer: signer)

		// add all the keys to the account
		for key in publicKeys {
			account.keys.add(publicKey: key.publicKey, hashAlgorithm: key.hashAlgorithm, weight: key.weight)
		}

		// add contracts if provided
		for contract in contracts.keys {
			account.contracts.add(name: contract, code: contracts[contract]!.utf8)
		}

		self.tokenReceiver = account
          .getCapability(/public/flowTokenReceiver)!
          .borrow<&{FungibleToken.Receiver}>()
          ?? panic("Unable to borrow receiver reference")

        let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Could not borrow reference to the owner's Vault!")

        self.sentVault <- vaultRef.withdraw(amount: fundAmount)
	}

	execute {
	    self.tokenReceiver.deposit(from: <-self.sentVault)
	}
}