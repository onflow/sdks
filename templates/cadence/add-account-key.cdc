transaction(publicKey: String) {
	prepare(signer: AuthAccount) {
		let key = PublicKey(
            publicKey: publicKey,
            signatureAlgorithm: SignatureAlgorithm.ECDSA_P256
        )

        signer.keys.add(
            publicKey: key,
            hashAlgorithm: HashAlgorithm.SHA3_256,
            weight: 10.0
        )
	}
}
